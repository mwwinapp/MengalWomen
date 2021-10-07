import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/downloader.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/functions/network_ping.dart';
import 'package:mw/main.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return WillPopScope(
      child: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ListTile(
              onTap: () async {
                await hasInternetConnection().then((value) {
                  print(value);
                  if(value) {
                    customDialog(context, 'Confirm', 'Database will be downloaded and updated.\nDo you want to continue?', false, onPressedYes: () {
                      downloadDatabase(context);
                      Navigator.of(context, rootNavigator: true).pop();
                      customDialog(context, 'Download complete.', 'Database successfully downloaded and updated.', true,onPressedOk: () => Navigator.of(context, rootNavigator: true).pop());
                    }, onPressedNo: () => Navigator.of(context, rootNavigator: true).pop());
                  } else {
                    customDialog(context, 'Internet required.', 'Failed to download and update database.', true, onPressedOk: () => Navigator.of(context, rootNavigator: true).pop()); //_noInternetConnection(context);
                  }
                });
              },
              leading: FaIcon(FontAwesomeIcons.database, color: Colors.grey,),
              title: Text(
                'Update Database',
                style: customTextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: appFont),
              ),
              subtitle: Text(
                'Downloads the database from the server.',
                style: customTextStyle(
                    color: appFontColorSecondary, fontSize: 13.0, fontFamily: appFont),
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                launch('tel:09176790327');
              },
              leading: Icon(Icons.info, color: Colors.grey,),
              title: Row(
                children: [
                  Text(
                    'Contact Us',
                    style: customTextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: appFont),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                customDialog(
                  context, 'Redirect', 'Opening Facebook. Do you want to continue?', false,
                  onPressedNo: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  onPressedYes: () {
                    launch('https://m.facebook.com/mengalwomen');
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                );
              },
              leading: Icon(Icons.facebook, color: Colors.blue),
              title: Text(
                'Visit us on Facebook',
                style: customTextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: appFont),
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                customDialog(
                  context, 'Logout', 'Are you sure you want to logout?', false,
                  onPressedNo: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  onPressedYes: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainApp(),
                      ),
                    );
                  },
                );
              },
              leading: Icon(Icons.logout, color: Colors.grey,),
              title: Text(
                'Logout',
                style: customTextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: appFont),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
