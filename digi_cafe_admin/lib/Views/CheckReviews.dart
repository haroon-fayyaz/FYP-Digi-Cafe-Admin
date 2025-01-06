import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'LoadingWidget.dart';
import 'CheckFoodReviewScreen.dart';
import 'package:readmore/readmore.dart';
import 'MyWidgets.dart';
import 'NoIternetScreen.dart';

class CheckReviewsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CheckReviewsScreen();
}

class _CheckReviewsScreen extends State<CheckReviewsScreen> {
  Stream<QuerySnapshot> querySnapshot;
  OrderUIController uiController;

  final ValueNotifier<Stream<QuerySnapshot>> _counter =
      ValueNotifier<Stream<QuerySnapshot>>(null);
  bool flag = true;
  @override
  void initState() {
    super.initState();

    uiController = new OrderUIController();
    // _counter.value = uiController.getDuesSnapshot();
    _counter.value = uiController.getOrderReviewsSnapshot(no: 0);
  }

  void handleClick(String value) {
    int i = 0;
    switch (value) {
      case 'Most Relevant':
        i = 1;
        break;
      case 'Positive Reviews':
        i = 2;
        break;
      case 'Negative Reviews':
        i = 3;
        break;
    }

    _counter.value = uiController.getOrderReviewsSnapshot(no: i);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: CheckReviewsScreen())
          : Scaffold(
              appBar: MyWidgets.getPopMenu(context: context, list: <String>[
                'Most Relevant',
                'Positive Reviews',
                'Negative Reviews'
              ], onSelected: handleClick, text: 'View Order Reviews'),
              backgroundColor: colors.backgroundColor,
              body: SingleChildScrollView(
                child: ValueListenableBuilder(
                  builder: (BuildContext context,
                      Stream<QuerySnapshot> querySnapshot, Widget child) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: querySnapshot,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            return !snapshot.hasData
                                ? LoadingWidget()
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot orderDoc =
                                          snapshot.data.documents[index];

                                      return Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: InkWell(
                                          onTap: () async {
                                            MyWidgets.changeScreen(
                                                context: context,
                                                screen: CheckFoodReviewScreen(
                                                    orderDoc.documentID));
                                          },
                                          child: Card(
                                            elevation: 8,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      MyWidgets.getTextWidget(
                                                          color: colors
                                                              .buttonColor,
                                                          weight:
                                                              FontWeight.bold,
                                                          size: Fonts
                                                                  .heading2_size +
                                                              2,
                                                          text: 'Order No: ' +
                                                              orderDoc.data[
                                                                      'orderNo']
                                                                  .toString()),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Row(
                                                          children: [
                                                            MyWidgets.getTextWidget(
                                                                size: Fonts
                                                                    .heading3_size,
                                                                text: orderDoc
                                                                    .data[
                                                                        'rating']
                                                                    .toString()),
                                                            Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .yellow[700],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(),
                                                  orderDoc.data['review'] !=
                                                          null
                                                      ? ReadMoreText(
                                                          orderDoc
                                                              .data['review'],
                                                          style: MyWidgets
                                                              .getTextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          trimLines: 2,
                                                          colorClickableText:
                                                              colors
                                                                  .buttonColor,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              '...Show more',
                                                          trimExpandedText:
                                                              ' show less',
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          } else
                            return Container();
                        });
                  },
                  valueListenable: _counter,
                  child: const Text('Good job!'),
                ),
              ),
            ),
    );
  }
}
