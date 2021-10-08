import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
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
    var topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: appBackgroundColorSecondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            maxRadius: 1.0,
            backgroundColor: Colors.black45,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: appFontColorPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: topPadding),
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            child: Hero(tag: heroTag, child: Image.network('$imageUrl')),
          ),
          Container(
            margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            child: Text(
              '${utf8convert(title)}',
              style: customTextStyle(fontSize: 25.0, fontFamily: appFontBold),
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
                  style: customTextStyle(
                      fontSize: 14.0, fontFamily: appFont, color: appFontColorSecondary),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: Text(
              '${utf8convert(content)}',
              style: customTextStyle(
                  fontSize: 18.0, fontFamily: appFont, color: appFontColorSecondary, overflow: TextOverflow.visible),
            ),
          ),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }
}
