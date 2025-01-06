import 'dart:io';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Model/Cafe%20Employee.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../style/colors.dart';
import 'NoIternetScreen.dart';

class AddEmployeeScreen extends StatelessWidget {
  AddEmployeeScreen({this.employee, this.actionType});

  CafeEmployee employee;
  String actionType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddEmployeeScreenFul(
        employee: employee,
        actionType: actionType,
      ),
    );
  }
}

_AddEmployeeScreen3State _addEmployeeScreen;

class AddEmployeeScreenFul extends StatefulWidget {
  AddEmployeeScreenFul({this.employee, this.actionType});
  CafeEmployee employee;
  String actionType;
  @override
  _AddEmployeeScreen3State createState() {
    _addEmployeeScreen =
        _AddEmployeeScreen3State(employee: employee, actionType: actionType);
    return _addEmployeeScreen;
  }
}

class _AddEmployeeScreen3State extends State<AddEmployeeScreenFul> {
  var screenHeader = 'Add Employee';

  _AddEmployeeScreen3State({this.employee, this.actionType});
  CafeEmployee employee;
  String actionType;
  File _image;
  var edtPhoneController = new TextEditingController();
  var _displayLoadingWidget = false;

  TextEditingController _dateControllerText = new TextEditingController();
  PageController controller = PageController();
  String date;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  CreateFormFieldDropDown genderType;
  CreateFormFieldDropDown staffType;

  int count = 0;
  var _phoneNo = '';
  var _email = '';
  var _password = '';

  int currentIndex = 0;

  EmployeeUIController _employeeUIController = new EmployeeUIController();

  String code = '+92';

  var edtControllerName = new TextEditingController();

  String _name;

  String _nextLabel = 'Next>';

  String _confirmPassword;

  void setFieldsForUpdate() {
    setState(() {
      _dateControllerText.text = employee.Dob;
      edtControllerName.text = employee.Name;
      genderType.state.setState(() {
        genderType.chosenType = employee.Gender;
      });
      staffType.state.setState(() {
        staffType.chosenType = employee.userType;
      });
      setState(() {
        setPhoneNo();
        count++;
      });
    });
    // debugPrint(__contactDetailsState.mounted.toString());
  }

  void setPhoneNo() {
    setState(() {
      if (employee != null) {
        List<String> x = employee.PhoneNo.split(' ');
        if (x.length > 0) {
          code = x[0];
        } else {
          code = '';
        }
        if (x.length > 1) {
          _phoneNo = x[1];
        } else {
          _phoneNo = '';
        }
        edtPhoneController.text = _phoneNo;
      }
    });

    count++;
  }

  @override
  void initState() {
    super.initState();
    genderType = new CreateFormFieldDropDown(
      dropDownList: <String>['Male', 'Female', 'Other'],
      icon: Icons.person_outline,
      title: 'Gender',
    );

    staffType = new CreateFormFieldDropDown(
      dropDownList: <String>['Kitchen', 'Serving'],
      icon: Icons.person,
      title: 'Staff Type',
    );
    if (actionType == 'update') {
      screenHeader = 'Update Employee';
      // setFieldsForUpdate();
      // setPhoneNo();
    }
  }

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (actionType == 'update' && count < 1) {
        setFieldsForUpdate();
        screenHeader = 'Update Employee';
      }
      // await MyWidgets.internetStatus(context).then((value) {
      //   if (value && _displayLoadingWidget)
      //     setState(() {
      //       _displayLoadingWidget = true;
      //     });
      // });
    });

    Widget widget = ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(
              screen:
                  AddEmployeeScreen(actionType: actionType, employee: employee))
          : Stack(children: [
              _displayLoadingWidget
                  ? LoadingWidget()
                  : Column(
                      children: [
                        Expanded(
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: onChangedFunction,
                            controller: controller,
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 20, 0),
                                      child: Container(
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.73,
                                        child: Image.asset(
                                          'images/innerImages/cook_img.jpg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, top: 20, bottom: 10),
                                        child: MyWidgets.getTextWidget(
                                            text: 'Personal Information',
                                            size:
                                                Fonts.heading_SampleText_size),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: TextFormField(
                                        autofocus: true,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        onChanged: (text) {
                                          _name = text;
                                        },
                                        controller: edtControllerName,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration:
                                            MyWidgets.getTextFormDecoration(
                                                title: 'Full Name',
                                                icon: Icons.person_add),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: TextFormField(
                                        controller: _dateControllerText,
                                        readOnly: true,
                                        autofocus: true,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration:
                                            MyWidgets.getTextFormDecoration(
                                                title: 'Date Of Birth',
                                                icon: Icons.calendar_today),
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                          ).then((value) {
                                            String day = value.day.toString();
                                            String month =
                                                value.month.toString();
                                            String year = value.year.toString();
                                            String date =
                                                '${day}-${month}-${year}';
                                            _dateControllerText.text = date;

                                            setState(() {
                                              _dateControllerText.text = date;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: genderType,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: staffType,
                                    ),
                                  ],
                                ),
                              ),
                              ContactDetailsWidget(),
                              if (actionType != 'update') ImageWidget(),
                              if (actionType != 'update') EmailDetails(),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              MyWidgets.getIndicator(
                                  positionIndex: 0, currentIndex: currentIndex),
                              SizedBox(
                                width: 10,
                              ),
                              MyWidgets.getIndicator(
                                  positionIndex: 1, currentIndex: currentIndex),
                              SizedBox(
                                width: 10,
                              ),
                              if (actionType != 'update')
                                MyWidgets.getIndicator(
                                    positionIndex: 3,
                                    currentIndex: currentIndex),
                              SizedBox(
                                width: 10,
                              ),
                              if (actionType != 'update')
                                MyWidgets.getIndicator(
                                    positionIndex: 4,
                                    currentIndex: currentIndex),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => previousFunction(),
                                  child: MyWidgets.getTextWidget(
                                      text: '<Previous',
                                      size: Fonts.heading2_size,
                                      color: colors.buttonColor),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                InkWell(
                                  onTap: () {
                                    nextFunction();
                                  },
                                  child: MyWidgets.getTextWidget(
                                      text: '$_nextLabel',
                                      size: Fonts.heading2_size,
                                      color: colors.buttonColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
            ]),
    );

    return Scaffold(
        appBar:
            MyWidgets.getFilterAppBar(context: context, text: '$screenHeader'),
        body: widget);
    return widget;
  }

  void _textEditingControllerListener() {
    _dateControllerText.text = date;
  }

  nextFunction() {
    double personal = 0, phoneNo = 1, email = 3, image = 2;
    if (count == 0) {
      setPhoneNo();
    }
    if (controller.page == personal) {
      if (edtControllerName.text == '') {
        _showToast(context, 'Enter full Name');
      } else if (_dateControllerText.text == '') {
        _showToast(context, 'Select Date Of Birth');
      } else if (genderType.chosenType == null) {
        _showToast(context, 'Choose Gender');
      } else if (staffType.chosenType == null) {
        _showToast(context, 'Choose Person Type');
      } else {
        if (actionType == 'update') {
          setState(() {
            _nextLabel = 'Update';
          });
        }
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else if (controller.page == phoneNo) {
      if (_phoneNo.toString().trim() == '') {
        _showToast(context, 'Enter Phone Number');
      } else if (!RegExp(r'^(03)[0-9]{9}$').hasMatch(_phoneNo))
        _showToast(context, 'Invalid Phone Number');
      else {
        if (actionType == 'update') {
          updateEmployeeRecord();
        }
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else if (controller.page == email) {
      controller.nextPage(duration: _kDuration, curve: _kCurve);
      if (_email != '') {
        if (_password == '') {
          _showToast(context, 'Enter Password');
        } else if (_confirmPassword == '') {
          _showToast(context, 'Enter confirm password');
        } else {
          controller.nextPage(duration: _kDuration, curve: _kCurve);
          _functionSignUp();
        }
      } else {
        _functionSignUp();
      }
    } else if (controller.page == image) {
      if (_image == null) {
        _showToast(context, 'Choose Profile Pic');
        return;
      } else {
        setState(() {
          _nextLabel = "Add";
        });
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else {
      controller.nextPage(duration: _kDuration, curve: _kCurve);
    }
  }

  previousFunction() {
    double personal = 0, phoneNo = 1, email = 3, image = 2;

    if (controller.page != phoneNo - 1 && actionType == 'update') {
      setState(() {
        _nextLabel = 'Next>';
      });
    }
    if (controller.page != email - 1) {
      setState(() {
        _nextLabel = 'Next>';
      });
    }
    if (controller.page == 0) {
      Navigator.pop(context);
    } else {
      controller.previousPage(duration: _kDuration, curve: _kCurve);
    }
  }

  Future<void> _functionSignUp() async {
    try {
      setState(() {
        _displayLoadingWidget = true;
      });
      _email = _email.replaceAll(new RegExp(r"\s+"), "").toLowerCase();
      _password = _password.trim();
      _emailDetailsState._validateInputs();
      if (_emailDetailsState._autoValidate == false) {
        print(_email + _password + _phoneNo);

        bool result = await _employeeUIController.addEmployee(
            edtControllerName.text,
            _dateControllerText.text,
            genderType.chosenType,
            staffType.chosenType,
            '${code}' + ' ' + '${_phoneNo}',
            _email,
            _password,
            _image.path);
        print(result);
        if (result.toString() == "true") {
          print('sucessful');
          Navigator.pop(context);
        }
      } else {
        print('unsuccessful');
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _displayLoadingWidget = false;
    });
  }

  Future<void> updateEmployeeRecord() async {
    setState(() {
      _displayLoadingWidget = true;
    });
    print(code);
    employee.Dob = _dateControllerText.text;
    employee.Gender = genderType.chosenType;
    employee.PhoneNo = code + ' ' + _phoneNo;
    employee.Name = edtControllerName.text;
    employee.userType = staffType.chosenType;
    await _employeeUIController.updateEmployeeData(employee);
    _showToast(context, "Data updated Successfully");
    setState(() {
      _displayLoadingWidget = false;
    });
    Navigator.pop(context);
  }

  void _showToast(BuildContext context, var _message) {
    MyWidgets.showToast(context, _message);
  }

  void _valueChanged(String value) {
    setState(() {
      _phoneNo = value;
    });
  }

  Widget ContactDetailsWidget() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: MyWidgets.getTextWidget(
                    text: 'Contact Details',
                    size: Fonts.heading_SampleText_size),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                autofocus: true,
                onChanged: _valueChanged,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                controller: edtPhoneController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: colors.buttonColor, width: 1.3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: colors.buttonColor, width: 1.3),
                  ),
                  hintText: 'Contact Number',
                  filled: true,
                  fillColor: colors.backgroundColor,
                  labelText: 'Contact Number',
                  icon: CountryCodePicker(
                    onChanged: (value) {
                      code = value.dialCode;
                      _addEmployeeScreen.setState(() {
                        _addEmployeeScreen.code = code;
                      });
                    },
                    initialSelection: '$code',

                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    favorite: ['PK'],

                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_ImageWidgetState __imageWidgetState;

class ImageWidget extends StatefulWidget {
  @override
  _ImageWidgetState createState() {
    __imageWidgetState = new _ImageWidgetState();
    return __imageWidgetState;
  }
}

class _ImageWidgetState extends State<ImageWidget> {
  File _image;
  String _imagePath = null;
  var _msg = "Select Profile Pic";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // loadImage();
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: MyWidgets.getTextWidget(
                        text: 'Upload Employee Profile Pic',
                        size: Fonts.heading_SampleText_size),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                _image != null
                    ? Image.file(
                        new File(_image.path),
                        width: 275,
                        height: 275,
                      )
                    : Container(),
                if (_image == null)
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: MyWidgets.getButton(
                      text: 'Choose Employee Pic',
                      width: 175,
                      onTap: () => _showPicker(context),
                    ),
                  ),
                SizedBox(
                  height: 50,
                ),
                _image != null
                    ? MyWidgets.getButton(
                        text: 'Remove',
                        color: Colors.red[400],
                        onTap: () => clearSelection(),
                        width: 140)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: colors.buttonColor,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,
                          color: colors.buttonTextColor),
                      title: MyWidgets.getTextWidget(
                          text: 'Photo Library',
                          size: Fonts.dialog_heading_size,
                          color: colors.buttonTextColor),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: colors.buttonTextColor,
                    ),
                    title: MyWidgets.getTextWidget(
                        text: 'Camera',
                        size: Fonts.dialog_heading_size,
                        color: colors.buttonTextColor),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void clearSelection() {
    setState(() {
      _image = null;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._image = _image;
    });
  }

  Future _imgFromCamera() async {
    await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxHeight: 225,
      maxWidth: 225,
    ).then((image) {
      setState(() {
        _image = image;
      });
      _addEmployeeScreen.setState(() {
        _addEmployeeScreen._image = _image;
      });
    });
  }

  Future _imgFromGallery() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxHeight: 225,
      maxWidth: 225,
    ).then((image) {
      setState(() {
        _image = image;
      });
      _addEmployeeScreen.setState(() {
        _addEmployeeScreen._image = _image;
      });
    });
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((image) {
      setState(() {
        _image = image;
      });
      _addEmployeeScreen.setState(() {
        _addEmployeeScreen._image = _image;
      });
    });
  }
}

_EmailDetailsState _emailDetailsState;

class EmailDetails extends StatefulWidget {
  @override
  _EmailDetailsState createState() {
    _emailDetailsState = _EmailDetailsState();
    return _emailDetailsState;
  }
}

class _EmailDetailsState extends State<EmailDetails> {
  bool _autoValidate = false;
  bool _passwordHide = true;
  bool _confirmPasswordHide = true;

  Icon _passwordIcon = Icon(
    PasswordCross.eye_slash,
    size: 22,
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Icon _confirmIcon = Icon(PasswordCross.eye_slash, size: 22);
  var _email;
  var _confirmPassword;
  var _password;

  void _validateInputs() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        _formKey.currentState.save();
        setState(() {
          _autoValidate = false;
        });
      } else {
//    If all data are not valid then start auto validation.
        setState(() {
          _autoValidate = true;
        });
      }
    }
  }

  String validateEmail(String value) {
    value = value.replaceAll(new RegExp(r"\s+"), "");

    if (value != '') {
      Pattern pattern1 =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex1 = new RegExp(pattern1);
      if (!regex1.hasMatch(value.trim()))
        return 'Enter Valid Email';
      else {
        return null;
      }
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value != '') {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return null;
      } else {
        return 'Password must contain Minimum 1 Upper case,\nMinimum 1 lowercase,\n Minimum 1 Numeric Number,\n Minimum 1 Special Character';
      }
    } else {
      return null;
    }
  }

  String validateconfirmPassword(String value) {
    if (_confirmPassword != '' && _password != '') {
      if (_confirmPassword != _password) {
        return 'Both Passwords doesn\'t match';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: MyWidgets.getTextWidget(
                        text: 'Login Information(Optional)',
                        size: Fonts.heading_SampleText_size),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validateEmail,
                    onChanged: _emailValueChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: MyWidgets.getTextFormDecoration(
                        title: 'Email Address', icon: Icons.email),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    obscureText: _passwordHide,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validatePassword,
                    onChanged: _passwordValueChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: MyWidgets.getTextFormDecoration(
                      title: 'Password',
                      icon: Icons.vpn_key,
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    obscureText: _confirmPasswordHide,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validateconfirmPassword,
                    onChanged: _confirmPasswordValueChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: MyWidgets.getTextFormDecoration(
                      title: 'Confirm Password',
                      icon: Icons.vpn_key,
                      suffix: InkWell(
                        child: _confirmIcon,
                        onTap: () {
                          setState(() {
                            _confirmPasswordHide = !_confirmPasswordHide;
                            if (_confirmPasswordHide) {
                              _confirmIcon = Icon(
                                PasswordCross.eye_slash,
                                size: 22,
                              );
                            } else {
                              _confirmIcon = Icon(
                                Icons.remove_red_eye,
                                size: 22,
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _emailValueChanged(String value) {
    setState(() {
      _email = value;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._email = _email;
    });
  }

  void _confirmPasswordValueChanged(String value) {
    setState(() {
      _password = value;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._password = _password;
    });
  }

  void _passwordValueChanged(String value) {
    setState(() {
      _confirmPassword = value;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._confirmPassword = _confirmPassword;
    });
  }
}
