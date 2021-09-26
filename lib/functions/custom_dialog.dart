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
          content: Center(child: Text(content, textAlign:TextAlign.center, style: TextStyle(fontFamily: 'Aller',color: Colors.grey))),
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
                            style: TextStyle(
                                fontFamily: 'AllerBold'),
                          ),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[800]),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(color: Colors.blue[800]),
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
                      style: TextStyle(
                          fontFamily: 'AllerBold'),
                    ),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.green),
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
                      style: TextStyle(
                          fontFamily: 'AllerBold'),
                    ),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.red),
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
