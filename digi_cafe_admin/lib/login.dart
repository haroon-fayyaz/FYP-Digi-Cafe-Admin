import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: colors.buttonColor,
        cursorColor: colors.cursorColor,
      ),
      home: Scaffold(
        body: _LoginScreen(),
      ),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                padding: EdgeInsets.only(left: 25),
                child: Image.asset('images/logo.png'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Digi Cafe',
                  style: TextStyle(
                    fontSize: Fonts.heading1_size,
                    fontFamily: Fonts.default_font,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Email',
                    icon: Icon(
                      Icons.email,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Password',
                    icon: Icon(
                      Icons.lock,
//                    color: colors.iconButtonColor,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: colors.buttonColor,
                ),
                width: 200,
                height: 50,
                child: FlatButton(
                  child: Stack(
                    children: <Widget>[
                      Visibility(
                        visible: !_buttonPressed,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: Fonts.default_font,
                            color: colors.buttonTextColor,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _buttonPressed,
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _buttonPressed = true;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 1.0,
                      style: BorderStyle.solid,
                    )),
                width: 200,
                height: 50,
                child: FlatButton(
                  child: Text(
                    'Create new Account',
                    style: TextStyle(
                      fontFamily: Fonts.default_font,
                      color: colors.buttonColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
