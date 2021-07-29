import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw/functions/network_ping.dart';
import 'package:mw/widgets/birthday_list.dart';
import 'package:mw/widgets/posts_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BirthdayList(),
        FutureBuilder<bool>(
          future: hasInternetConnection(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data
                  ? PostsList()
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
                                  style: TextStyle(
                                      fontFamily: 'Aller', color: Colors.grey),
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
