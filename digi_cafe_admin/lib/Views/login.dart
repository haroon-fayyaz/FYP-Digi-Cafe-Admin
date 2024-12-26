import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/EmployeeDBController.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/Views/Dashboard.dart';
import 'package:digi_cafe_admin/Views/Forgot Password Screen.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'NoIternetScreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: colors.kPrimaryColor,
        backgroundColor: colors.backgroundColor,
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
  bool _passwordHide = true;

  Icon _passwordIcon = Icon(
    PasswordCross.eye_slash,
    size: 22,
  );
  TextEditingController edtTextControllerEmail;

  TextEditingController edtTextControllerPassword;

  var adminEmail = 'digicafe2021@gmail.com';
  bool _displayLabel = false;
  var adminPassword = 'Admin@123';
  LoginDBController dbController;
  EmployeeDBController _employeeDBController;
  var errorHeading = '';

  @override
  void initState() {
    super.initState();
    _employeeDBController = new EmployeeDBController();
    edtTextControllerEmail = new TextEditingController();
    edtTextControllerPassword = new TextEditingController();
    dbController = new LoginDBController();

    // if (dbController.CheckSignIn(adminEmail, adminPassword) == null) {
    // }
  }

  Future<void> createUser() async {
    await dbController.CheckSignIn(adminEmail, adminPassword)
        .then((value) async {
      if (value == 'wrong email') {
        await dbController.CreateNewUser(adminEmail, adminPassword);
        await _employeeDBController.addAdmin(adminEmail);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await createUser();
    });
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: LoginScreen())
          : Scaffold(
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
                          child: MyWidgets.getTextWidget(
                              text: 'Digi Café', size: Fonts.heading1_size),
                        ),
                        _displayLabel
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: MyWidgets.getTextWidget(
                                    text: errorHeading,
                                    size: Fonts.dialog_heading_size,
                                    color: colors.warningColor),
                              )
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
                                title: 'Email',
                                icon: Icons.email,
                                border: UnderlineInputBorder(),
                                addBorder: false),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            autofocus: true,
                            controller: edtTextControllerPassword,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            textCapitalization: TextCapitalization.words,
                            decoration: MyWidgets.getTextFormDecoration(
                              title: 'Password',
                              icon: Icons.vpn_key,
                              border: UnderlineInputBorder(),
                              addBorder: false,
                              suffix: InkWell(
                                child: _passwordIcon,
                                onTap: () {
                                  setState(() {
                                    _passwordHide = !_passwordHide;
                                    if (_passwordHide) {
                                      _passwordIcon = Icon(
                                        PasswordCross.eye_slash,
                                        size: 22,
                                      );
                                    } else {
                                      _passwordIcon = Icon(
                                        Icons.remove_red_eye,
                                        size: 22,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: _passwordHide,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: InkWell(
                              child: MyWidgets.getTextWidget(
                                  text: 'Forgot Password?',
                                  size: Fonts.heading3_size,
                                  color: colors.buttonColor),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen()));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: colors.buttonColor,
                            ),
                            width: 200,
                            height: 50,
                            child: TextButton(
                              child: Stack(
                                children: <Widget>[
                                  Visibility(
                                    visible: !_buttonPressed,
                                    child: MyWidgets.getTextWidget(
                                        text: 'Sign In',
                                        size: Fonts.button_size,
                                        color: colors.buttonTextColor),
                                  ),
                                  Visibility(
                                    visible: _buttonPressed,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  _buttonPressed = true;
                                });
                                checkSignIn();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> checkSignIn() async {
    if (edtTextControllerEmail.text != '' &&
        edtTextControllerPassword.text != '') {
      String email = edtTextControllerEmail.text
          .replaceAll(new RegExp(r"\s+"), "")
          .toLowerCase();
      if (email == adminEmail) {
        bool done = false;

        // await MyWidgets.internetStatus(context).then((value) {
        //   done = value;
        // });
        // if (done)
        //   setState(() {
        //     _buttonPressed = false;
        //   });
        await dbController.CheckSignIn(email, edtTextControllerPassword.text)
            .then((value) {
          if (value == 'wrong email') {
            setState(() {
              _displayLabel = true;
              _buttonPressed = false;

              errorHeading = 'Incorrect Email';
            });
          } else if (value == 'wrong password') {
            setState(() {
              _buttonPressed = false;

              _displayLabel = true;
              errorHeading = 'Incorrect Password';
            });
          } else {
            setState(() {
              _buttonPressed = false;
              _displayLabel = false;
              _passwordHide = true;
              edtTextControllerPassword.text = '';
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(email: email)));
          }
        });
      } else {
        setState(() {
          _displayLabel = true;
          _buttonPressed = false;
          errorHeading = 'Incorrect Email';
        });
      }
    } else {
      setState(() {
        _buttonPressed = false;
        _displayLabel = true;
        errorHeading = 'Email or Password is empty';
      });
    }
  }
}
