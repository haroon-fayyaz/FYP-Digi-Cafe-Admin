import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'AddVoucher.dart';
import 'DialogInstruction.dart';
import 'MyWidgets.dart';
import 'ViewVouchers.dart';

class ViewVouchersTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewVouchersTabs();
}

class _ViewVouchersTabs extends State<ViewVouchersTabs>
    with TickerProviderStateMixin {
  String chosenFilterCategory;

  var displayAlertMsg = false;
  ViewVouchers _adminVouchers;
  ViewVouchers _cancelVouchers;
  TabController _tabController;
  final _kTabs = <Widget>[
    Tab(
      text: 'Food Vouchers',
    ),
    Tab(
      text: 'Cancel Orders Voucher',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _adminVouchers = new ViewVouchers(type: false);
    _cancelVouchers = new ViewVouchers(type: true);
    _tabController = new TabController(vsync: this, length: _kTabs.length);
  }

  Widget build(BuildContext context) {
    final _kTabsPages = <Widget>[
      _adminVouchers,
      _cancelVouchers,
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 20),
            backgroundColor: colors.buttonColor,
            children: [
              MyWidgets.getSpeedDialChild(
                  icon: Icons.fastfood,
                  text: 'Add Vouchers',
                  callback: () {
                    MyWidgets.changeScreen(
                        context: context, screen: AddVoucherScreen(null, null));
                  }),
              MyWidgets.getSpeedDialChild(
                icon: Icons.help_outline,
                text: 'Help',
                bgColor: colors.backgroundColor,
                iconColor: Colors.blue[800],
                callback: () {
                  createHelpAlert(context);
                },
              ),
            ]),
        backgroundColor: colors.backgroundColor,
        appBar: MyWidgets.getFilterAppBar(
          context: context,
          text: 'View Vouchers',
          bottom: TabBar(
            controller: _tabController,
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _kTabsPages,
        ),
      ),
    );
  }

  void createHelpAlert(context) async {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
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
    Alert(
        context: context,
        style: alertStyle,
        title: 'How to use?',
        content: Column(
          children: [
            DialogInstruction.getInstructionRow('Single tap to update Voucher'),
            DialogInstruction.getInstructionRow('Long Press to delete Voucher'),
          ],
        )).show();
  }

  Widget getTextWidget(var data) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: MyWidgets.getTextWidget(text: data, size: Fonts.heading1_size),
      ),
    );
  }
}
