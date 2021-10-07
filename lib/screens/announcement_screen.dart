import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/widgets/announcements_list.dart';

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Announcements', style: customTextStyle(fontFamily: appFontBold, color: Colors.white, fontSize: 18)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [

                  appColorPrimary,
                  appColorPrimary,
                ],
              ),
            ),
          ),
        ),
      body: AnnouncementsList(),
    );
  }
}
