import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'LoadingWidget.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'NoIternetScreen.dart';
import 'ViewOrderDetails.dart';

class ViewDuesDetailScreen extends StatefulWidget {
  String docId;
  ViewDuesDetailScreen({this.docId});
  @override
  State<StatefulWidget> createState() => new _ViewDuesDetailScreen();
}

class _ViewDuesDetailScreen extends State<ViewDuesDetailScreen> {
  Stream<QuerySnapshot> querySnapshot;
  OrderUIController uiController;

  @override
  void initState() {
    super.initState();
    uiController = new OrderUIController();

    querySnapshot = uiController.getDuesDetailSnapshot(docId: widget.docId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(
              screen: ViewDuesDetailScreen(
              docId: widget.docId,
            ))
          : Scaffold(
              appBar: MyWidgets.getFilterAppBar(
                context: context,
                text: 'View Dues Detail',
              ),
              backgroundColor: colors.backgroundColor,
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
                                  DocumentSnapshot duesDoc =
                                      snapshot.data.documents[index];
                                  String docID = duesDoc.documentID;
                                  return FutureBuilder<Order>(
                                      future:
                                          uiController.fetchOrderData(docID),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        } else {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.28,
                                            child: InkWell(
                                              onTap: () async {
                                                MyWidgets.changeScreen(
                                                    context: context,
                                                    screen: ViewOrderDetails(
                                                        docID));
                                              },
                                              child: Card(
                                                elevation: 8,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      MyWidgets.getTextWidget(
                                                          text:
                                                              'Order No: ${docID}',
                                                          weight:
                                                              FontWeight.bold),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      MyWidgets.getTextWidget(
                                                          text: 'Amount: ' +
                                                              snapshot.data
                                                                  .totalAmount
                                                                  .toString()),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                });
                      } else
                        return LoadingWidget();
                    }),
              ),
            ),
    );
  }
}
