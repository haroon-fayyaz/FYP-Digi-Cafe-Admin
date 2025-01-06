import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:intl/intl.dart';
import 'NoIternetScreen.dart';

class ViewOrderDetails extends StatefulWidget {
  String orderNo;
  ViewOrderDetails(this.orderNo);
  @override
  State<StatefulWidget> createState() => _ViewOrderDetailsState();
}

class _ViewOrderDetailsState extends State<ViewOrderDetails> {
  var replyController = new TextEditingController();

  var _buttonPressed = false;
  OrderUIController _orderUIController;

  @override
  void initState() {
    super.initState();
    _orderUIController = new OrderUIController();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidget(
        builder: (context, isOnline) => !isOnline
            ? NoInternetScreen(screen: ViewOrderDetails(widget.orderNo))
            : Scaffold(
                appBar: MyWidgets.getFilterAppBar(
                    context: context, text: 'Order Details'),
                backgroundColor: colors.backgroundColor,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: FutureBuilder<Order>(
                        future: _orderUIController
                            .fetchOrderData(widget.orderNo, detail: true),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return LoadingWidget();
                          } else {
                            Order order = snapshot.data;
                            return ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.65),
                                child: Center(
                                  child: Column(
                                    children: [
                                      MyWidgets.getTextWidget(
                                          text: 'Order # ' +
                                              widget.orderNo.toString(),
                                          size: Fonts.heading1_size,
                                          weight: FontWeight.bold,
                                          color: colors.buttonColor),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: MyWidgets.getTextWidget(
                                            text: 'Date: ' +
                                                order.orderTime.day.toString() +
                                                '/' +
                                                order.orderTime.month
                                                    .toString() +
                                                '/' +
                                                order.orderTime.year.toString(),
                                            size: Fonts.heading2_size + 1,
                                            weight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, bottom: 25.0),
                                        child: MyWidgets.getTextWidget(
                                            text: 'Time: ' +
                                                DateFormat.jm()
                                                    .format(order.orderTime),
                                            size: Fonts.heading2_size + 1,
                                            weight: FontWeight.bold),
                                      ),
                                      if (order.getServedBy != '' ||
                                          order.getServedBy == null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.0, bottom: 15.0),
                                          child: MyWidgets.getTextWidget(
                                              text: 'Served By: ' +
                                                  order.servedBy,
                                              size: Fonts.heading2_size + 1,
                                              weight: FontWeight.bold),
                                        ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: order.orderItems.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var item = order.orderItems
                                                .elementAt(index);
                                            return Wrap(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0,
                                                                left: 25),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          child: MyWidgets.getTextWidget(
                                                              text: item
                                                                  .foodItem
                                                                  .name,
                                                              size: Fonts
                                                                      .heading2_size +
                                                                  1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        child: MyWidgets.getTextWidget(
                                                            text: 'x' +
                                                                item.quantity
                                                                    .toString(),
                                                            size: Fonts
                                                                .heading3_size,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0,
                                                                left: 8),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: MyWidgets.getTextWidget(
                                                                text: 'Rs ' +
                                                                    (item.foodItem
                                                                                .price *
                                                                            item
                                                                                .quantity)
                                                                        .toString(),
                                                                size: Fonts
                                                                        .heading3_size +
                                                                    1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 25, right: 25, top: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyWidgets.getTextWidget(
                                                text: 'Total',
                                                size: Fonts.heading2_size,
                                                weight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: MyWidgets.getTextWidget(
                                                  text: 'Rs ' +
                                                      order.totalAmount
                                                          .toString(),
                                                  size: Fonts.heading2_size,
                                                  weight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          }
                        }),
                  ),
                ),
              ));
  }
}
