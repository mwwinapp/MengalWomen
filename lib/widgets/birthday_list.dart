import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/screens/birthday_screen.dart';

class BirthdayList extends StatefulWidget {
  @override
  _BirthdayListState createState() => _BirthdayListState();
}

class _BirthdayListState extends State<BirthdayList> {
  Future<List<Member>> members;
  var dBHelper = DbHelper();
  bool _hideBirthday = true;

  String text;
  int length;

  @override
  void initState() {
    super.initState();
     setState(() {
      members = dBHelper.birthday();
      members.then((value) {
        text = value.first.fullname;
        length = value.length;
      });
  });
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
                      style: customTextStyle(color: appFontColorSecondary, fontFamily: appFont),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _hideBirthday = true;
                        });
                      },
                      child: Text(
                        'Hide',
                        style: customTextStyle(
                            color: appColorPrimary,
                            fontFamily: appFontBold),
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
                              color: appBackgroundColorSecondary,
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
                                  usertype == 'admin' ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: 'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/photo/${members[index].mid}.jpg',
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Icon(Icons.person, color: Colors.grey, size: 40.0,),//CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary)),
                                    errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.grey, size: 40.0,),
                                  ) : Icon(Icons.person, color: Colors.grey, size: 40.0,),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '${members[index].fullname}',
                                    style: customTextStyle(fontFamily: appFontBold),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    usertype == 'admin' ? '${members[index].barangay}' : '',
                                    style: customTextStyle(
                                        color: appFontColorSecondary,
                                        fontSize: 10.0,
                                        fontFamily: appFontBold),
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
            style: customTextStyle(color: appFontColorSecondary, fontFamily: appFont),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _hideBirthday = false;
              });
            },
            child: Text(
              'Show All',
              style: customTextStyle(
                  color: appColorPrimary,
                  fontFamily: appFontBold),
            ),
          ),
        ],
      ),
    );
  }
}
