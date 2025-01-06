import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/Views/ViewOrderDetails.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:intl/intl.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';

import 'FeedbackDetailsClass.dart';
import 'NoIternetScreen.dart';

class ViewFeedbackDetails extends StatefulWidget {
  String type;
  String complaintID;
  ViewFeedbackDetails(this.type, this.complaintID);
  @override
  State<StatefulWidget> createState() => _ViewFeedbackDetailsState();
}

class _ViewFeedbackDetailsState extends State<ViewFeedbackDetails> {
  OrderUIController _orderUIController;
  FeedbackDetails _feedbackDetails;

  var replyController = new TextEditingController();

  var _buttonPressed = false;

  @override
  void initState() {
    super.initState();
    _orderUIController = new OrderUIController();
    _feedbackDetails = new FeedbackDetails();
    _orderUIController
        .getFeedbackData(widget.complaintID, widget.type)
        .then((value) {
      _feedbackDetails = value;
    });
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(
              screen: ViewFeedbackDetails(widget.type, widget.complaintID))
          : Scaffold(
              appBar: MyWidgets.getFilterAppBar(
                  context: context,
                  text: 'View ' +
                      widget.type[0].toUpperCase() +
                      widget.type.substring(1) +
                      ' Details'),
              backgroundColor: colors.backgroundColor,
              body: SafeArea(
                child: SingleChildScrollView(
                    child: FutureBuilder<FeedbackDetails>(
                  builder: (context, snapshot) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      replyController.text = _feedbackDetails.reply == null
                          ? ''
                          : _feedbackDetails.reply;
                    });
                    if (!snapshot.hasData) {
                      return LoadingWidget();
                    } else {
                      FeedbackDetails details = snapshot.data;
                      _feedbackDetails = details;
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: MyWidgets.getTextWidget(
                                      text: 'Name: ${details.name}',
                                      size: Fonts.heading2_size,
                                      overflow: TextOverflow.ellipsis,
                                      weight: FontWeight.bold),
                                ),
                                //email
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: MyWidgets.getTextWidget(
                                      text: 'Email: ${details.email}',
                                      size: Fonts.heading2_size,
                                      weight: FontWeight.bold),
                                ),
                                //category
                                widget.type == 'complaint'
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: MyWidgets.getTextWidget(
                                          text: 'Category: ${details.category}',
                                          size: Fonts.heading2_size,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : Container(),
                                //order

                                details.orderNo != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            MyWidgets.getTextWidget(
                                              text: 'Order: ',
                                              size: Fonts.heading2_size,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                MyWidgets.changeScreen(
                                                    context: context,
                                                    screen: ViewOrderDetails(
                                                        details.orderNo));
                                              },
                                              child: MyWidgets.getTextWidget(
                                                  text: details.orderNo,
                                                  size: Fonts.link_size,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                //feedback
                                Padding(
                                  padding: const EdgeInsets.only(top: 14.0),
                                  child: MyWidgets.getTextWidget(
                                      text: widget.type == 'complaint'
                                          ? 'Customer Complaint'
                                          : 'Customer Suggestion',
                                      size: Fonts.heading3_size,
                                      overflow: TextOverflow.ellipsis,
                                      weight: FontWeight.bold),
                                ),

                                Wrap(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minHeight: 100, maxHeight: 300),
                                      margin: EdgeInsets.only(top: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: colors.buttonColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: MyWidgets.getTextWidget(
                                        text: details.text,
                                        size: Fonts.heading2_size,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 14.0),
                                  child: MyWidgets.getTextWidget(
                                      text: 'Reply',
                                      size: Fonts.heading3_size,
                                      overflow: TextOverflow.ellipsis,
                                      weight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: TextField(
                                      controller: this.replyController,
                                      maxLines: 5,
                                      maxLength: 400,
                                      enabled:
                                          details.reply == null ? true : false,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration:
                                          MyWidgets.getTextFormDecoration(
                                              title: 'Write Reply',
                                              hint: 'Your text here',
                                              icon: null),
                                      style: TextStyle(
                                        fontSize: Fonts.heading2_size,
                                        fontFamily: Fonts.default_font,
                                      ),
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: colors.buttonColor,
                                      ),
                                      width: 175,
                                      height: 50,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: _feedbackDetails
                                                      .reply !=
                                                  null
                                              ? Colors.grey
                                              : colors
                                                  .buttonColor, // Disable color
                                          padding: EdgeInsets.all(
                                              16.0), // Adjust padding as needed
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Rounded corners
                                          ),
                                        ),
                                        onPressed: _feedbackDetails.reply !=
                                                null
                                            ? null
                                            : () async {
                                                setState(() {
                                                  _buttonPressed = true;
                                                });
                                                await _orderUIController
                                                    .submitReply(
                                                  text: details.text,
                                                  feedbackID: details.id,
                                                  reply: replyController.text,
                                                  type: widget.type,
                                                  email: details.email,
                                                )
                                                    .then((value) {
                                                  setState(() {
                                                    _buttonPressed = false;
                                                  });
                                                });
                                              },
                                        child: Stack(
                                          children: <Widget>[
                                            Visibility(
                                              visible: !_buttonPressed,
                                              child: MyWidgets.getTextWidget(
                                                text: 'Reply',
                                                size: Fonts.heading3_size,
                                                color: colors.buttonTextColor,
                                              ),
                                            ),
                                            Visibility(
                                              visible: _buttonPressed,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
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
                  },
                  future: _orderUIController.getFeedbackData(
                      widget.complaintID, widget.type),
                )

                    //name

                    //email
                    //date
                    //feedback text
                    //reply textbox
                    ),
              ),
            ),
    );
  }
}
