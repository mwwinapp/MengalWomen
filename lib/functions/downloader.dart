import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:sqflite/sqflite.dart';

downloaderInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );

}

downloadDatabase(BuildContext context) async {
  var databasesPath = await getDatabasesPath();

  final databaseDownloadTask = await FlutterDownloader.enqueue(
    url: 'https://drive.google.com/uc?export=download&id=1lVM05EaTG01Xsf7EcfF8WO34mEfJtFjZ',
    savedDir: databasesPath,
    showNotification: false, // show download progress in status bar (for Android)
    openFileFromNotification: false, // click on notification to open downloaded file (for Android)
  );
  customDialog(context, 'Download complete.', 'Database successfully downloaded and updated.', true,onPressedOk: () => Navigator.of(context, rootNavigator: true).pop());
}