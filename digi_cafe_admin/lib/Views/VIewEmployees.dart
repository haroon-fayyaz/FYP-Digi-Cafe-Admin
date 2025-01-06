import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/Views/DialogInstruction.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:digi_cafe_admin/Model/Cafe Employee.dart';
import 'package:digi_cafe_admin/Views/AddEmployee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'LoadingWidget.dart';
import 'NoIternetScreen.dart';

class ViewEmployees extends StatelessWidget {
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
                'Single tap to update employee\ndata'),
            DialogInstruction.getInstructionRow(
                'Long Press to delete employee\ndata'),
          ],
        )).show();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implaement build
    return ConnectivityWidget(
        builder: (context, isOnline) => !isOnline
            ? NoInternetScreen(screen: ViewEmployees())
            : Scaffold(
                appBar: MyWidgets.getFilterAppBar(
                    context: context, text: 'View Employees'),
                body: _ViewEmployees(),
                floatingActionButton: SpeedDial(
                    animatedIcon: AnimatedIcons.menu_close,
                    animatedIconTheme: IconThemeData(size: 20),
                    backgroundColor: colors.buttonColor,
                    children: [
                      MyWidgets.getSpeedDialChild(
                        icon: Icons.fastfood,
                        text: 'Add Employee',
                        callback: () {
                          MyWidgets.changeScreen(
                              context: context, screen: AddEmployeeScreen());
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
              ));
  }
}

class _ViewEmployees extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return __ViewEmployees();
  }
}

class __ViewEmployees extends State<_ViewEmployees> {
  EmployeeUIController uiController;
  List<CafeEmployee> employees;
  BuildContext _buildContext;
  Stream<QuerySnapshot> querySnapshot;
  int count = 0;
  @override
  void initState() {
    uiController = new EmployeeUIController();
    querySnapshot = uiController.getEmployeeSnapshot();
  }

  Widget build(BuildContext context) {
    _buildContext = context;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (count == 0) {
      //   await MyWidgets.internetStatus(context).then((value) {});
      //   count++;
      // }
    });
    return ConnectivityWidget(
      builder: (context, isOnline) => !isOnline
          ? NoInternetScreen(screen: ViewEmployees())
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
                          return !snapshot.hasData
                              ? LoadingWidget()
                              : ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot element =
                                        snapshot.data.documents[index];
                                    CafeEmployee employee = new CafeEmployee(
                                        element.data["Name"],
                                        element.data["email"],
                                        element.data["gender"],
                                        element.data["DOB"],
                                        "",
                                        element.data["phoneNo"],
                                        element.data["PType"],
                                        element.data['imgURL']);
                                    // print('${element.data['imgURL']}');
                                    employee.id = element.documentID;
                                    return GestureDetector(
                                      onTap: () {
                                        MyWidgets.changeScreen(
                                            context: context,
                                            screen: AddEmployeeScreen(
                                                employee: employee,
                                                actionType: "update"));
                                      },
                                      onLongPress: () {
                                        //Delete Employee
                                        MyWidgets.showConfirmationDialog(
                                            context,
                                            text:
                                                'Do you want to remove Employee?',
                                            callback: () async {
                                          bool result = await uiController
                                              .deleteEmployee(employee.id);

                                          if (result.toString() == "true") {
                                            _showToast(_buildContext,
                                                "Employee deleted successfully");
                                          } else {
                                            _showToast(_buildContext,
                                                "Employee delete unsuccessful");
                                          }
                                        });
                                      },
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10,
                                        ),
                                        child: Card(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(10.0),
                                                height: 80.0,
                                                width: 80.0,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: employee.imgURL ==
                                                            null
                                                        ? Image.asset(
                                                            'images/profile_pic.png')
                                                        : Image.network(
                                                            employee.imgURL, fit: BoxFit.cover,)),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      child: MyWidgets
                                                          .getTextWidget(
                                                              text:
                                                                  employee.Name,
                                                              size: Fonts
                                                                  .cardTitle_size,
                                                              weight: FontWeight
                                                                  .w500)),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      child: MyWidgets
                                                          .getTextWidget(
                                                        text: employee.userType,
                                                        size:
                                                            Fonts.heading3_size,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                        } else
                          return LoadingWidget();
                      }),
                ),
              ],
            ),
    );
  }

  void _showToast(BuildContext context, var _message) {
    MyWidgets.showToast(context, _message);
  }
}
