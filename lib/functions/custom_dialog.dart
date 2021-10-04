import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';

Future customDialog(
    BuildContext context, String title, String content, bool isOkOnly,
    {Function onPressedOk, Function onPressedYes, Function onPressedNo}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
          title: Center(child: Text(title, style: customTextStyle(fontFamily: appFont, fontSize: 16.0))),
          content: Center(child: Text(content, textAlign:TextAlign.center, style: customTextStyle(fontFamily: appFont,color: appFontColorSecondary))),
          actions: [
            isOkOnly
                ? Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.0,
                        child: TextButton(
                          onPressed: onPressedOk,
                          child: Text(
                            "Okay",
                            textAlign: TextAlign.center,
                            style: customTextStyle(fontFamily: appFontBold, color: Colors.white),
                          ),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(color: Colors.blue),
                              ),
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
                  child: TextButton(
                    onPressed: onPressedYes,
                    child: Text(
                      "Yes",
                      textAlign: TextAlign.center,
                      style: customTextStyle(fontFamily: appFontBold, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  height: 50.0,
                  child: TextButton(
                    onPressed: onPressedNo,
                    child: Text(
                      "No",
                      textAlign: TextAlign.center,
                      style: customTextStyle(fontFamily: appFontBold, color: Colors.blue),
                    ),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.blue),
                        ),
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
