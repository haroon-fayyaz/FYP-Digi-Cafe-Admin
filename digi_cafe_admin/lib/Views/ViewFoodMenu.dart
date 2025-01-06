import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Views/AddCategory.dart';
import 'package:digi_cafe_admin/Views/AddFoodMenu.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/Views/DialogInstruction.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/MenuItemWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'NoIternetScreen.dart';

class ViewFoodMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewFoodMenu();
}

class _ViewFoodMenu extends State<ViewFoodMenu> {
  FoodMenuUIController _foodMenuUIController;
  Stream<QuerySnapshot> querySnapshot;

  BuildContext buildContext;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
    querySnapshot = _foodMenuUIController.getFoodMenuSnapshot();
  }

  GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    this.buildContext = context;
    return ConnectivityWidget(
        builder: (context, isOnline) => !isOnline
            ? NoInternetScreen(screen: ViewFoodMenu())
            : Scaffold(
                key: scaffoldKey,
                appBar: MyWidgets.getFilterAppBar(
                    context: context,
                    text: 'View Food Menu',
                    child: Icons.refresh,
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _foodMenuUIController
                          .autoRestockAll()
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                        MyWidgets.toastWithKey(
                            scaffoldKey, 'Food Items Restocked');
                      });
                    }),
                backgroundColor: colors.backgroundColor,
                floatingActionButton: SpeedDial(
                    animatedIcon: AnimatedIcons.menu_close,
                    animatedIconTheme: IconThemeData(size: 20),
                    backgroundColor: colors.buttonColor,
                    children: [
                      MyWidgets.getSpeedDialChild(
                        icon: Icons.fastfood,
                        text: 'Add Food Item',
                        callback: () {
                          MyWidgets.changeScreen(
                              context: context, screen: AddFoodMenuScreen());
                        },
                      ),
                      MyWidgets.getSpeedDialChild(
                        icon: Icons.fastfood,
                        text: 'Add Category',
                        callback: () {
                          MyWidgets.changeScreen(
                              context: context, screen: AddCategoryScreen());
                        },
                      ),
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
                body: _isLoading
                    ? LoadingWidget()
                    : Flex(
                        direction: Axis.vertical,
                        verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                            Flexible(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: querySnapshot,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      if (!snapshot.hasData) {
                                        return LoadingWidget();
                                      }

                                      // Group items by category
                                      Map<String, List<DocumentSnapshot>>
                                          groupedItems = {};
                                      snapshot.data.documents.forEach((doc) {
                                        String category = doc.data['category'];
                                        if (!groupedItems
                                            .containsKey(category)) {
                                          groupedItems[category] = [];
                                        }
                                        groupedItems[category].add(doc);
                                      });

                                      return ListView.builder(
                                        itemCount: groupedItems.keys.length,
                                        itemBuilder: (context, index) {
                                          String category = groupedItems.keys
                                              .elementAt(index);
                                          List<DocumentSnapshot> items =
                                              groupedItems[category];

                                          return Card(
                                            elevation: 10,
                                            margin: EdgeInsets.all(10),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  getTextWidget(
                                                      capitalize(category)),
                                                  Column(
                                                    children: items
                                                        .asMap()
                                                        .map((idx, dish) {
                                                          return MapEntry(
                                                              idx,
                                                              Column(
                                                                children: <
                                                                    Widget>[
                                                                  MenuItemWidget(
                                                                    quantity: dish
                                                                            .data[
                                                                        'stockLeft'],
                                                                    foodImg: dish
                                                                            .data[
                                                                        'imgURL'],
                                                                    category: dish
                                                                            .data[
                                                                        'category'],
                                                                    foodID: dish
                                                                        .documentID,
                                                                    price: dish
                                                                        .data[
                                                                            'price']
                                                                        .toString(),
                                                                    description:
                                                                        dish.data[
                                                                            'description'],
                                                                    name: dish
                                                                            .data[
                                                                        'name'],
                                                                    autoRestock:
                                                                        dish.data[
                                                                            'autoRestock'],
                                                                    context:
                                                                        buildContext,
                                                                    scaffoldKey:
                                                                        scaffoldKey,
                                                                  ),
                                                                  idx ==
                                                                          items.length -
                                                                              1
                                                                      ? Container()
                                                                      : Divider(
                                                                          thickness:
                                                                              1.1,
                                                                        ),
                                                                ],
                                                              ));
                                                        })
                                                        .values
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return LoadingWidget();
                                    }
                                  }),
                            ),
                          ]),
              ));
  }

  String capitalize(String string) {
    if (string == null) {
      return null;
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
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
      titleStyle: MyWidgets.getTextStyle(
          size: Fonts.dialog_heading_size, weight: FontWeight.bold),
    );
    Alert(
        context: context,
        style: alertStyle,
        title: 'How to use?',
        content: Column(
          children: [
            DialogInstruction.getInstructionRow(
                'Single tap to update food item'),
            DialogInstruction.getInstructionRow(
                'Double tap to update quantity'),
            DialogInstruction.getInstructionRow(
                'Long Press to delete food item'),
          ],
        )).show();
  }

  Widget getTextWidget(var data) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: MyWidgets.getTextWidget(
            text: data, size: Fonts.heading1_size, weight: FontWeight.w600),
      ),
    );
  }
}
