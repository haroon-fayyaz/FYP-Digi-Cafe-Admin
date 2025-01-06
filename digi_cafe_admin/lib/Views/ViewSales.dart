import 'package:connectivity_widget/connectivity_widget.dart';
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
import 'MyWidgets.dart';
import 'NoIternetScreen.dart';

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

  TextFormDate fromDateWidget;
  TextFormDate toDateWidget;
  CreateFormFieldDropDown filterType;

  var _alertMessage = 'Incomplete Fields';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    uiController = new OrderUIController();
    // querySnapshot = uiController.getOrdersSnapshot();
    _counter.value = uiController.getOrdersSnapshot();
    _totalOrdersAmount.value = "0";
    _totalOrderss.value = "0";
    fromDateWidget = new TextFormDate(
      label: 'From Date',
    );
    toDateWidget = new TextFormDate(
      label: 'To Date',
    );
    filterType = new CreateFormFieldDropDown(
      dropDownList: <String>['Daily', 'Monthly', 'Yearly'],
      icon: Icons.filter_list,
      title: 'Filter Type',
    );
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: ViewSales())
          : Scaffold(
              appBar: getSalesAppBar(context),
              bottomNavigationBar: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                    child: ValueListenableBuilder(
                        builder: (BuildContext context, String totalOrderss,
                            Widget child) {
                          return MyWidgets.getTextWidget(
                              text: totalOrderss,
                              weight: FontWeight.bold,
                              size: Fonts.heading3_size - 1,
                              overflow: TextOverflow.ellipsis);
                        },
                        valueListenable: _totalOrderss),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: ValueListenableBuilder(
                        builder: (BuildContext context, String totalOAmount,
                            Widget child) {
                          return MyWidgets.getTextWidget(
                              text: totalOAmount,
                              weight: FontWeight.bold,
                              size: Fonts.heading3_size - 1,
                              overflow: TextOverflow.ellipsis);
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
                                    Stream<QuerySnapshot> querySnapshot,
                                    Widget child) {
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: querySnapshot,
                                    builder: (context, snapshot) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _totalOrdersAmount.value = totalAmount;
                                        _totalOrderss.value = totalOrders;
                                      });
                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        if (snapshot.hasData) {
                                          List<SalesViewItems> listItems =
                                              new List();
                                          double amount = 0, orders = 0;
                                          for (int count = 0;
                                              count <
                                                  snapshot
                                                      .data.documents.length;
                                              count++) {
                                            DocumentSnapshot element =
                                                snapshot.data.documents[count];
                                            String docID = element.documentID;
                                            if (filterType.chosenType ==
                                                'Monthly') {
                                              DateTime date =
                                                  element.data['date'].toDate();

                                              docID = getAlphabeticalMonth(
                                                  date.month - 1, date.year);
                                            }
                                            SalesViewItems items =
                                                new SalesViewItems(
                                                    docID,
                                                    // element.data['date'],
                                                    element.data['totalOrders']
                                                        .toString(),
                                                    element
                                                        .data['totalAmount']);
                                            if (items.orders != null) {
                                              orders += double.parse(
                                                  items.orders.toString());
                                            }
                                            if (items.total != null) {
                                              amount += double.parse(
                                                  items.total.toString());
                                            }
                                            listItems.add(items);
                                          }

                                          print(totalAmount);
                                          totalOrders = 'Total Orders: ' +
                                              orders.toInt().toString();
                                          totalAmount = 'Total Amount: ' +
                                              amount.toStringAsFixed(1);

                                          _ds = new NominateItemsDataSource(
                                              listItems);

                                          return listItems.length == 0
                                              ? ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      minHeight:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height),
                                                  child: Center(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.75,
                                                      child: Lottie.asset(
                                                        'assets/no_data_found.json',
                                                        controller: _controller,
                                                        onLoaded:
                                                            (composition) {
                                                          // Configure the AnimationController with the duration of the
                                                          // Lottie file and start the animation.
                                                          _controller
                                                            ..duration =
                                                                composition
                                                                    .duration
                                                            ..forward();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SingleChildScrollView(
                                                  child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            dividerColor: colors
                                                                .buttonColor),
                                                    child: PaginatedDataTable(
                                                      header: Container(),
                                                      dataRowHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.7 /
                                                              _rowsPerPage,
                                                      rowsPerPage: _rowsPerPage,
                                                      availableRowsPerPage: <
                                                          int>[5, 10, 20],
                                                      onRowsPerPageChanged:
                                                          (int value) {
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
                                      } else
                                        return LoadingWidget();
                                    },
                                  );
                                },
                                valueListenable: _counter,
                                child: const Text('Good job!'),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void createFilterAlert(context) async {
    fromDateWidget.date = null;
    toDateWidget.date = null;
    displayAlertMsg = false;

    Alert(
        context: context,
        style: MyWidgets.getAlertStyle(),
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
                        child: MyWidgets.getTextWidget(
                            weight: FontWeight.bold,
                            size: Fonts.dialog_heading_size,
                            text: _alertMessage,
                            color: colors.warningColor),
                      )
                    : Container(),
                //Filter Type
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: filterType,
                ),
                //From Date
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: fromDateWidget,
                ),
                // toDtate,
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: toDateWidget,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 10, bottom: 5, top: 5),
                  child: MyWidgets.getButton(
                      text: 'Apply',
                      onTap: () async {
                        fromDate = fromDateWidget.date;
                        toDate = toDateWidget.date;

                        DateTime fromDateTemp = fromDate;
                        DateTime toDateTemp = toDate;

                        if (filterType.chosenType != null &&
                            (fromDate != null) &&
                            (toDate != null)) {
                          if (toDate.compareTo(fromDate) >= 0) {
                          } else {
                            setState(() {
                              displayAlertMsg = true;
                              _alertMessage =
                                  'To date must be greater than or equal to From Date';
                            });
                            return;
                          }
                          String type;
                          if (filterType.chosenType == 'Daily') {
                            type = 'Date';

                            fromDateTemp = new DateTime(fromDate.year,
                                fromDate.month, fromDate.day, 0, 0, 0, 0, 0);
                            toDateTemp = new DateTime(toDate.year, toDate.month,
                                toDate.day, 0, 0, 0, 0, 0);
                          } else if (filterType.chosenType == 'Monthly') {
                            type = 'Month';
                            fromDateTemp = new DateTime(fromDate.year,
                                fromDate.month, 1, 0, 0, 0, 0, 0);
                            toDateTemp = new DateTime(
                                toDate.year, toDate.month, 1, 0, 0, 0, 0, 0);
                          } else {
                            type = 'Year';
                            fromDateTemp = new DateTime(
                                fromDate.year, 1, 1, 0, 0, 0, 0, 0);
                            toDateTemp =
                                new DateTime(toDate.year, 1, 1, 0, 0, 0, 0, 0);
                          }
                          Stream<QuerySnapshot> querySnapshot1;
                          await uiController
                              .getFilteredOrdersSnapshot(
                                  type, fromDateTemp, toDateTemp)
                              .then((value) {
                            querySnapshot1 = value;
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          setState(() {
                            querySnapshot = querySnapshot1;
                          });
                          _counter.value = querySnapshot1;
                        } else {
                          setState(() {
                            _alertMessage = 'Incomplete Fields';
                            displayAlertMsg = true;
                          });
                        }
                      }),
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
        child: MyWidgets.getTextWidget(text: data, size: Fonts.heading1_size),
      ),
    );
  }

  Widget getSalesAppBar(context) {
    return MyWidgets.getFilterAppBar(
        context: context,
        text: 'View Sales',
        child: Icons.filter_list,
        onTap: () => createFilterAlert(context));
  }
}

void func(value) {}

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
              child: MyWidgets.getTextWidget(
                  text: _nominateItems.date, size: Fonts.heading3_size),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(minWidth: 35, maxWidth: 60),
              child: MyWidgets.getTextWidget(
                  text: _nominateItems.orders.toString(),
                  size: Fonts.heading3_size),
            ),
          ),
          DataCell(
            Container(
              constraints: BoxConstraints(minWidth: 70, maxWidth: 100),
              child: MyWidgets.getTextWidget(
                  text: _nominateItems.total.toString(),
                  size: Fonts.heading3_size),
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
