import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:readmore/readmore.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';

import 'NoIternetScreen.dart';

class CheckFoodReviewScreen extends StatefulWidget {
  final orderDoc;

  const CheckFoodReviewScreen(this.orderDoc, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CheckFoodReview();
}

class _CheckFoodReview extends State<CheckFoodReviewScreen> {
  Stream<QuerySnapshot> querySnapshot;
  OrderUIController uiController;
  @override
  void initState() {
    super.initState();
    uiController = new OrderUIController();
    querySnapshot = uiController.getOrderSnapshot(widget.orderDoc);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: CheckFoodReviewScreen(widget.orderDoc))
          : Scaffold(
              appBar: MyWidgets.getFilterAppBar(context: context, text: 'View Food Reviews'),
              body: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: querySnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return !snapshot.hasData
                            ? LoadingWidget()
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot orderItemDoc =
                                      snapshot.data.documents[index];
                                  return FutureBuilder<DocumentSnapshot>(
                                      future: uiController.getFoodItemData(
                                          orderItemDoc.documentID),
                                      builder: (context, snap) {
                                        if (!snap.hasData) {
                                          return Container();
                                        } else {
                                          if (snap.data.exists) {}
                                          return Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Card(
                                              elevation: 8,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 10),
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
                                                        children: <Widget>[
                                                          Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    minHeight:
                                                                        30,
                                                                    minWidth:
                                                                        30,
                                                                    maxHeight:
                                                                        85,
                                                                    maxWidth:
                                                                        85),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Image
                                                                .network(snap
                                                                        .data[
                                                                    'imgURL']),
                                                          ),
                                                          MyWidgets.getTextWidget(
                                                              color: colors
                                                                  .buttonColor,
                                                              weight: FontWeight
                                                                  .bold,
                                                              text: snap.data[
                                                                  'name']),
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Row(
                                                              children: [
                                                                MyWidgets.getTextWidget(
                                                                    size: Fonts
                                                                        .heading3_size,
                                                                    text: orderItemDoc
                                                                        .data[
                                                                            'rating']
                                                                        .toString()),
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                          .yellow[
                                                                      700],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    orderItemDoc.data[
                                                                'review'] !=
                                                            null
                                                        ? ReadMoreText(
                                                            orderItemDoc
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
                                                                ' Show less',
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                },
                              );
                      } else
                        return LoadingWidget();
                    }),
              ),
            ),
    );
  }
}
