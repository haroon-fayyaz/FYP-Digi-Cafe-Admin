import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/FoodMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'MyWidgets.dart';
import 'AddFoodMenu.dart';

class MenuItemWidget extends StatefulWidget {
  var foodImg, price, description, name, foodID;
  var category;
  var quantity;
  bool autoRestock;
  GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  BuildContext context;

  MenuItemWidget(
      {@required this.foodImg,
      @required this.foodID,
      @required this.description,
      @required this.name,
      @required this.price,
      @required this.autoRestock,
      @required this.scaffoldKey,
      this.category,
      this.quantity,
      this.context});

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  FoodMenuUIController _foodMenuUIController;

  BuildContext _buildContext;

  var quantityController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
  }

  @override
  Widget build(BuildContext context) {
    this._buildContext = context;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 5.0,
              width: MediaQuery.of(context).size.width - 10,
              child: InkWell(
                onTap: () {
                  //TODO: Update Employee
                  FoodItem foodItem = new FoodItem(
                      widget.foodID,
                      widget.name,
                      widget.description,
                      widget.foodImg,
                      double.parse(widget.price),
                      widget.quantity.toDouble());
                  List<FoodItem> list = new List();
                  list.add(foodItem);
                  FoodMenu menu = new FoodMenu(widget.category, list);
                  MyWidgets.changeScreen(
                      context: context,
                      screen: AddFoodMenuScreen(
                          foodItem: menu,
                          autoRestock: widget.autoRestock,
                          actionType: "update"));
                },
                onDoubleTap: () {
                  //TODO: UpdateQuantity
                  createAlert(context);
                },
                onLongPress: () {
                  MyWidgets.showConfirmationDialog(_buildContext,
                      text: 'Do you want to remove Food Item?',
                      callback: () async {
                    //TODO: Delete Food
                    bool result = await _foodMenuUIController
                        .deleteFoodItem(widget.foodID);
                    for (int i = 0; i < 2000; i++) {}
                    if (result.toString() == "true") {
                      _showToast(
                          widget.context, "Food Item deleted successfully");
                    } else {
                      _showToast(
                          widget.context, "Food Item delete unsuccessful");
                    }
                  });
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      height: (MediaQuery.of(context).size.height / 5.0) - 70,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: <Widget>[
                          widget.foodImg == null
                              ? Image.asset('images/logo.png')
                              : Image.network(widget.foodImg),
                          Container(
                            height: 37,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(15.0, 20.0)),
                            ),
                            child: FittedBox(
                                child: MyWidgets.getTextWidget(
                                    text: 'PKR ' + widget.price,
                                    weight: FontWeight.w600,
                                    size: Fonts.label_size)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width * 0.88,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.9),
                                    child: MyWidgets.getTextWidget(
                                        text: widget.name,
                                        size: Fonts.dishName_font,
                                        weight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Spacer(flex: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: MyWidgets.getTextWidget(
                                        text:
                                            'Qty: ${widget.quantity.toInt().toString()}',
                                        size: Fonts.dishName_font,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              MyWidgets.getTextWidget(
                                  text: widget.description,
                                  size: Fonts.dishDescription_font,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createAlert(context) async {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromRight,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 500),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        fontSize: Fonts.dialog_heading_size,
        fontFamily: Fonts.default_font,
      ),
    );
    Alert(
        context: context,
        style: alertStyle,
        title: 'Enter Quantity of Item',
        content: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(0),
                child: TextFormField(
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 1)],
                  keyboardType: TextInputType.number,
                  controller: quantityController,
                  textCapitalization: TextCapitalization.words,
                  decoration: MyWidgets.getTextFormDecoration(
                      title: 'Quantity',
                      border: UnderlineInputBorder(),
                      addBorder: false,
                      icon: Icons.format_list_numbered),
                )),
          ],
        ),
        buttons: [
          DialogButton(
            color: colors.buttonColor,
            onPressed: () async {
              print(quantityController.text);
              if (quantityController.text != null) {
                try {
                  // FutureBuilder<bool>(
                  //     future: updateQuantity(),
                  //     builder:
                  //         (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  //       if (snapshot.hasData) {
                  //         print('${snapshot.data}');
                  //       }
                  //     });
                  bool result =
                      await _foodMenuUIController.updateFoodItemQuantity(
                          widget.foodID, double.parse(quantityController.text));

                  print(result);
                  if (result) {
                    _showToast(widget.context, 'Quantity Updated Successfully');
                  } else {
                    _showToast(widget.context, 'Quantity Update Unsuccessful');
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                } catch (ex) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: Text(
              'Update Quantity',
              style: TextStyle(
                fontSize: Fonts.heading2_size,
                fontFamily: Fonts.default_font,
                color: colors.buttonTextColor,
              ),
            ),
          )
        ]).show();
    setState(() {
      int x = widget.quantity.toInt();
      quantityController.text = x.toString();
    });
  }

  Future<bool> updateQuantity() async {
    bool result = await _foodMenuUIController.updateFoodItemQuantity(
        widget.foodID, double.parse(quantityController.text));
    return result;
  }

  void _showToast(BuildContext context, var _message) {
    MyWidgets.toastWithKey(widget.scaffoldKey, _message);
  }
}
