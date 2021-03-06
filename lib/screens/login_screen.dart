import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:mw/functions/cryptography.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/end_user_model.dart';
import 'package:mw/screens/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {

  var dBHelper = DbHelper();
  Future<List<EndUser>> enduser;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _passwordVisible = false;
  bool _isChecked = false;

  void initState() {
    _loadUsernamePassword();
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            leading: Container(),
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  customDialog(
                      context, 'Exit App', 'Are you sure you want to exit?', false,
                      onPressedNo: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      onPressedYes: () => SystemNavigator.pop());
                },
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Image(image: AssetImage("assets/images/mw.logo.png"), width: 100.0, height: 100.0,),
                      GradientText("Mengal Women",
                          gradient: LinearGradient(
                              colors: [appColorPrimary, appColorPrimary, appColorPrimary]),
                          style: customTextStyle(
                              fontFamily: appFontBold,
                              letterSpacing: -1.5,
                              fontSize: 40.0),
                          textAlign: TextAlign.center),
                      Text('Organization Inc.',
                        style: customTextStyle(
                            color: appColorPrimary,
                            fontFamily: appFontBold,
                            letterSpacing: 5.0,
                            fontSize: 15.0),
                      ),
                      SizedBox(height: 80.0,),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username.';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontFamily: appFontBold, color: appFontColorPrimary),
                        controller: _username,
                        decoration: InputDecoration(
                          prefixIcon: IconTheme(data: IconThemeData(color: appColorPrimary), child: Icon(Icons.person)),
                          labelText: 'Username',
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password.';
                          }
                          return null;
                        },
                        style: TextStyle(fontFamily: appFontBold, color: appFontColorPrimary),
                        controller: _password,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          fillColor: appBackgroundColorPrimary,
                          filled: true,
                          isDense: true,
                          prefixIcon: IconTheme(data: IconThemeData(color: appColorPrimary), child: Icon(Icons.lock)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: appColorPrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          labelText: 'Password',
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          'Save my Log in Credentials',
                          style: customTextStyle(fontFamily: appFontBold, color: Colors.grey[700]),
                        ),
                        value: _isChecked,
                        onChanged: (value) {
                          setState(
                                () {
                              _isChecked = value;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 50.0,),
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (_username.text != '' && _password.text != '') {
                                _rememberMe(_isChecked);
                                doLogin();
                              }
                            }
                          },
                          child: Text(
                            "Log in",
                            textAlign: TextAlign.center,
                            style: customTextStyle(fontFamily: appFontBold, fontSize: 16.0, color: appBackgroundColorPrimary),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Log in as Guest?',
                            style: customTextStyle(
                              fontFamily: appFontBold,
                              color: appColorPrimary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = ((){
                              usertype = 'guest';
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabScreen(),),);
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _rememberMe(bool value) {

    print(_isChecked);
    SharedPreferences.getInstance().then(
            (prefs) {
          prefs.setBool('remember_me', value);
          prefs.setString('username', _username.text);
          prefs.setString('password', _password.text);
        }
    );
  }

  void _loadUsernamePassword() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var username = _prefs.getString('username') ?? '';
    var password = _prefs.getString('password') ?? '';
    var rememberMe = _prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      setState((){
        _isChecked = true;
        _username.text = username ?? '';
        _password.text = password ?? '';
      });
    }
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
