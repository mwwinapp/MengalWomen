import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayScreen extends StatefulWidget {
  final String id;
  final String title;
  final String publishedAt;
  final String description;

  VideoPlayScreen({this.id, this.title, this.publishedAt, this.description});

  @override
  _VideoPlayScreenState createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).padding.top;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {},
      ),
      builder: (context, player) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: appBackgroundColorSecondary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            leading: CircleAvatar(
              maxRadius: 1.0,
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: appFontColorPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.only(top: topPadding),
            physics: BouncingScrollPhysics(),
            children: [
              player,
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: Text(
                  widget.title,
                  style: customTextStyle(fontFamily: appFontBold, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 12.0,
                    ),
                    Text(
                      widget.publishedAt,
                      style: customTextStyle(
                          color: appFontColorSecondary,
                          fontSize: 15.0,
                          fontFamily: appFontBold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  widget.description,
                  style: customTextStyle(
                      fontFamily: appFont, fontSize: 18.0, color: appFontColorSecondary, overflow: TextOverflow.visible),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
