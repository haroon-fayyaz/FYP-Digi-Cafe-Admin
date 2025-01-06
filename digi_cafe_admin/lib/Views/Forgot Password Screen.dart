import 'package:digi_cafe_admin/Views/Login.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: colors.backgroundColor,
        primaryColor: colors.buttonColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: colors.buttonColor,
          secondary: colors.cursorColor,
        ),
      ),
      home: Scaffold(
        body: _ForgotPasswordScreen(),
      ),
    );
  }
}

class _ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<_ForgotPasswordScreen> {
  bool _buttonPressed = false;

  TextEditingController edtTextControllerEmail;

  TextEditingController edtTextControllerPassword;

  bool _displayLabel = false;
  LoginDBController dbController;

  var errorHeading = '';

  @override
  void initState() {
    super.initState();
    edtTextControllerEmail = new TextEditingController();
    edtTextControllerPassword = new TextEditingController();
    dbController = new LoginDBController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colors.backgroundColor,
        child: Center(
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
                _displayLabel
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          '$errorHeading',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: Fonts.default_font,
                            fontSize: Fonts.dialog_heading_size,
                          ),
                        ))
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                      autofocus: true,
                      controller: edtTextControllerEmail,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      textCapitalization: TextCapitalization.words,
                      decoration: MyWidgets.getTextFormDecoration(
                          title: 'Email', icon: Icons.email)),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: colors.buttonColor,
                    ),
                    width: 200,
                    height: 50,
                    child: TextButton(
                      child: Stack(
                        children: <Widget>[
                          Visibility(
                            visible: !_buttonPressed,
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontFamily: Fonts.default_font,
                                color: colors.buttonTextColor,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _buttonPressed,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _buttonPressed = true;
                        });
                        forgotPassword();

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             new dashboard()));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             new ViewFoodMenu()));

                        // print(edtTextControllerEmail.text);
                        // print(edtTextControllerPassword.text);
                        // _loginController.forgotPassword(edtTextControllerEmail.text,
                        //     edtTextControllerPassword.text);
                        // _loginController
                        //     .isEmailVerified()
                        //     .then((value) => print(value));
                        // setState(() {
                        //   _buttonPressed = true;
                        // });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       border: Border.all(
                //         width: 1.0,
                //         style: BorderStyle.solid,
                //       )),
                //   width: 200,
                //   height: 50,
                //   child: FlatButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => SignUpScreen()));
                //     },
                //     child: Text(
                //       'Create new Account',
                //       style: TextStyle(
                //         fontFamily: Fonts.default_font,
                //         color: colors.buttonColor,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> forgotPassword() async {
    if (edtTextControllerEmail.text != '') {
      String email = edtTextControllerEmail.text
          .replaceAll(new RegExp(r"\s+"), "")
          .toLowerCase();
      String value = await dbController.resetPassword(email);
      if (value == 'invalid') {
        setState(() {
          errorHeading = 'Invalid Email Address';
          _buttonPressed = false;
          _displayLabel = true;
        });
      } else {
        setState(() {
          _buttonPressed = false;
          _displayLabel = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      'A password reset email has been sent to this email address. Follow the instructions sent to reset your password.',
                      style: TextStyle(
                        fontFamily: Fonts.default_font,
                        fontSize: Fonts.heading2_size,
                        color: colors.labelColor,
                      ),
                    ),
                    actions: <Widget>[
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colors.buttonColor,
                        ),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontFamily: Fonts.default_font,
                              fontSize: Fonts.label_size,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]));
      }
    } else {
      setState(() {
        _buttonPressed = false;
        _displayLabel = true;
        errorHeading = 'Email is not entered';
      });
    }
  }
}
