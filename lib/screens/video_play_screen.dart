import 'package:flutter/material.dart';
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
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {},
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
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
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              player,
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: Text(
                  widget.title,
                  style: TextStyle(fontFamily: 'AllerBold', fontSize: 20.0),
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
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontFamily: 'AllerBold'),
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
                  style: TextStyle(
                      fontFamily: 'Aller', fontSize: 18.0, color: Colors.grey),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
