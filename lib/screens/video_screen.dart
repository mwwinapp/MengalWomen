import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/functions/network_ping.dart';
import 'package:mw/models/channel_model.dart';
import 'package:mw/models/video_model.dart';
import 'package:mw/screens/video_play_screen.dart';
import 'package:mw/services/api_service.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Channel _channel;
  bool _isLoading = false;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  
  @override
  void initState() {
    _initChannel();
    super.initState();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UC8dUEkag9c3neXj6hYOkP4g');
    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(color: appBackgroundColorSecondary, borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(
            color: Colors.grey[200], offset: Offset(0, 1), blurRadius: 6.0),
      ]),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(_channel.profilePictureUrl),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _channel.title,
                  style: customTextStyle(
                      color: appFontColorPrimary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: appFontBold),
                  overflow: TextOverflow.ellipsis,
                ),
                /*
                Text(
                  '${_channel.subscriberCount} subscribers',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontFamily: 'Aller'),
                  overflow: TextOverflow.ellipsis,
                ),
                */
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayScreen(id: video.id, title: video.title, publishedAt: video.publishedAt.substring(0,10), description: video.description),
            ),
          ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            height: 140.0,
            child: Row(
              children: [
                Image(
                  width: 150,
                  image: NetworkImage(video.thumbnailUrl),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: customTextStyle(
                            fontSize: 18.0,
                            fontFamily: appFontBold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.grey, size: 12.0,),
                          Text(
                            ' ${video.publishedAt.substring(0, 10)}',
                            style: customTextStyle(
                                color: appFontColorSecondary,
                                fontSize: 15.0,
                                fontFamily: appFontBold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        video.description,
                        style: customTextStyle(
                            color: appFontColorSecondary,
                            fontSize: 15.0,
                            fontFamily: appFont),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasInternetConnection(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data
              ? videoList()
              : Expanded(
            child: GestureDetector(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Colors.black54,
                        size: 40.0,
                      ),
                      Text(
                        'Tap to Reload.',
                        style: customTextStyle(
                            fontFamily: appFont, color: appFontColorSecondary),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(
                        () {
                      _initChannel();
                      videoList();
                    },
                  );
                }),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  videoList() {
    return _channel != null
        ? NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollDetails) {
        if (!_isLoading &&
            _channel.videos.length != int.parse(_channel.videoCount) &&
            scrollDetails.metrics.pixels ==
                scrollDetails.metrics.maxScrollExtent) {
          _loadMoreVideos();
        }
        return false;
      },
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 1 + _channel.videos.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox.shrink();//_buildProfileInfo();
          }
          Video video = _channel.videos[index - 1];
          return _buildVideo(video);
        },
      ),
    )
        : Center(
      child: CircularProgressIndicator(
        valueColor:
        AlwaysStoppedAnimation<Color>(appColorPrimary),
      ),
    );
  }
}

