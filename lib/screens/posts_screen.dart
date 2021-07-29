import 'package:flutter/material.dart';
import 'package:mw/functions/utf8_convert.dart';

class PostScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String content;
  final String postDate;
  final String heroTag;

  const PostScreen(this.imageUrl, this.title, this.content, this.postDate,
      [this.heroTag]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('${utf8convert(title)}'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            child: Hero(tag: heroTag, child: Image.network('$imageUrl')),
          ),
          Container(
            margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            child: Text(
              '${utf8convert(title)}',
              style: TextStyle(fontSize: 25.0, fontFamily: 'AllerBold'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey, size: 12.0,),
                SizedBox(width: 5.0,),
                Text(
                  '$postDate',
                  style: TextStyle(
                      fontSize: 14.0, fontFamily: 'Aller', color: Colors.grey),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: Text(
              '${utf8convert(content)}',
              style: TextStyle(
                  fontSize: 18.0, fontFamily: 'Aller', color: Colors.black54),
            ),
          ),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }
}
