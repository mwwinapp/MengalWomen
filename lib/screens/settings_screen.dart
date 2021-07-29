import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/downloader.dart';
import 'package:mw/functions/network_ping.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    downloaderInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Card(
            child: ListTile(
              onTap: () async {
                await hasInternetConnection().then((value) {
                  print(value);
                  value
                      ? downloadDatabase(context)
                      : customDialog(context, 'Internet required.',
                          'Failed to download and update database.', true,
                          onPressedOk: () =>
                              Navigator.of(context, rootNavigator: true)
                                  .pop()); //_noInternetConnection(context);
                });
              },
              leading: FaIcon(FontAwesomeIcons.database),
              title: Text(
                'Update Database',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Aller'),
              ),
              subtitle: Text(
                'Downloads the database from the server.',
                style: TextStyle(
                    color: Colors.grey, fontSize: 13.0, fontFamily: 'Aller'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
