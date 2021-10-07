import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/functions/utf8_convert.dart';
import 'package:mw/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:mw/screens/posts_screen.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  void initState() {
    super.initState();
    fetchPosts().then((value) {
      setState(() {
        _posts.addAll(value);
      });
    });
  }

  List<Post> _posts = <Post>[];

  Future<List<Post>> fetchPosts() async {
    var url = 'https://drive.google.com/uc?export=download&id=1fOf3pxsZgrmNL-vLF14-GZRPQzeY5MFE';
    var response = await http.get(url);
    var post = <Post>[];

    if (response.statusCode == 200) {
      print('Status Code: OK');
      var postsJson = json.decode(response.body);
      for (var postJson in postsJson) {
        post.add(Post.fromJson(postJson));
      }
    }
    return post;
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            //index > 0 ? Announcements() : SizedBox.shrink();
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PostScreen(_posts[index].imageUrl, _posts[index].title,_posts[index].content, _posts[index].postDate, _posts[index].imageUrl)
                ));
              },
              child: Container(
                margin: EdgeInsets.only(top: 15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: appBackgroundColorSecondary,
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
                        '${utf8convert(_posts[index].title)}',
                        style: customTextStyle(
                            fontSize: 20.0, fontFamily: appFontBold),
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
                            '${_posts[index].postDate}',
                            style: customTextStyle(
                                fontSize: 14.0, fontFamily: appFont, color: appFontColorSecondary),
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
                      child: Hero(tag: _posts[index].imageUrl,child: Image.network('${_posts[index].imageUrl}')),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Text(
                        '${utf8convert(_posts[index].content)}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: customTextStyle(
                          color: appFontColorSecondary,
                          fontSize: 14.0,
                          fontFamily: appFont,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 20.0),
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PostScreen(_posts[index].imageUrl, _posts[index].title,_posts[index].content, _posts[index].postDate, _posts[index].imageUrl)
                          ));
                        },
                        child: Text(
                          'Read more...',
                          style: customTextStyle(fontSize: 15.0,fontFamily: appFontBold, color: appFontColorSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
