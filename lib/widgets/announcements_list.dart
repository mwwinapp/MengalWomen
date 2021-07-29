import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mw/models/announcement_model.dart';
import 'package:mw/functions/utf8_convert.dart';
import 'package:http/http.dart' as http;

class AnnouncementsList extends StatefulWidget {
  @override
  _AnnouncementsListState createState() => _AnnouncementsListState();
}

class _AnnouncementsListState extends State<AnnouncementsList> {
  @override
  void initState() {
    super.initState();
    fetchPosts().then((value) {
      setState(() {
        _announcement.addAll(value);
      });
    });
  }

  List<Announcement> _announcement = List<Announcement>();

  Future<List<Announcement>> fetchPosts() async {
    var url = 'https://drive.google.com/uc?export=download&id=1Wno_h7_U481E8aR4y7bR-CY1ZuHYpnnO';
    var response = await http.get(url);
    var announcement = List<Announcement>();

    if (response.statusCode == 200) {
      print('Status Code: OK');
      var postsJson = json.decode(response.body);
      for (var postJson in postsJson) {
        announcement.add(Announcement.fromJson(postJson));
      }
    }
    return announcement;
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _announcement.length,
        itemBuilder: (context, index) {
          //index > 0 ? Announcements() : SizedBox.shrink();
          return GestureDetector(
            onTap: () {
              //
            },
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 5.0,
                    spreadRadius: .01,
                    offset: Offset(0.0, 1.0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 15.0, top: 20.0),
                    child: Text(
                      '${utf8convert(_announcement[index].title)}',
                      style: TextStyle(
                          fontSize: 20.0, fontFamily: 'AllerBold'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey, size: 12.0,),
                        SizedBox(width: 5.0,),
                        Text(
                          '${_announcement[index].postDate}',
                          style: TextStyle(
                              fontSize: 14.0, fontFamily: 'Aller', color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: .25,
                          color: Colors.grey.withOpacity(0.75)),
                    ),
                    child: Hero(tag: _announcement[index].imageUrl,child: Image.network('${_announcement[index].imageUrl}')),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Text(
                      '${utf8convert(_announcement[index].content)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.0,
                        fontFamily: 'Aller',
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          );
        });
  }
}
