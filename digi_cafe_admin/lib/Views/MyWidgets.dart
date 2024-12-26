import 'dart:ui';
import 'dart:math' as math;
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'NoIternetScreen.dart';

class MyWidgets {
  // static Future<bool> internetStatus(BuildContext context) async {
  //   bool done = false;
  //   await checkInternetConnection().then((value) {
  //     if (!value) {
  //       MyWidgets.changeScreen(
  //           context: context, screen: new NoInternetScreen());
  //       done = true;
  //       print(done);
  //     }
  //   });
  //   return done;
  // }

  // static Future<bool> checkInternetConnection() async {
  //   final Connectivity _connectivity = Connectivity();
  //   ConnectivityResult result = ConnectivityResult.none;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  //   if (result == ConnectivityResult.none)
  //     return false;
  //   else
  //     return true;
  //   // return true;
  // }

  static void changeScreen(
      {@required BuildContext context, @required var screen}) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => screen));
  }

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  static Function timePicker({BuildContext context, Function(String) onTap}) {
    DateTime now = DateTime.now();
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    ).then((value) {
      onTap(value.format(context));
    });
  }

  static Widget getFilterAppBar({
    String text,
    VoidCallback onTap,
    Widget bottom = null,
    var child = Icons.filter_list,
    var secondChild = null,
    VoidCallback secondTap = null,
  }) {
    return AppBar(
      bottom: bottom,
      backgroundColor: colors.buttonColor,
      title: getTextWidget(
          text: text, size: Fonts.label_size, color: colors.appBarColor),
      actions: [
        secondChild != null
            ? Padding(
                padding: const EdgeInsets.only(top: 0, right: 20),
                child: InkWell(
                  child: Icon(secondChild),
                  onTap: secondTap,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 0, right: 20),
          child: InkWell(
            child: Icon(child),
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  static Widget getAppBar(
      {String text = 'Digi Café Admin',
      VoidCallback onTap,
      var child = null,
      var bottom = null}) {
    return AppBar(
      bottom: bottom,
      backgroundColor: colors.buttonColor,
      title: Text(
        '$text',
        style: TextStyle(
          fontFamily: Fonts.default_font,
          fontSize: Fonts.label_size,
        ),
      ),
      actions: [
        child != null
            ? Padding(
                padding: const EdgeInsets.only(top: 0, right: 10),
                child: InkWell(
                  child: child,
                  onTap: onTap,
                ),
              )
            : Container()
      ],
    );
  }

  static toastWithKey(
      GlobalKey<ScaffoldMessengerState> _scaffoldKey, _message) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: colors.buttonColor,
        content: MyWidgets.getTextWidget(
          text: _message,
          color: colors.textColor,
          size: Fonts.appBarTitle_size,
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static InputDecoration getTextFormDecoration(
      {String title = 'Name',
      IconData icon = Icons.person,
      var counterText = null,
      var suffix = null,
      var border = null,
      var addBorder = true,
      String hint = null}) {
    return InputDecoration(
      focusedBorder: addBorder
          ? OutlineInputBorder(
              borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
            )
          : null,
      enabledBorder: addBorder
          ? OutlineInputBorder(
              borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
            )
          : null,
      border: border,
      hintText: hint == null ? title : hint,
      filled: true,
      counterText: counterText,
      fillColor: colors.backgroundColor,
      labelText: title,
      labelStyle: getTextStyle(color: colors.buttonColor),
      hintStyle: getTextStyle(color: Colors.grey),
      suffixIcon: suffix,
      icon: icon == null ? null : Icon(icon),
    );
  }

  static showConfirmationDialog(BuildContext context,
      {String text = 'Yes', VoidCallback callback = null}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          content: MyWidgets.getTextWidget(
              text: text, size: Fonts.heading2_size, color: colors.labelColor),
          actions: <Widget>[
            MyWidgets.getButton(
                text: 'No',
                width: 60,
                radius: 10,
                onTap: () {
                  Navigator.pop(context);
                }),
            MyWidgets.getButton(
                text: 'Yes',
                width: 60,
                radius: 10,
                onTap: () {
                  Navigator.pop(context);
                  callback();
                }),
          ]),
    );
  }

  static Widget getDashboardItem(
      {String text = '',
      double width = 0,
      double height = 0,
      double childWidth = 0,
      Widget child = null,
      VoidCallback onTap = null}) {
    return Container(
      width: width,
      height: height,
      child: InkWell(
        child: Card(
          elevation: 7,
          child: Column(children: <Widget>[
            Container(
              width: width - childWidth,
              height: height - 30,
              child: child,
            ),
            FittedBox(
              child: getTextWidget(
                  text: text,
                  color: colors.labelColor,
                  size: Fonts.label_size,
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
        ),
        onTap: onTap,
      ),
    );
  }

  static SpeedDialChild getSpeedDialChild(
      {String text = 'Add',
      VoidCallback callback = null,
      var icon = null,
      var iconColor = colors.backgroundColor,
      var btnColor = colors.buttonColor,
      var bgColor = colors.buttonColor}) {
    return SpeedDialChild(
        child: Icon(icon, color: iconColor),
        label: text,
        labelStyle: getTextStyle(size: Fonts.dialog_heading_size),
        labelBackgroundColor: colors.buttonColor,
        backgroundColor: bgColor,
        onTap: callback);
  }

  static Widget getButton(
      {String text = 'Add',
      VoidCallback onTap = null,
      var color = colors.buttonColor,
      double width = 100,
      double height = 50,
      double radius = 50}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: color,
        ),
        width: width,
        height: height,
        child: Center(
          child: getTextWidget(
              size: Fonts.button_size,
              text: '$text',
              color: colors.buttonTextColor),
        ),
      ),
      onTap: onTap,
    );
  }

  static Widget getSettingsHeading(
      {var title,
      double top = 0,
      double left = 0,
      double right = 0,
      double bottom = 0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: MyWidgets.getTextWidget(
          text: title,
          color: colors.buttonColor,
          weight: FontWeight.bold,
          size: Fonts.heading2_XL_size),
    );
  }

  static Widget getSettingsRow(
      {var title = '',
      var subTitle = '',
      VoidCallback onTap = null,
      var icon = null,
      var iconData = null}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconData == null ? Icon(icon) : iconData,
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 2),
            child: InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyWidgets.getTextWidget(
                      text: '$title',
                      weight: FontWeight.bold,
                      size: Fonts.heading2_size),
                  MyWidgets.getTextWidget(
                      text: '$subTitle',
                      weight: FontWeight.w600,
                      color: Colors.grey,
                      size: Fonts.heading2_size),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget getTextWidget({
    String text = '',
    var size = Fonts.heading2_size,
    FontWeight weight = FontWeight.normal,
    var overflow = TextOverflow.visible,
    var color = Colors.black,
    TextAlign align = TextAlign.left,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return Text(
      '$text',
      style: TextStyle(
          fontSize: size,
          fontFamily: Fonts.default_font,
          fontWeight: weight,
          decoration: decoration,
          color: color),
      overflow: overflow,
      textAlign: align,
    );
  }

  static TextStyle getTextStyle(
      {var size = Fonts.heading2_size,
      FontWeight weight = FontWeight.normal,
      var color = colors.buttonTextColor,
      var bgColor = null}) {
    return TextStyle(
      color: color,
      backgroundColor: bgColor,
      fontFamily: Fonts.default_font,
      fontWeight: weight,
      fontSize: size,
    );
  }

  static getPopMenu(
      {Function(String) onSelected = null,
      @required List<String> list,
      String text = ''}) {
    return getAppBar(
      text: text,
      child: PopupMenuButton<String>(
        icon: Icon(Icons.filter_list),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return list.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: getTextWidget(text: choice),
            );
          }).toList();
        },
      ),
    );
  }

  static showToast(BuildContext context, var _message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.buttonColor,
        content: MyWidgets.getTextWidget(
          text: '$_message',
          color: colors.textColor,
          size: Fonts.appBarTitle_size,
        ),
      ),
    );
  }

  static Widget getIndicator(
      {double height = 12,
      double width = 12,
      int positionIndex = 0,
      currentIndex = 0}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: colors.buttonColor),
          color: positionIndex == currentIndex
              ? colors.buttonColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }

  static int compareTime(TimeOfDay first, TimeOfDay second) {
    if (first.hour < second.hour) return -1;
    if (first.hour > second.hour) return 1;
    if (first.minute < second.minute) return -1;
    if (first.minute > second.minute) return 1;
    return 0;
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static String getTimeWithZone(TimeOfDay time) {
    return DateFormat.jm()
        .format(DateFormat("hh:mm a").parse("${time.hour}:${time.minute}:00"));
  }

  static AlertStyle getAlertStyle(
      {AnimationType animation = AnimationType.fromTop}) {
    return AlertStyle(
      animationType: animation,
      isCloseButton: true,
      isButtonVisible: false,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 1000),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
          fontSize: Fonts.dialog_heading_size,
          fontFamily: Fonts.default_font,
          fontWeight: FontWeight.bold),
    );
  }
}

class CreateFormFieldDropDown extends StatefulWidget {
  List<String> dropDownList;
  VoidCallback complaintCallback;
  var type = null;
  var title;

  IconData icon;
  CreateFormFieldDropDown(
      {this.dropDownList,
      this.chosenType,
      this.title = 'Filter Type',
      this.icon = Icons.filter,
      this.type,
      this.complaintCallback});

  String chosenType;
  _CreateFormFieldDropDown state;
  @override
  State<StatefulWidget> createState() => state = _CreateFormFieldDropDown();
}

class _CreateFormFieldDropDown extends State<CreateFormFieldDropDown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.chosenType,
      autofocus: true,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      decoration: MyWidgets.getTextFormDecoration(
          title: widget.title, icon: widget.icon),
      onChanged: (String newValue) {
        setState(() {
          widget.chosenType = newValue;
        });
        if (widget.type == 'complaint') widget.complaintCallback();
      },
      items: widget.dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
    );
  }
}

class TextForm extends StatefulWidget {
  String value;

  // MyCustomForm({ Key key }) : super(key: key);
  TextForm({this.label = 'date', this.icon = Icons.calendar_today, Key key})
      : super(key: key);
  String label;
  final IconData icon;
  TextEditingController controller;

  _TextForm state;
  @override
  State<StatefulWidget> createState() => state = _TextForm();
}

class _TextForm extends State<TextForm> {
  // TextEditingController controller;

  @override
  void initState() {
    super.initState();
    widget.controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      onChanged: (value) {
        setState(() {
          widget.value = value;
        });
      },
      textCapitalization: TextCapitalization.words,
      decoration: MyWidgets.getTextFormDecoration(
          title: widget.label, icon: widget.icon),
    );
  }
}

class TextFormDate extends StatefulWidget {
  TextFormDate({this.label = 'date', this.icon = Icons.calendar_today, Key key})
      : super(key: key);
  String type;
  String label;
  final IconData icon;
  DateTime date;
  TextEditingController controller;

  _TextFormDate state;
  @override
  State<StatefulWidget> createState() => state = _TextFormDate();
}

class _TextFormDate extends State<TextFormDate> {
  // TextEditingController controller;

  @override
  void initState() {
    super.initState();
    widget.controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        readOnly: true,
        autofocus: true,
        cursorColor: colors.buttonColor,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        textCapitalization: TextCapitalization.words,
        decoration: MyWidgets.getTextFormDecoration(
            title: widget.label, icon: widget.icon),
        onTap: () {
          displayDatePicker(context);
        });
  }

  void displayDatePicker(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        String day = value.day.toString();
        String month = value.month.toString();
        String year = value.year.toString();
        String date = '${day}-${month}-${year}';

        widget.controller.text = date;

        setState(() {
          widget.date = value;
          widget.controller.text = date;
        });
      }
    });
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange, this.allowed = false})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;
  final bool allowed;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;
      if (isNumeric(value)) {
        if (value.contains(".") && allowed) {
          // if (value.substring(value.indexOf(".") + 1).contains(".")) {
          //   truncated = oldValue.text;
          //   newSelection = oldValue.selection;
          // }
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        }
        if (value.contains(".") &&
            value.substring(value.indexOf(".") + 1).length > decimalRange) {
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        } else if (value == ".") {
          truncated = "0.";

          newSelection = newValue.selection.copyWith(
            baseOffset: math.min(truncated.length, truncated.length + 1),
            extentOffset: math.min(truncated.length, truncated.length + 1),
          );
        }
      } else {
        if (value != '') {
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        }
      }
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
