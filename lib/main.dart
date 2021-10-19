import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw/functions/downloader.dart';
import 'package:mw/screens/login_screen.dart';
import 'functions/globals.dart';

void main() {
  downloaderInit();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Mengal Women',
    theme: customTheme(true),
    home: LoginScreen(),
  ));
}

