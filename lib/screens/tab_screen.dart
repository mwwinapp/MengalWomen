import 'dart:convert';
import 'package:gradient_text/gradient_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/downloader.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/functions/network_ping.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/announcement_model.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/screens/announcement_screen.dart';
import 'package:mw/screens/home_screen.dart';
import 'package:mw/screens/searchbar_screen.dart';
import 'package:mw/screens/settings_screen.dart';
import 'package:mw/screens/video_screen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'dashboard_screen.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  Future<List<Member>> members;
  var dBHelper = DbHelper();
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4, initialIndex: 0);
    _tabController.addListener(() => _handleTabSelection());
    fetchAnnouncements().then((value) {
      setState(() {
        _announcement.addAll(value);
      });
    });
    //
    downloaderInit();
    //dlDB();             //REMINDER: Remove this only if database is updated and tblenduser is added
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Announcement> _announcement = <Announcement>[];

  Future<List<Announcement>> fetchAnnouncements() async {
    var url = 'https://drive.google.com/uc?export=download&id=1Wno_h7_U481E8aR4y7bR-CY1ZuHYpnnO';
    var response = await http.get(url);
    var announcement = <Announcement>[];

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
            automaticallyImplyLeading: false,
            backgroundColor: appBackgroundColorPrimary,
            elevation: 0.75,
            title: GradientText("Mengal Women",
                gradient: LinearGradient(
                    colors: [appColorPrimary, appColorPrimary, appColorPrimary]),
                style: customTextStyle(fontFamily: appFontBold,
                    letterSpacing: -1.5,
                    fontSize: 25.0),
                textAlign: TextAlign.center),
            actions: [
              IconButton(
                color: appColorPrimary,
                icon: Icon(Icons.search),
                onPressed: () {
                  print(_announcement.length);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SearchBarScreen()));
                },
              ),
              Stack(
                children: [
                  IconButton(
                    color: appColorPrimary,
                    icon: Icon(OMIcons.chat),
                    onPressed: () {
                      //print(_announcement.length);
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
                          style: customTextStyle(
                              fontSize: 8.0, color: appBackgroundColorPrimary),
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
                indicatorColor: appColorPrimary,
                tabs: [
                  Tab(
                    icon: Icon(
                      OMIcons.dashboard,
                      color: _tabController.index == 0 ? appColorPrimary : Colors.grey[500],
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      OMIcons.timeline,
                      color: _tabController.index == 1 ? appColorPrimary : Colors.grey[500],
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      OMIcons.videoLibrary,
                      color: _tabController.index == 2 ? appColorPrimary : Colors.grey[500],
                    ),
                  ),
                  /*Tab(
                    icon: Icon(
                      Icons.search,
                      color: _tabController.index == 2 ? appColorPrimary : Colors.grey[500],
                    ),
                  ),*/
                  Tab(
                    icon: Icon(
                      Icons.menu,
                      color: _tabController.index == 3 ? appColorPrimary : Colors.grey[500],
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              DashBoardScreen(),
              HomeScreen(),
              VideoScreen(),
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
      if(value) {
        print('database download initiated...');
        downloadDatabase(context);
        //customDialog(context, 'Download complete.', 'Database successfully downloaded and updated.', true,onPressedOk: () => Navigator.of(context, rootNavigator: true).pop());
      }
    });
  }

//==================================================================================================================================================
}
