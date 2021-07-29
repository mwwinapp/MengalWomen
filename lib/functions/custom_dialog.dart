import 'package:flutter/material.dart';

Future customDialog(
    BuildContext context, String title, String content, bool isOkOnly,
    {Function onPressedOk, Function onPressedYes, Function onPressedNo}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: 'Aller')),
          content: Text(content, style: TextStyle(fontFamily: 'Aller')),
          actions: [
            isOkOnly
                ? FlatButton(
                    child: Text('Ok', style: TextStyle(fontFamily: 'Aller')),
                    onPressed: onPressedOk,
                  )
                : Row(children: [
                    FlatButton(
                      child: Text('No', style: TextStyle(fontFamily: 'Aller')),
                      onPressed: onPressedNo,
                    ),
                    FlatButton(
                      child: Text('Yes', style: TextStyle(fontFamily: 'Aller')),
                      onPressed: onPressedYes,
                    ),
                  ])
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          scrollable: true,
        );
      });
}
