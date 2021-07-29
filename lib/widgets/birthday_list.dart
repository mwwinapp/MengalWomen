import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/screens/birthday_screen.dart';
import 'package:mw/functions/recase.dart';

class BirthdayList extends StatefulWidget {
  @override
  _BirthdayListState createState() => _BirthdayListState();
}

class _BirthdayListState extends State<BirthdayList> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<List<Member>> members;
  var dBHelper = DbHelper();
  bool _hideBirthday = true;

  String text;
  int length;

  @override
  void initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

    setState(() {
      members = dBHelper.birthday();
      members.then((value) {
        text = value.first.fullname;
        length = value.length;
        _showBirthdayNotification(text: properCase(text), length: length);
        print(properCase(text));
      });
  });
}

  Future _showBirthdayNotification({String text, int length}) async {

    //SCHEDULED NOTIFICATION - DAILY
    var time = Time(8, 1, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Mengal Women Birthday Notification',
        'Mengal Women',
        'Mengal Women Birthday Notification Channel');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Happy birthday mga ka-Mengal Women!',
        '🎂 $text and $length other members have birthdays today.',
        time,
        platformChannelSpecifics);
  }


  Future selectNotification(String payload) async {
    //await Navigator.push(context, MaterialPageRoute(builder: (context) => BirthdayScreen()),);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
   //
  }

  @override
  Widget build(BuildContext context) {
    if (!_hideBirthday) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BirthdayScreen(),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: 10.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 5.0,
                spreadRadius: .01,
                offset: Offset(0.0, 1.0),
              )
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat("MM/dd/yyy").format(DateTime.now())} • 🎂 Today\'s birthdays',
                      // ${DateFormat("MM/dd/yyy").format(DateTime.now())}
                      style: TextStyle(color: Colors.grey, fontFamily: 'Aller'),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _hideBirthday = true;
                        });
                      },
                      child: Text(
                        'Hide',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontFamily: 'AllerBold'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 140.0,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: FutureBuilder(
                  future: members,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Member> members = snapshot.data;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(5.0),
                            width: 100.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: .25,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    child: Icon(Icons.person),
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.25),
                                    foregroundColor: Colors.white,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '${members[index].fullname}',
                                    style: TextStyle(fontFamily: 'AllerBold'),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    '${members[index].barangay}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                        fontFamily: 'AllerBold'),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${DateFormat("MM/dd/yyy").format(DateTime.now())} • 🎂 Today\' birthdays',
            style: TextStyle(color: Colors.grey, fontFamily: 'Aller'),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _hideBirthday = false;
              });
            },
            child: Text(
              'Show All',
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'AllerBold'),
            ),
          ),
        ],
      ),
    );
  }
}
