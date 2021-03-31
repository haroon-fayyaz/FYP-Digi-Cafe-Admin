import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/MenuItemWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ViewSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _ViewSales(),
    );
  }
}

class _ViewSales extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __ViewSales();
}

class __ViewSales extends State<_ViewSales> with TickerProviderStateMixin {
  List<MenuItemWidget> menuItemWidget = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  Stream<QuerySnapshot> querySnapshot;
  List<String> filterTypeOptionList = <String>['Daily', 'Monthly', 'Yearly'];
  String chosenFilterType;
  AnimationController _controller;
  BuildContext _buildContext;
  OrderUIController uiController;
  var _fromDateController = new TextEditingController();
  var _toDateController = new TextEditingController();
  NominateItemsDataSource _ds;

  List<SalesViewItems> nominateItems;

  var _displayLoadingWidget = false;
  Stream<QuerySnapshot> selectedItemsSnapshot;

  bool _buttonPressed = false;

  var totalOrders = '';
  var totalAmount = '';
  double amount = 0, orders = 0;

  var displayAlertMsg = false;

  StateSetter _setState;

  final ValueNotifier<Stream<QuerySnapshot>> _counter =
      ValueNotifier<Stream<QuerySnapshot>>(null);

  final ValueNotifier<String> _totalOrdersAmount = ValueNotifier<String>(null);
  final ValueNotifier<String> _totalOrderss = ValueNotifier<String>(null);

  DateTime fromDate;

  DateTime toDate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    uiController = new OrderUIController();
    // querySnapshot = uiController.getOrdersSnapshot();
    _counter.value = uiController.getOrdersSnapshot();
    _totalOrdersAmount.value = "0";
    _totalOrderss.value = "0";
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return Scaffold(
      appBar: getSalesAppBar(),
      bottomNavigationBar: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
            child: ValueListenableBuilder(
                builder:
                    (BuildContext context, String totalOrderss, Widget child) {
                  return Text(
                    '$totalOrderss',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: Fonts.default_font,
                    ),
                  );
                },
                valueListenable: _totalOrderss),

            // Text(
            //   '$totalOrders',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 17,
            //     fontFamily: Fonts.default_font,
            //   ),
            // ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
            child:
                // Text(
                //   '$totalAmount',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 17,
                //     fontFamily: Fonts.default_font,
                //   ),
                // ),
                ValueListenableBuilder(
                    builder: (BuildContext context, String totalOAmount,
                        Widget child) {
                      return Text(
                        '$totalOAmount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: Fonts.default_font,
                        ),
                      );
                    },
                    valueListenable: _totalOrdersAmount),
          ),
        ],
      ),
      body: Flex(
        direction: Axis.vertical,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Flexible(
            //ye paginated ka hai
            child: Stack(
              children: [
                _displayLoadingWidget
                    ? LoadingWidget()
                    : ValueListenableBuilder(
                        builder: (BuildContext context,
                            Stream<QuerySnapshot> querySnapshot, Widget child) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: querySnapshot,
                            builder: (context, snapshot) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _totalOrdersAmount.value = totalAmount;
                                _totalOrderss.value = totalOrders;
                              });
                              if (snapshot.hasData) {
                                List<SalesViewItems> listItems = new List();
                                double amount = 0, orders = 0;
                                for (int count = 0;
                                    count < snapshot.data.documents.length;
                                    count++) {
                                  DocumentSnapshot element =
                                      snapshot.data.documents[count];
                                  String docID = element.documentID;
                                  // print(docID.split('-')[0]);
                                  if (chosenFilterType == 'Monthly') {
                                    DateTime date =
                                        element.data['date'].toDate();

                                    docID = getAlphabeticalMonth(
                                        date.month - 1, date.year);
                                  }
                                  SalesViewItems items = new SalesViewItems(
                                      docID,
                                      // element.data['date'],
                                      element.data['totalOrders'].toString(),
                                      element.data['totalAmount']);
                                  if (items.orders != null) {
                                    orders +=
                                        double.parse(items.orders.toString());
                                  }
                                  if (items.total != null) {
                                    amount +=
                                        double.parse(items.total.toString());
                                  }
                                  listItems.add(items);
                                }
                                // for (var x = 0; x < listItems.length; x++) {
                                //   print(listItems[x].date);
                                //   print(listItems[x].total);
                                //   print(listItems[x].orders);
                                // }
                                // print(orders);
                                print(totalAmount);
                                totalOrders = 'Total Orders: ' +
                                    orders.toInt().toString();
                                totalAmount = 'Total Amount: ' +
                                    amount.toStringAsFixed(1);

                                _ds = new NominateItemsDataSource(listItems);

                                return listItems.length == 0
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight: MediaQuery.of(context)
                                                .size
                                                .height),
                                        child: Center(
                                          // child: Text(
                                          //   'No data found!',
                                          //   style: TextStyle(
                                          //     color: colors.buttonColor,
                                          //     fontFamily: Fonts.default_font,
                                          //     fontSize: Fonts.heading2_XL_size,
                                          //   ),
                                          // ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.75,
                                            child: Lottie.asset(
                                              'assets/no_data_found.json',
                                              controller: _controller,
                                              onLoaded: (composition) {
                                                // Configure the AnimationController with the duration of the
                                                // Lottie file and start the animation.
                                                _controller
                                                  ..duration =
                                                      composition.duration
                                                  ..forward();
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: colors.buttonColor),
                                          child: PaginatedDataTable(
                                            header: Center(
                                              child: Text(
                                                'View Sales',
                                                style: TextStyle(
                                                  fontSize: Fonts.heading1_size,
                                                  fontFamily:
                                                      Fonts.default_font,
                                                ),
                                              ),
                                            ),
                                            dataRowHeight:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7 /
                                                    _rowsPerPage,
                                            rowsPerPage: _rowsPerPage,
                                            availableRowsPerPage: <int>[
                                              5,
                                              10,
                                              20
                                            ],
                                            onRowsPerPageChanged: (int value) {
                                              setState(() {
                                                _rowsPerPage = value;
                                              });
                                            },
                                            showCheckboxColumn: false,
                                            columns: kTableColumns,
                                            source: _ds,
                                          ),
                                        ),
                                      );
                              } else {
                                return LoadingWidget();
                              }
                            },
                          );
                        },
                        valueListenable: _counter,
                        child: const Text('Good job!'),
                      ),
                // Builder(builder: (BuildContext context) {
                //   _totalOrderss.value = totalOrders.toString();

                //   _totalOrdersAmount.value = totalAmount.toString();
                //   return Container();
                // }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void createFilterAlert(context) async {
    // _fromDateController.text = _toDateController.text = '';
    displayAlertMsg = false;
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
        title: 'Filter Results',
        content: StatefulBuilder(
          // You need this, notice the parameters below:
          builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Column(
              children: [
                displayAlertMsg
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                        child: Text(
                          'Incomplete Fields',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: Fonts.dialog_heading_size,
                              fontFamily: Fonts.default_font,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
                // DialogInstruction.getInstructionRow('Single tap to update Order'),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: DropdownButtonFormField<String>(
                    value: chosenFilterType,
                    autofocus: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      hintText: 'FilterType',
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'FilterType',
                      icon: Icon(
                        Icons.person_outline,
                      ),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        chosenFilterType = newValue;
                      });
                    },
                    items: filterTypeOptionList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    controller: _fromDateController,
                    readOnly: true,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'From Date',
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          String day = value.day.toString();
                          String month = value.month.toString();
                          String year = value.year.toString();
                          String date = '${day}-${month}-${year}';

                          _fromDateController.text = date;

                          setState(() {
                            fromDate = value;
                            _fromDateController.text = date;
                          });
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    controller: _toDateController,
                    readOnly: true,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'To Date',
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          String day = value.day.toString();
                          String month = value.month.toString();
                          String year = value.year.toString();
                          String date = '${day}-${month}-${year}';
                          toDate = value;
                          // // _toDateController.text = date;
                          // print(_fromDateController.text);
                          // print(date);
                          // // if()
                          // // print(date.compareTo(_fromDateController.text));
                          if (value.compareTo(fromDate) >= 0) {
                            setState(() {
                              _toDateController.text = date;
                            });
                          } else {
                            setState(() {
                              _toDateController.text = '';
                            });
                          }
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 10, bottom: 5, top: 5),
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.buttonColor,
                      ),
                      // width: 100,
                      // height: 30,
                      child: FlatButton(
                        color: colors.buttonColor,
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: Fonts.button_size,
                            fontFamily: Fonts.default_font,
                            color: colors.buttonTextColor,
                          ),
                        ),
                        onPressed: () async {
                          DateTime fromDateTemp = fromDate;
                          DateTime toDateTemp = toDate;

                          if (chosenFilterType != null &&
                              (_fromDateController.text != null ||
                                  _fromDateController.text != '') &&
                              (_toDateController.text != null ||
                                  _toDateController.text != '')) {
                            String type;
                            if (chosenFilterType == 'Daily') {
                              type = 'Date';

                              fromDateTemp = new DateTime(fromDate.year,
                                  fromDate.month, fromDate.day, 0, 0, 0, 0, 0);
                              toDateTemp = new DateTime(toDate.year,
                                  toDate.month, toDate.day, 0, 0, 0, 0, 0);
                            } else if (chosenFilterType == 'Monthly') {
                              type = 'Month';
                              fromDateTemp = new DateTime(fromDate.year,
                                  fromDate.month, 1, 0, 0, 0, 0, 0);
                              toDateTemp = new DateTime(
                                  toDate.year, toDate.month, 1, 0, 0, 0, 0, 0);
                            } else {
                              type = 'Year';
                              fromDateTemp = new DateTime(
                                  fromDate.year, 1, 1, 0, 0, 0, 0, 0);
                              toDateTemp = new DateTime(
                                  toDate.year, 1, 1, 0, 0, 0, 0, 0);
                            }
                            Stream<QuerySnapshot> querySnapshot1;
                            await uiController
                                .getFilteredOrdersSnapshot(
                                    type, fromDateTemp, toDateTemp)
                                .then((value) {
                              querySnapshot1 = value;
                            });
                            print(querySnapshot1);
                            Navigator.of(context, rootNavigator: true).pop();
                            setState(() {
                              querySnapshot = querySnapshot1;
                            });
                            print(querySnapshot == querySnapshot1);
                            _counter.value = querySnapshot1;
                          } else {
                            setState(() {
                              displayAlertMsg = true;
                            });
                          }
                          // Navigator.pop(context);
                          // FutureBuilder<bool>(
                          //   builder: (context, snapshot) {
                          //     return Container();
                          //   },
                          //   future: _nominateSelectedItems(context),
                          // );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        )).show();
  }

  Widget getTextWidget(var data) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          data,
          style: TextStyle(
            fontSize: Fonts.heading1_size,
            fontFamily: Fonts.default_font,
          ),
        ),
      ),
    );
  }

  Widget getSalesAppBar() {
    return AppBar(
      backgroundColor: colors.buttonColor,
      title: Text(
        'Digi Café Admin',
        style: TextStyle(
          fontFamily: Fonts.default_font,
          fontSize: Fonts.label_size,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0, right: 20),
          child: InkWell(
            child: Text(
              'Filter',
              style: TextStyle(
                fontFamily: Fonts.default_font,
                fontSize: Fonts.label_size,
              ),
            ),
            onTap: () {
              createFilterAlert(context);
            },
          ),
        ),
      ],
    );
  }
}

String getAlphabeticalMonth(int month, int year) {
  if (month != null) {
    // var lst = docID.split('-');
    var months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month] + ', ' + year.toString();
  }
  return '';
}

class SaleItemWidget extends StatefulWidget {
  String date;
  String total;
  String orders;
  SaleItemWidget({
    @required this.date,
    @required this.total,
    @required this.orders,
  });
  @override
  _SaleItemWidgetState createState() => _SaleItemWidgetState();
}

class _SaleItemWidgetState extends State<SaleItemWidget> {
  OrderUIController _OrderUIController;
  // int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _rowsPerPage = 5;

  List<SalesViewItems> nominateItems;
  BuildContext _buildContext;

  @override
  void initState() {
    _OrderUIController = new OrderUIController();
  }

  @override
  Widget build(BuildContext context) {
    this._buildContext = context;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: InkWell(
              child: Column(
                children: <Widget>[
                  // ye table hai
                  // Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Text(
                  //     "TOTAL SALES",
                  //     // textScaleFactor: 2.0,
                  //     style: TextStyle(
                  //       fontSize: Fonts.heading1_size,
                  //       fontFamily: Fonts.default_font,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Table(
                  //     border: TableBorder.all(
                  //         width: 1.5, color: colors.buttonColor),
                  //     children: [
                  //       TableRow(children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(),
                  //           child: Text(
                  //             "Date",
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: Fonts.heading2_size,
                  //               fontFamily: Fonts.default_font,
                  //             ),
                  //           ),
                  //         ),
                  //         Text(
                  //           "Orders",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: Fonts.heading2_size,
                  //             fontFamily: Fonts.default_font,
                  //           ),
                  //         ),
                  //         Text(
                  //           "Sale",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: Fonts.heading2_size,
                  //             fontFamily: Fonts.default_font,
                  //           ),
                  //         ),
                  //       ]),
                  //       TableRow(children: [
                  //         Text(
                  //           widget.date,
                  //           style: TextStyle(
                  //             fontFamily: Fonts.default_font,
                  //             fontSize: Fonts.heading2_XL_size,
                  //             // fontWeight: FontWeight.bold,
                  //           ),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         // Spacer(flex: 2),
                  //         Text(
                  //           widget.orders,
                  //           style: TextStyle(
                  //             fontFamily: Fonts.default_font,
                  //             fontSize: Fonts.heading2_XL_size,
                  //           ),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         // Spacer(flex: 2),
                  //         Text(
                  //           widget.total,
                  //           style: TextStyle(
                  //             fontFamily: Fonts.default_font,
                  //             fontSize: Fonts.heading2_XL_size,
                  //           ),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         //Spacer(flex: 2),
                  //       ]),
                  //     ],
                  //   ),
                  // )
                ],
                //   ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, var _message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: colors.buttonColor,
        content: Text(
          '$_message',
          style: TextStyle(
            color: colors.textColor,
            fontFamily: Fonts.default_font,
            fontSize: Fonts.appBarTitle_size,
          ),
        ),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

//idr se paginated shuru ho gya
////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'Date',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Orders',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
    numeric: true,
  ),
  DataColumn(
    label: Text(
      'Total Sale',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
    numeric: true,
  ),
];

////// Data class.
class SalesViewItems {
  SalesViewItems(this.date, this.orders, this.total);
  var date;
  var orders;
  var total;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class NominateItemsDataSource extends DataTableSource {
  NominateItemsDataSource(List<SalesViewItems> nominate) {
    nominateItems = nominate;
  }
  int _selectedCount = 0;
  List<SalesViewItems> nominateItems;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= nominateItems.length) return null;

    final SalesViewItems _nominateItems = nominateItems[index];
    return DataRow.byIndex(
        index: index,
        color: MaterialStateColor.resolveWith((states) {
          if (index.isEven) {
            return Colors.orange[50];
          } else {
            return Colors.transparent;
          }
        }),
        cells: <DataCell>[
          DataCell(
            Container(
              constraints: BoxConstraints(minWidth: 50, maxWidth: 100),
              child: Text(
                _nominateItems.date,
                style: TextStyle(
                  fontSize: Fonts.heading3_size,
                  fontFamily: Fonts.default_font,
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(minWidth: 35, maxWidth: 60),
              child: Text(
                _nominateItems.orders.toString(),
                style: TextStyle(
                  fontSize: Fonts.heading3_size,
                  fontFamily: Fonts.default_font,
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(minWidth: 70, maxWidth: 100),
              child: Text(
                _nominateItems.total.toString(),
                style: TextStyle(
                  fontSize: Fonts.heading3_size,
                  fontFamily: Fonts.default_font,
                ),
              ),
            ),
          ),
        ]);
  }

  @override
  int get rowCount {
    return nominateItems.length;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
