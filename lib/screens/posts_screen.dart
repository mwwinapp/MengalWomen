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
    return Scaffold(
      backgroundColor: appBackgroundColorSecondary,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: appBackgroundColorPrimary,),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        title: Text('${utf8convert(title)}', style: customTextStyle(fontFamily: appFontBold, color: appBackgroundColorPrimary, fontSize: 18),),
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
