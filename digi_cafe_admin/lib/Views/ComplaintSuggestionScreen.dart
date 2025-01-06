import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Views/ComplaintScreen.dart';
import 'package:digi_cafe_admin/Views/SuggestionsScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'MyWidgets.dart';

class ComplaintSuggestionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ComplaintSuggestionScreen();
}

class _ComplaintSuggestionScreen extends State<ComplaintSuggestionScreen>
    with TickerProviderStateMixin {
  BuildContext _buildContext;

  String chosenFilterCategory;

  StateSetter _setState;

  var displayAlertMsg = false;

  DateTime fromDate;

  DateTime toDate;
  TabController _tabController;
  final _kTabs = <Widget>[
    Tab(
      text: 'Complaints',
    ),
    Tab(
      text: 'Suggestions',
    ),
  ];
  ComplaintScreen _complaintScreen;
  SuggestionScreen _suggestionScreen;
  TextFormDate fromDateWidget;
  TextFormDate toDateWidget;

  var _alertMessage = 'Incomplete Fields';

  @override
  void initState() {
    super.initState();
    _complaintScreen = new ComplaintScreen();
    _suggestionScreen = new SuggestionScreen();
    _tabController = new TabController(vsync: this, length: _kTabs.length);
    fromDateWidget = new TextFormDate(
      label: 'From Date',
    );
    toDateWidget = new TextFormDate(
      label: 'To Date',
    );
  }

  Widget build(BuildContext context) {
    this._buildContext = context;

    final _kTabsPages = <Widget>[
      _complaintScreen,
      _suggestionScreen,
      // CurrentVouchers(false, 0),
      // PastVouchers(),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        backgroundColor: colors.backgroundColor,
        appBar: getSalesAppBar(_buildContext),
        body: TabBarView(
          controller: _tabController,
          children: _kTabsPages,
        ),
      ),
    );
  }

  void createFilterAlert(context) async {
    // _fromDateController.text = _toDateController.text = '';
    displayAlertMsg = false;
    Alert(
      context: context,
      style: MyWidgets.getAlertStyle(),
      title: 'Filter Results',
      content: StatefulBuilder(
        // You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
          _setState = setState;
          return Column(
            children: [
              displayAlertMsg
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: MyWidgets.getTextWidget(
                          weight: FontWeight.bold,
                          size: Fonts.dialog_heading_size,
                          text: _alertMessage,
                          color: colors.warningColor),
                    )
                  : Container(),

              //From Date
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: fromDateWidget,
              ),
              // toDtate,
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: toDateWidget,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 10, bottom: 5, top: 5),
                child: ClipPath(
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.buttonColor,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            colors.buttonColor, // Button background color
                        padding:
                            EdgeInsets.all(16.0), // Adjust padding as needed
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                      ),
                      child: MyWidgets.getTextWidget(
                        text: 'Apply',
                        size: Fonts.button_size,
                        color: colors.buttonTextColor, // Text color
                      ),
                      onPressed: () async {
                        fromDate = fromDateWidget.date;
                        toDate = toDateWidget.date;

                        DateTime fromDateTemp = fromDate;
                        DateTime toDateTemp = toDate;

                        if (fromDate != null && toDate != null) {
                          if (toDate.compareTo(fromDate) >= 0) {
                            setState(() {
                              displayAlertMsg = false;
                            });
                          } else {
                            setState(() {
                              displayAlertMsg = true;
                              _alertMessage =
                                  'To date must be greater than or equal to From Date';
                            });
                            return;
                          }
                          print(fromDate);
                          print(toDate);
                          fromDateTemp = DateTime(fromDate.year, fromDate.month,
                              fromDate.day, 0, 0, 0, 0, 0);
                          toDateTemp = DateTime(toDate.year, toDate.month,
                              toDate.day, 0, 0, 0, 0, 0);
                          _complaintScreen.fromDate = fromDateTemp;
                          _complaintScreen.toDate = toDateTemp;
                          Navigator.pop(context);
                          if (_tabController.index == 0) {
                            _complaintScreen.fromDate = fromDateTemp;
                            _complaintScreen.toDate = toDateTemp;
                            _complaintScreen.complaintState.getQuerySnapshot(
                              _complaintScreen.complaintState.chosenComplaint,
                            );
                          } else {
                            _suggestionScreen.fromDate = fromDateTemp;
                            _suggestionScreen.toDate = toDateTemp;
                            _suggestionScreen.suggestionState
                                .getQuerySnapshot();
                          }
                        } else {
                          _setState(() {
                            displayAlertMsg = true;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ).show();
  }

  Widget getSalesAppBar(
    BuildContext context,
  ) {
    return MyWidgets.getFilterAppBar(
      context: context,
      text: 'Complaints/Suggestions',
      child: Icons.filter_list,
      onTap: () => createFilterAlert(context),
      bottom: TabBar(
        controller: _tabController,
        tabs: _kTabs,
      ),
    );
  }
}
