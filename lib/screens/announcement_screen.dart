import 'package:flutter/material.dart';
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
          title: Text('Announcements', style: TextStyle(fontFamily: 'AllerBold'),),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [

                  Colors.blueAccent,
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
          ),
        ),
      body: AnnouncementsList(),
    );
  }
}
