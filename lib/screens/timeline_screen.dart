import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/functions/network_ping.dart';
import 'package:mw/widgets/posts_list.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> with AutomaticKeepAliveClientMixin<TimelineScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        //BirthdayList(),
        FutureBuilder<bool>(
          future: hasInternetConnection(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data
                  ? PostsList()
                  : Expanded(
                      child: GestureDetector(
                          child: Container(
                            color: appBackgroundColorPrimary,
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
                                PostsList();
                              },
                            );
                          }),
                    );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
