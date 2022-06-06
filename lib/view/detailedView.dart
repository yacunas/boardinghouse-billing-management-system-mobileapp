import 'dart:async';
import 'package:flutter/material.dart';
import 'package:billing_management/model/occupant.dart';
import 'package:billing_management/utils/databaseHelper.dart';
import 'package:intl/intl.dart';

class DetailedView extends StatefulWidget {
  final String appBarTitle;
  final Occupant occupant;

  DetailedView(this.occupant, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return DetailedViewState(this.occupant, this.appBarTitle);
  }
}

class DetailedViewState extends State<DetailedView> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  String appBarTitle;
  Occupant occupant;

  String _lastName;
  String _firstName;
  String _address;
  int _contactNumber;
  int _roomNumber;
  double _ratePerPeriod;
  String _remarks;
  String _reservationDate;
  String _dueDate;

  DateTime selectedDate = DateTime.now();

  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController ratePerPeriodController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DetailedViewState(this.occupant, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    lastNameController.text = occupant.lastName;
    firstNameController.text = occupant.firstName;
    addressController.text = occupant.address;
    contactNumberController.text = occupant.contactNumber.toString();
    roomNumberController.text = occupant.roomNumber.toString();
    ratePerPeriodController.text = occupant.ratePerPeriod.toString();
    remarksController.text = occupant.remarks;
    _reservationDate = occupant.reservationDate;
    _dueDate = occupant.dueDate;

    //TextStyle textStyle = Theme.of(context).textTheme.headline1;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(appBarTitle),
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(child: _buildLastName()),
                                  SizedBox(width: 20.0),
                                  Flexible(child: _buildFirstName())
                                ],
                              ),
                              _buildAddress(),
                              _buildContactNumber(),
                              Row(
                                children: [
                                  Flexible(child: _buildRoomNumber()),
                                  SizedBox(width: 20.0),
                                  Flexible(child: _buildRatePerPeriod()),
                                ],
                              ),
                              _buildRemarks(),
                              _buildDueDate(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RaisedButton(
                            child: Text(
                              'Update Information',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                              _showAlertDialog(context);
                              _update();
                              print('Last Name: ' + occupant.lastName);
                              print('First Name: ' + occupant.firstName);
                              print('Address Name: ' + occupant.address);
                              print('Contact Number: ' +
                                  occupant.contactNumber.toString());
                              print('Room Number: ' +
                                  occupant.roomNumber.toString());
                              print('Rate per Period: ' +
                                  occupant.ratePerPeriod.toString());
                              //print('Date in: ' + _dateIn);
                              print('Remarks: ' + occupant.remarks);
                              //showAlertDialog(context);

                              moveToLastScreen();
                            },
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Color colors() {
  //   if (appBarTitle == 'Edit Occupant') {
  //     return Colors.orange;
  //   } else if (appBarTitle == 'Remove Occupant') {
  //     return Colors.red;
  //   }
  // }

  // Update the title of Note object
  Widget _buildLastName() {
    return TextFormField(
      controller: lastNameController,
      decoration: InputDecoration(labelText: 'Last Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Lastname is Required';
        }
      },
      onSaved: (String value) {
        _lastName = value;
        occupant.lastName = _lastName;
      },
    );
  }

  Widget _buildFirstName() {
    return TextFormField(
      controller: firstNameController,
      decoration: InputDecoration(labelText: 'First Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Firstname is Required';
        }
      },
      onSaved: (String value) {
        _firstName = value;
        occupant.firstName = _firstName;
      },
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      controller: addressController,
      decoration: InputDecoration(labelText: 'Address'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is Required';
        }
      },
      onSaved: (String value) {
        _address = value;
        occupant.address = _address;
      },
    );
  }

  Widget _buildContactNumber() {
    return TextFormField(
      controller: contactNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Contact Number'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Contact Number is Required';
        }
        if (value.length != 11 && value.length != 10) {
          return 'Invalid Contact Number';
        }
      },
      onSaved: (String value) {
        _contactNumber = int.parse(value);
        occupant.contactNumber = _contactNumber;
      },
    );
  }

  Widget _buildRoomNumber() {
    return TextFormField(
      controller: roomNumberController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Room Number'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Room Number';
        }
      },
      onSaved: (String value) {
        _roomNumber = int.parse(value);
        occupant.roomNumber = _roomNumber;
      },
    );
  }

  Widget _buildRatePerPeriod() {
    return TextFormField(
      controller: ratePerPeriodController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Rate per Period'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Rate (Must be in PHP)';
        }
      },
      onSaved: (String value) {
        _ratePerPeriod = double.parse(value);
        occupant.ratePerPeriod = _ratePerPeriod;
      },
    );
  }

  Widget _buildRemarks() {
    return TextFormField(
      controller: remarksController,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      maxLength: 50,
      decoration: InputDecoration(labelText: 'Remarks'),
      onSaved: (String value) {
        _remarks = value;
        occupant.remarks = _remarks;
      },
    );
  }

  Widget _buildDueDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reservation Date: $_reservationDate'),
        SizedBox(height: 15.0),
        Row(
          children: [
            Text('Due Date: $_dueDate'),
            SizedBox(width: 25.0),
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 13),
                ),
                color: Colors.white,
                onPressed: () async {
                  _selectDate(context);
                })
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(this.occupant.dueDate),
      firstDate: new DateTime.now().subtract(Duration(days: 365 * 2)),
      lastDate: new DateTime.now().add(Duration(days: 365 * 2)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dueDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate);
        occupant.dueDate = _dueDate;
      });
  }

  // Save data to database
  void _update() async {
    int result;
    result = await databaseHelper.update(occupant);
    print(result);
  }

  _showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alertDialog = AlertDialog(
      title: Text("Payment Successful!"),
      content: Text('Due date updated.'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
