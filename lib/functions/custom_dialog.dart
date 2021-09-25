import 'package:flutter/material.dart';

Future customDialog(
    BuildContext context, String title, String content, bool isOkOnly,
    {Function onPressedOk, Function onPressedYes, Function onPressedNo}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
          title: Center(child: Text(title, style: TextStyle(fontFamily: 'Aller'))),
          content: Center(child: Text(content, style: TextStyle(fontFamily: 'Aller',color: Colors.grey))),
          actions: [
            isOkOnly
                ? Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          elevation: 0.0,
                          onPressed: onPressedOk,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Okay",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'AllerBold'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Row(children: [
              Expanded(
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.green,
                    elevation: 0.0,
                    onPressed: onPressedYes,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'AllerBold'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.red,
                    elevation: 0.0,
                    onPressed: onPressedNo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "No",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'AllerBold'),
                      ),
                    ),
                  ),
                ),
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
