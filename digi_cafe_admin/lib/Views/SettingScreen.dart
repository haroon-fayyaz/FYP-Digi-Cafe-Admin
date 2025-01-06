import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'LoadingWidget.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'NoIternetScreen.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SettingScreen(),
    );
  }
}

class _SettingScreen extends StatefulWidget {
  _SettingScreen();

  @override
  State<StatefulWidget> createState() => __SettingScreen();
}

class __SettingScreen extends State<_SettingScreen> {
  BuildContext _buildContext;
  var openingTime = '';
  var closingTime = '';
  var callsCount = 0;
  EmployeeUIController _controller;
  var edtControllerVotes;

  var _displayLoadingWidget = true;

  TimeOfDay opening = null;

  var edtControllerCount;
  @override
  void initState() {
    super.initState();
    opening = MyWidgets.stringToTimeOfDay('9:00 AM');
    _controller = new EmployeeUIController();
    edtControllerCount = new TextEditingController();
    edtControllerVotes = new TextEditingController();
  }

  Future<void> loadSettingsData(BuildContext context) async {
    DocumentSnapshot snapshot = await _controller.getSettings();
    // print(snapshot.exists);
    if (snapshot.exists) {
      setState(() {
        opening =
            MyWidgets.stringToTimeOfDay(snapshot['openingTime'].toString());
        openingTime = snapshot['openingTime'];
        closingTime = snapshot['closingTime'];
        edtControllerCount.text = snapshot['selectionCount'].toString();
        edtControllerVotes.text = snapshot['minVotes'].toString();
        _displayLoadingWidget = false;
      });
    } else {
      setState(() {
        opening = MyWidgets.stringToTimeOfDay('9:00 AM');
        openingTime = '9:00 AM';
        closingTime = '9:00 PM';
        edtControllerVotes.text = '5';
        edtControllerCount.text = '5';
        _controller.saveSettings(
            count: edtControllerCount.text,
            votes: edtControllerVotes.text,
            openingTime: openingTime,
            closingTime: closingTime);
        _displayLoadingWidget = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (callsCount == 0) {
        await loadSettingsData(_buildContext);
        callsCount++;
      }
    });

    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: SettingScreen())
          : Scaffold(
              appBar: MyWidgets.getFilterAppBar(context: context, text: 'Settings'),
              backgroundColor: colors.backgroundColor,
              body: Stack(
                children: [
                  if (_displayLoadingWidget)
                    LoadingWidget()
                  else
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyWidgets.getSettingsHeading(
                                title: 'Voting', top: 50.0),
                            Padding(
                              padding: EdgeInsets.only(top: 20, right: 40),
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                controller: edtControllerCount,
                                textCapitalization: TextCapitalization.words,
                                decoration: MyWidgets.getTextFormDecoration(
                                    title: 'Selections Count',
                                    icon: Icons.select_all_rounded),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, right: 40),
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                controller: edtControllerVotes,
                                textCapitalization: TextCapitalization.words,
                                decoration: MyWidgets.getTextFormDecoration(
                                    title: 'Minimum Votes Per Food Item',
                                    hint: 'Votes/Item',
                                    icon: Icons.confirmation_number),
                              ),
                            ),
                            MyWidgets.getSettingsHeading(
                                title: 'Cafe Timing', top: 50.0),
                            MyWidgets.getSettingsRow(
                                title: 'Opening Time',
                                iconData: FaIcon(
                                  FontAwesomeIcons.clock,
                                  color: colors.buttonColor,
                                ),
                                subTitle: '$openingTime',
                                onTap: () {
                                  DateTime now = DateTime.now();
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: now.hour, minute: now.minute),
                                  ).then((value) {
                                    if (value != null)
                                      setState(() {
                                        opening = value;
                                        openingTime =
                                            MyWidgets.formatTimeOfDay(value);
                                      });
                                  });
                                }),
                            MyWidgets.getSettingsRow(
                                title: 'Closing Time',
                                subTitle: '$closingTime',
                                iconData: FaIcon(
                                  FontAwesomeIcons.solidClock,
                                  color: colors.buttonColor,
                                ),
                                onTap: () {
                                  DateTime now = DateTime.now();
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: now.hour, minute: now.minute),
                                  ).then((value) {
                                    if (value != null) {
                                      int result =
                                          MyWidgets.compareTime(value, opening);
                                      if (result >= 0) {
                                        setState(() {
                                          closingTime =  MyWidgets.formatTimeOfDay(value);
                                        });
                                      } else {
                                        MyWidgets.showToast(_buildContext,
                                            'Closing Time must be greater than Opening Time');
                                      }
                                    }
                                  });
                                }),
                            SizedBox(height: 50),
                            Align(
                                alignment: Alignment.center,
                                child: MyWidgets.getButton(
                                    text: 'Save',
                                    onTap: () async {
                                      if (edtControllerVotes.text == null) {
                                        MyWidgets.showToast(_buildContext,
                                            'Enter Minimum Votes Per Food Item');
                                        return;
                                      }
                                      if (edtControllerCount.text == null) {
                                        MyWidgets.showToast(_buildContext,
                                            'Enter Selections Allowed');
                                        return;
                                      }

                                      setState(() {
                                        _displayLoadingWidget = true;
                                      });
                                      // bool done = false;
                                      // await MyWidgets.internetStatus(context)
                                      //     .then((value) {
                                      //   done = value;
                                      // });
                                      // print(done);
                                      // if (done) {
                                      //   setState(() {
                                      //     _displayLoadingWidget = false;
                                      //   });
                                      //   return;
                                      // }
                                      await _controller
                                          .saveSettings(
                                              count: edtControllerCount.text,
                                              votes: edtControllerVotes.text,
                                              openingTime: openingTime,
                                              closingTime: closingTime)
                                          .then((value) {
                                        setState(() {
                                          _displayLoadingWidget = false;
                                        });
                                        if (value)
                                          MyWidgets.showToast(_buildContext,
                                              'Setting Updated Successfully');
                                        else
                                          MyWidgets.showToast(_buildContext,
                                              'An unexpected error has occurred. Try Again Later');
                                      });
                                    })),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
