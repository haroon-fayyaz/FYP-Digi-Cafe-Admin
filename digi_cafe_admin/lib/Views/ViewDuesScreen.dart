import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'LoadingWidget.dart';
import 'MyWidgets.dart';
import 'NoIternetScreen.dart';
import 'ViewDuesDetailScreen.dart';

class ViewDuesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ViewDuesScreen();
}

class _ViewDuesScreen extends State<ViewDuesScreen> {
  Stream<QuerySnapshot> querySnapshot;
  OrderUIController uiController;

  List<Dues> cardsList = new List<Dues>();

  @override
  void initState() {
    super.initState();
    uiController = new OrderUIController();

    querySnapshot = uiController.getDuesSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: ViewDuesScreen())
          : Scaffold(
              appBar: MyWidgets.getFilterAppBar(
                  context: context,
                  text: 'View Dues',
                  child: Icons.notifications,
                  onTap: () {
                    MyWidgets.showConfirmationDialog(context,
                        text: 'Do you want to notify all persons?',
                        callback: () async {
                      for (int i = 0; i < cardsList.length; i++) {
                        await uiController.sendNotifications(
                            'Pending Dues',
                            cardsList[i].getTokenId,
                            'Dear ${cardsList[i].getName}, Rs. ${cardsList[i].getDuesTotal.toInt().toString()} are due on your side. Kindly pay them as soon as possible.');
                      }
                    });
                  }),
              backgroundColor: colors.backgroundColor,
              body: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: querySnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        cardsList = <Dues>[];
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
                                  Dues dues = new Dues(
                                      docID: duesDoc.documentID,
                                      duesTotal:
                                          duesDoc.data['dues'].toDouble());
                                  return FutureBuilder<DocumentSnapshot>(
                                      future: uiController
                                          .getPersonData(dues.docID),
                                      builder: (context, snap) {
                                        if (!snap.hasData) {
                                          return Container();
                                        } else {
                                          if (snap.data.exists) {
                                            dues.setEmail = snap.data['email'];
                                            dues.setName = snap.data['Name'];
                                            dues.setTokenId =
                                                snap.data['tokenID'];
                                          }
                                          cardsList.add(dues);
                                          return Container(
                                            margin: EdgeInsets.only(
                                                left: 5, top: 10, right: 5),
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
                                                    screen:
                                                        ViewDuesDetailScreen(
                                                            docId: dues.docID));
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
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          MyWidgets.getTextWidget(
                                                              text:
                                                                  dues.getName,
                                                              size: Fonts
                                                                  .heading1_size,
                                                              color: colors
                                                                  .buttonColor,
                                                              weight: FontWeight
                                                                  .bold),
                                                          MyWidgets.getTextWidget(
                                                              size: Fonts
                                                                  .heading3_size,
                                                              text: 'Rs. ' +
                                                                  dues.getDuesTotal
                                                                      .toInt()
                                                                      .toString()),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      MyWidgets.getTextWidget(
                                                          text: dues.getEmail,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
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

class Dues {
  double duesTotal;
  String tokenId;

  String docID;
  String email;
  String name;

  String get getTokenId => this.tokenId;

  set setTokenId(String tokenId) => this.tokenId = tokenId;
  String get getEmail => this.email;

  set setEmail(String email) => this.email = email;

  get getName => this.name;

  set setName(name) => this.name = name;
  double get getDuesTotal => this.duesTotal;

  set setDuesTotal(double duesTotal) => this.duesTotal = duesTotal;

  get getDocID => this.docID;

  set setDocID(docID) => this.docID = docID;

  Dues({this.duesTotal, this.docID});
}
