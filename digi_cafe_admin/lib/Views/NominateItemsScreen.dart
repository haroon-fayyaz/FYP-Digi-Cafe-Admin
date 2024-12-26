import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:intl/intl.dart';

import 'NoIternetScreen.dart';

_NominateItemsState state;

class NominateItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      // backgroundColor: colors.backgroundColor,
      child: NominateItemsState(),
    );
  }
}

class NominateItemsState extends StatefulWidget {
  const NominateItemsState({Key key}) : super(key: key);

  @override
  _NominateItemsState createState() {
    state = _NominateItemsState();
    return state;
  }
}

class _NominateItemsState extends State<NominateItemsState> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  List<NominateItems> nominateItems;

  FoodMenuUIController _foodMenuUIController;
  NominateItemsDataSource _ds;
  Stream<QuerySnapshot> querySnapshot;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _buildContext;
  var _displayLoadingWidget = false;
  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
    querySnapshot = _foodMenuUIController.getFoodMenuSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: NominateItemsScreen())
          : Scaffold(
              key: _scaffoldKey,
              appBar: MyWidgets.getAppBar(text: 'Nominate Items'),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.only(left: 120, right: 120, bottom: 5),
                child: MyWidgets.getButton(
                    text: 'Nominate Items',
                    height: 35,
                    onTap: () {
                      FutureBuilder<bool>(
                        builder: (context, snapshot) {
                          if (snapshot.hasData) if (snapshot.data) {}
                          // _showToast(context, 'Items Nom')
                          return LoadingWidget();
                        },
                        future: _nominateSelectedItems(context),
                      );
                    }),
              ),
              body: SafeArea(
                child: Stack(children: [
                  if (_displayLoadingWidget)
                    LoadingWidget()
                  else
                    StreamBuilder<QuerySnapshot>(
                        stream: querySnapshot,
                        builder: (context, snapshot) {
                          int count = 0;

                          if (snapshot.hasData) {
                            List<NominateItems> listItems = new List();
                            for (int count = 0;
                                count < snapshot.data.documents.length;
                                count++) {
                              DocumentSnapshot dish =
                                  snapshot.data.documents[count];
                              NominateItems items = new NominateItems(
                                  dish.documentID,
                                  dish.data['name'],
                                  dish.data['price'].toDouble(),
                                  dish.data['stockLeft'].toDouble(),
                                  dish.data['isNominated']);
                              listItems.add(items);
                            }
                            for (int i = 0; i < listItems.length; i++) {
                              if (listItems[i].selected == true) {
                                count += 1;
                              }
                            }
                            _ds = new NominateItemsDataSource(listItems, count);
                            // return Container(
                            //   color: colors.backgroundColor,
                            // );
                            _ds.notifyListeners();

                            return SingleChildScrollView(
                              child: Theme(
                                data: ThemeData(
                                  dividerColor: colors.buttonColor,
                                  colorScheme: ColorScheme.fromSwatch(
                                    brightness: Brightness.light,
                                  ),
                                ),
                                // Theme.of(context).copyWith(
                                //   // cardColor: colors.buttonColor,
                                //   cursorColor: colors.buttonColor,
                                //   dividerColor: colors.buttonColor,
                                //   // selectedRowColor: colors.buttonColor,
                                // ),
                                child: PaginatedDataTable(
                                  header: Container(
                                    color: colors.backgroundColor,
                                  ),
                                  dataRowHeight:
                                      MediaQuery.of(context).size.height *
                                          0.7 /
                                          _rowsPerPage,
                                  rowsPerPage: _rowsPerPage,
                                  availableRowsPerPage: <int>[5, 10, 20],
                                  onRowsPerPageChanged: (int value) {
                                    setState(() {
                                      _rowsPerPage = value;
                                    });
                                  },
                                  columns: kTableColumns,
                                  source: _ds,
                                ),
                              ),
                            );
                          } else {
                            return LoadingWidget();
                          }
                        }),
                ]),
              ),
            ),
    );

    // _rowsPerPage = _rowsPerPage > _ds.nominateItems.length
    //     ? _ds.nominateItems.length
    //     : _rowsPerPage
  }

  Future<bool> _nominateSelectedItems(context) async {
    setState(() {
      _displayLoadingWidget = true;
    });
    List<String> _itemsSelected = new List();
    for (int i = 0; i < _ds.nominateItems.length; i++) {
      if (_ds.nominateItems[i].selected) {
        _itemsSelected.add(_ds.nominateItems[i].itemID);
      }
    }
    if (_itemsSelected.length >= 0) {
      bool result =
          await _foodMenuUIController.addNominatedItems(_itemsSelected);
      setState(() {
        _displayLoadingWidget = false;
      });
      if (result) {
        MyWidgets.showToast(context, "Items nominated successfully");
      }
    }
    setState(() {
      _displayLoadingWidget = false;
    });

    return Future.value(true);
  }
}

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'Item Name',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Price',
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
      'Stock',
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
class NominateItems {
  NominateItems(
      this.itemID, this.itemName, this.price, this.quantity, this.selected);
  var itemID;
  final String itemName;
  final double quantity;
  final double price;
  bool selected;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class NominateItemsDataSource extends DataTableSource {
  NominateItemsDataSource(List<NominateItems> nominate, int count) {
    nominateItems = nominate;
    _selectedCount = count;
  }
  int _selectedCount;
  List<NominateItems> nominateItems;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= nominateItems.length) return null;

    final NominateItems _nominateItems = nominateItems[index];
    return DataRow.byIndex(
        index: index,
        color: MaterialStateColor.resolveWith((states) {
          if (index.isEven) {
            return Colors.orange[50];
          } else {
            return Colors.transparent;
          }
        }),
        selected: _nominateItems.selected,
        onSelectChanged: (bool value) {
          // allow only 4 selections
          // if (_selectedCount > 3 && value) {
          //   print('Selection limit reached');
          //   return;
          // }
          if (_nominateItems.selected != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            _nominateItems.selected = value;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(
            MyWidgets.getTextWidget(
                text: _nominateItems.itemName, size: Fonts.heading3_size),
          ),
          DataCell(
            MyWidgets.getTextWidget(
                text: _nominateItems.price.toStringAsFixed(1),
                size: Fonts.heading3_size),
          ),
          DataCell(
            MyWidgets.getTextWidget(
                text: _nominateItems.quantity.toStringAsFixed(1),
                size: Fonts.heading3_size),
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
