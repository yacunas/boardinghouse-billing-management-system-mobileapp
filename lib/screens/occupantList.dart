import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:billing_management/view/detailedView.dart';
import 'package:billing_management/utils/databaseHelper.dart';
import 'package:billing_management/model/occupant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../view/addOccupantPage.dart';
import '../view/billingHistory.dart';

class OccupantList extends StatefulWidget {
  @override
  OccupantListState createState() => OccupantListState();
}

class OccupantListState extends State<OccupantList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Occupant> occupantList;
  int count = 0;
  String appBarTitle;

  final SlidableController slidableController = SlidableController();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    if (occupantList == null) {
      occupantList = List<Occupant>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Occupants',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
          key: _refreshKey,
          child: occupantList.isNotEmpty
              ? getOccupantListView()
              : Center(
                  child: Text('No Current Occupants',
                      style: TextStyle(color: Colors.grey))),
          onRefresh: () async {
            await refreshList();
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddOccupant()))
              .then((value) => _refreshKey.currentState.show());
        },
        icon: Icon(Icons.person_add, color: Colors.white),
        label: Text('Occupant', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<Null> refreshList() async {
    print('Refreshing..');
    _refreshKey.currentState.show();
    await Future.delayed(Duration(seconds: 2));
    occupantList = List<Occupant>();
    updateListView();

    return null;
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Occupant>> occupantListFuture =
          databaseHelper.getOccupantList();
      occupantListFuture.then((occupantList) {
        setState(() {
          this.occupantList = occupantList;
          this.count = occupantList.length;
        });
      });
    });
  }

  void navigateToDetail(Occupant occupant, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailedView(occupant, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void _delete(Occupant occupant) async {
    int result = await databaseHelper.delete(occupant.occupantID);
    await databaseHelper.deletePayment(occupant.occupantID);
    if (result != 0) {
      // _showSnackBar(context, 'Note Deleted Successfully');

      print('Successfully Deleted');
      updateListView();
    }
  }

  _showAlertDialog(BuildContext context, position) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Proceed"),
      onPressed: () {
        _delete(occupantList[position]);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
          "Are you sure you want to remove \n${this.occupantList[position].firstName} ${this.occupantList[position].lastName}?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ListView getOccupantListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Padding(
          padding: EdgeInsets.fromLTRB(2, 3, 2, 5),
          child: Card(
            elevation: 2.0,
            child: Slidable(
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.green,
                  icon: Icons.edit,
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    navigateToDetail(
                        this.occupantList[position], 'Edit Occupant');
                  },
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    print('delete tapped');
                    _showAlertDialog(context, position);
                  },
                ),
              ],
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OccupantHistory(this.occupantList[position])),
                  );
                },
                child: Container(
                  height: 110.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                              this
                                  .occupantList[position]
                                  .firstName
                                  .substring(0, 1),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              )),
                        ),
                        SizedBox(width: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${this.occupantList[position].firstName} ${this.occupantList[position].lastName}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                  'Room ' +
                                      this
                                          .occupantList[position]
                                          .roomNumber
                                          .toString(),
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                  'Rate: ' +
                                      this
                                          .occupantList[position]
                                          .ratePerPeriod
                                          .toString(),
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                'Address: ' +
                                    this
                                        .occupantList[position]
                                        .address
                                        .toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                  'Contact Number: ' +
                                      this
                                          .occupantList[position]
                                          .contactNumber
                                          .toString(),
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              key: ObjectKey(position),
            ),
          ),
        );
      },
    );
  }
}
