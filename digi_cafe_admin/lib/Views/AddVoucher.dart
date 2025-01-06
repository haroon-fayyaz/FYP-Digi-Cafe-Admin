import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import '../style/colors.dart';
import 'LoadingWidget.dart';
import 'NoIternetScreen.dart';

class AddVoucherScreen extends StatelessWidget {
  Voucher _voucher;
  var actionType;
  AddVoucherScreen(this._voucher, this.actionType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _AddVoucherScreen(_voucher, actionType),
    );
  }
}

_AddVoucherScreenState _addVoucherScreen;

class _AddVoucherScreen extends StatefulWidget {
  Voucher _voucher;
  var actionType;
  _AddVoucherScreen(this._voucher, this.actionType);
  @override
  _AddVoucherScreenState createState() {
    _addVoucherScreen = _AddVoucherScreenState();
    return _addVoucherScreen;
  }
}

class _AddVoucherScreenState extends State<_AddVoucherScreen> {
  FoodMenuUIController _foodMenuUIController;

  String _voucherTitle = '';

  String _minimumSpend = '';

  String _discount = '';

  String screenHeader;

  var _edtTitleController = new TextEditingController();

  var edtMinimumAmount = new TextEditingController();

  var edtDiscountController = new TextEditingController();

  String btnText;

  var _displayLoadingWidget = false;

  TextFormDate expiryDateWidget;

  var count = 0;

  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
    screenHeader = 'Add Voucher';
    btnText = 'Add';
    expiryDateWidget = new TextFormDate(
      label: 'Expiry Date',
      icon: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await MyWidgets.internetStatus(context).then((value) {
      //   if (value && _displayLoadingWidget)
      //     setState(() {
      //       _displayLoadingWidget = true;
      //     });
      // });
      if (widget.actionType == 'update' && count < 1) {
        expiryDateWidget.state.setState(() {
          expiryDateWidget.controller.text = widget._voucher.getValidity;
          List<String> data = expiryDateWidget.controller.text.split('-');
          var newDate = new DateTime(int.parse(data[2]), int.parse(data[1]),
              int.parse(data[0]), 0, 0, 0, 0, 0);
          expiryDateWidget.date = newDate;
        });

        setState(() {
          screenHeader = 'Update Voucher';
          _edtTitleController.text = _voucherTitle = widget._voucher.getTitle;
          edtMinimumAmount.text =
              _minimumSpend = widget._voucher.getMinimumSpend;
          edtDiscountController.text = _discount = widget._voucher.getDiscount;
          btnText = 'Update';
          count++;
        });
      }
    });
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(
              screen: AddVoucherScreen(widget._voucher, widget.actionType))
          : Scaffold(
              backgroundColor: colors.backgroundColor,
              appBar: MyWidgets.getFilterAppBar(context: context, text: screenHeader),
              body: SafeArea(
                child: Stack(
                  children: [
                    _displayLoadingWidget
                        ? LoadingWidget()
                        : SingleChildScrollView(
                            // physics: NeverScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height) *
                                  0.8,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 75,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: MyWidgets.getTextWidget(
                                              text: 'Voucher Details',
                                              size: Fonts.heading2_XL_size)),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: _edtTitleController,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        onChanged: _voucherTitleChanged,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration:
                                            MyWidgets.getTextFormDecoration(
                                                title: 'Title', icon: null),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: expiryDateWidget,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: TextFormField(
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          DecimalTextInputFormatter(
                                              decimalRange: 1, allowed: true)
                                        ],
                                        controller: edtMinimumAmount,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        onChanged: _minimumSpendChanged,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration:
                                            MyWidgets.getTextFormDecoration(
                                                title: 'Minimum Spend Amount',
                                                icon: null),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: TextFormField(
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        onChanged: _discountChanged,
                                        inputFormatters: [
                                          DecimalTextInputFormatter(
                                              decimalRange: 1, allowed: true)
                                        ],
                                        controller: edtDiscountController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration:
                                            MyWidgets.getTextFormDecoration(
                                                title: 'Discount', icon: null),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: MyWidgets.getButton(
                                            text: btnText,
                                            onTap: () => _addVoucher())),
                                  ],
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

  void _showToast(BuildContext context, var _message) {
    MyWidgets.showToast(context, _message);
  }

  void stopLoading() {
    setState(() {
      _displayLoadingWidget = false;
    });
  }

  Future<void> _addVoucher() async {
    setState(() {
      _displayLoadingWidget = true;
    });
    if (_voucherTitle.trim() == '') {
      _showToast(context, "Enter Voucher");
      stopLoading();
      return;
    }

    if (expiryDateWidget.controller.text.trim() == '') {
      _showToast(context, "Enter Expiry Date");
      stopLoading();
      return;
    }

    DateTime date = expiryDateWidget.date;
    var current = DateTime.now();
    var newDate =
        new DateTime(current.year, current.month, current.day, 0, 0, 0, 0, 0);

    if (date.compareTo(newDate) < 0) {
      _showToast(context, 'Date should not be less than current date');
      stopLoading();
      return;
    }

    if (_minimumSpend.trim() == '') {
      _showToast(context, "Enter Minimum Spend Amount");
      stopLoading();
      return;
    }
    if (_discount.trim() == '') {
      _showToast(context, "Enter Discount");
      stopLoading();
      return;
    }
    if (double.parse(_minimumSpend) < double.parse(_discount)) {
      _showToast(
          context, "Minimum Spend Amount should be greater than Discount");
      stopLoading();
      return;
    }
    if (widget.actionType != 'update') {
      var value = await _foodMenuUIController.addVoucher(_voucherTitle,
          expiryDateWidget.controller.text, _minimumSpend, _discount);
      if (value) {
        await new Future.delayed(const Duration(seconds: 2));
        _showToast(context, "Record Added");
        setState(() {
          _displayLoadingWidget = false;
        });
        Navigator.pop(context);
        return;
      } else {
        _showToast(context, "Fail to add record");
        setState(() {
          _displayLoadingWidget = false;
        });
      }
    } else {
      var value = await _foodMenuUIController.updateVoucher(
          _voucherTitle,
          expiryDateWidget.controller.text,
          _minimumSpend,
          _discount,
          widget._voucher.getId);
      if (value) {
        _showToast(context, "Record updated");
        await new Future.delayed(const Duration(seconds: 2));
        setState(() {
          _displayLoadingWidget = false;
        });
        Navigator.pop(context);
        return;
      } else {
        _showToast(context, "Fail to update record");
        setState(() {
          _displayLoadingWidget = false;
        });
      }
    }
    setState(() {
      _displayLoadingWidget = false;
    });
  }

  void _voucherTitleChanged(String value) {
    _voucherTitle = value;
  }

  void _minimumSpendChanged(String value) {
    _minimumSpend = value;
  }

  void _discountChanged(String value) {
    _discount = value;
  }
}
