import 'dart:convert';
import 'package:gradient_text/gradient_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/downloader.dart';
import 'package:mw/functions/network_ping.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/announcement_model.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/screens/announcement_screen.dart';
import 'package:mw/screens/home_screen.dart';
import 'package:mw/screens/search_screen.dart';
import 'package:mw/screens/settings_screen.dart';
import 'package:mw/screens/video_screen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<List<Member>> members;
  var dBHelper = DbHelper();
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(() => _handleTabSelection());
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

    _showNotification();

    fetchAnnouncements().then((value) {
      setState(() {
        _announcement.addAll(value);
      });
    });
    //
    //dlDB();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Announcement> _announcement = List<Announcement>();

  Future<List<Announcement>> fetchAnnouncements() async {
    var url = 'https://mwapp.imfast.io/announcements/announcements.json';
    var response = await http.get(url);
    var announcement = List<Announcement>();

    if (response.statusCode == 200) {
      var postsJson = json.decode(response.body);
      for (var postJson in postsJson) {
        announcement.add(Announcement.fromJson(postJson));
      }
    }
    return announcement;
  }

  _handleTabSelection() {
    setState(() {
      print('${_tabController.index}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () =>
            customDialog(
                context, 'Exit App', 'Are you sure you want to exit?', false,
                onPressedNo: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                onPressedYes: () => SystemNavigator.pop()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.75,
            title: GradientText("Mengal Women",
                gradient: LinearGradient(
                    colors: [Theme
                        .of(context)
                        .primaryColor, Colors.blue[800], Colors.blue[600]]),
                style: TextStyle(fontFamily: 'AllerBold',
                    letterSpacing: -1.5,
                    fontSize: 25.0),
                textAlign: TextAlign.center),
            actions: [
              Stack(
                children: [
                  IconButton(
                    color: Theme
                        .of(context)
                        .accentColor,
                    icon: Icon(OMIcons.chat),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AnnouncementScreen()));
                    },
                  ),
                  _announcement.length > 0
                      ? Positioned(
                    top: 6.0,
                    left: 25.0,
                    child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${_announcement.length}',
                          style: TextStyle(
                              fontSize: 8.0, color: Colors.white),
                        )),
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ],
            //Image.asset('assets/images/logo.png', width: 150.0,),
            bottom: TabBar(
                controller: _tabController,
                indicatorWeight: 5.0,
                indicatorColor: Theme
                    .of(context)
                    .primaryColor,
                tabs: [
                  Tab(
                    icon: Icon(
                      OMIcons.home,
                      color: _tabController.index == 0 ? Theme
                          .of(context)
                          .primaryColor : Colors.grey[500],
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      OMIcons.videoLibrary,
                      color: _tabController.index == 1 ? Theme
                          .of(context)
                          .primaryColor : Colors.grey[500],
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.search,
                      color: _tabController.index == 2 ? Theme
                          .of(context)
                          .primaryColor : Colors.grey[500],
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      OMIcons.settings,
                      color: _tabController.index == 3 ? Theme
                          .of(context)
                          .primaryColor : Colors.grey[500],
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              HomeScreen(),
              VideoScreen(),
              SearchScreen(),
              SettingsScreen()
            ],
          ),
        ),
      ),
    );
  }

  //==================================================================================================================================================

  void dlDB() async {
    await hasInternetConnection().then((value) {
      print(value);
      value
          ? downloadDatabase(context)
          : print('no network connection.');
    });
  }

  Future _showNotification() async {
    //For instant notification
    //var androidDetails = AndroidNotificationDetails("Mengal Women Notification", "Mengal Women", "Mengal Women Notification Channel", importance: Importance.Max);
    //var iosDetails = IOSNotificationDetails();
    //var generalNotificationDetails = NotificationDetails(androidDetails, iosDetails);

    //await flutterLocalNotificationsPlugin.show(0,"Title", "Content", generalNotificationDetails);

//SCHEDULED NOTIFICATION - DAILY
    var time = Time(8, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Mengal Women Notification',
        'Mengal Women',
        'Mengal Women Notification Channel');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Good morning ka-Mengal Women!',
        'Have a great day today!',
        time,
        platformChannelSpecifics);
  }

  Future selectNotification(String payload) async {
    //if (payload != null) {
    //debugPrint('notification payload: ' + payload);
    //}
    //await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
//    showDialog(
//      context: context,
//      builder: (BuildContext context) => CupertinoAlertDialog(
//        title: Text(title),
//        content: Text(body),
//        actions: [
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: Text('Ok'),
//            onPressed: () async {
//             Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => HomeScreen(),
//                ),
//              );
//            },
//          )
//        ],
//      ),
//    );
  }

//==================================================================================================================================================
}
