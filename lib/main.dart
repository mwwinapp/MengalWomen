import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:mw/functions/cryptography.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/end_user_model.dart';
import 'package:mw/screens/tab_screen.dart';

import 'functions/global_variables.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Mengal Women',
    theme: ThemeData(primaryColor: Colors.blue[800], accentColor: Colors.blue),
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {

  var dBHelper = DbHelper();
  Future<List<EndUser>> enduser;

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _passwordVisible = false;

  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () =>
            customDialog(
                context, 'Exit App', 'Are you sure you want to exit?', false,
                onPressedNo: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                onPressedYes: () => SystemNavigator.pop()),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"),
              fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Image(image: AssetImage("assets/images/mw.logo.png"), width: 100.0, height: 100.0,),
                  GradientText("Mengal Women",
                      gradient: LinearGradient(
                          colors: [Theme
                              .of(context)
                              .primaryColor, Colors.blue[800], Colors.blue[600]]),
                      style: TextStyle(
                          fontFamily: 'AllerBold',
                          letterSpacing: -1.5,
                          fontSize: 40.0),
                      textAlign: TextAlign.center),
                  Text('Organization Inc.',
                      style: TextStyle(
                          color: Colors.blue[600],
                          fontFamily: 'AllerBold',
                          letterSpacing: 5.0,
                          fontSize: 15.0),
                  ),
                  SizedBox(height: 80.0,),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (term) {
                      doLogin();
                    },
                    style: TextStyle(fontFamily: 'Aller'),
                    //textCapitalization: TextCapitalization.characters,
                    controller: _username,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username...',
                      hintStyle: TextStyle(fontFamily: 'Aller'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)), borderSide: BorderSide(color: Colors.transparent)),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (term) {
                      doLogin();
                    },
                    style: TextStyle(fontFamily: 'Aller'),
                    //textCapitalization: TextCapitalization.characters,
                    controller: _password,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      hintText: 'Password...',
                      hintStyle: TextStyle(fontFamily: 'Aller'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)), borderSide: BorderSide(color: Colors.transparent)),
                    ),
                  ),
                  SizedBox(height: 50.0,),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 0.0,
                      onPressed: () {
                        doLogin();
                        },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Log in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'AllerBold',
                              fontSize: 17.0,),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.white,
                      elevation: 0.0,
                      onPressed: () {
                        usertype = 'guest';
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabScreen(),),);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Log in as Guest",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontFamily: 'AllerBold',
                            fontSize: 17.0,),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void doLogin() {
    cryptString(_password.text).then((value) async {
      enduser = dBHelper.getEndUser(_username.text, value);
      List list = await enduser;
      setState(() {
        if (list.length > 0){
          usertype = 'admin';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TabScreen(),
            ),
          );
        } else {
          customDialog(context, 'Log in Failed', 'Username/password did not match or not found.', true, onPressedOk: () =>Navigator.of(context, rootNavigator: true).pop());
        }
      });
    });
  }

}
