import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:billing_management/model/occupant.dart';
import 'package:billing_management/utils/databaseHelper.dart';

class AddOccupant extends StatefulWidget {
  @override
  _AddOccupantState createState() => _AddOccupantState();
}

class _AddOccupantState extends State<AddOccupant> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  FlutterLocalNotificationsPlugin fltrNotification;

  String appBarTitle;
  Occupant occupant = new Occupant('', '', '', 0, 0, '', '', 0, '');

  String _lastName;
  String _firstName;
  String _address;
  int _contactNumber;
  int _roomNumber;
  String _reservationDate;
  String _dueDate;
  double _ratePerPeriod;
  String _remarks;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings);
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "", "Billing Management System", "Billing",
        importance: Importance.Max);
    var iOSinitilize = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iOSinitilize);

    // await fltrNotification.show(
    //     0, "Task", "You created a Task", generalNotificationDetails,
    //     payload: "Task");

    String payload = "$_firstName $_lastName is due today";
    var scheduledTime = DateTime.now().add(Duration(seconds: 3));
    fltrNotification.schedule(_roomNumber, "Duedate", "$payload", scheduledTime,
        generalNotificationDetails,
        payload: "$payload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              Flexible(child: _buildFirstName()),
                              SizedBox(width: 20.0),
                              Flexible(child: _buildLastName())
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
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Reserve',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();
                        _getDateIn();
                        _save();
                        _formKey.currentState.reset();
                        print('Last Name: ' + _lastName);
                        print('First Name: ' + _firstName);
                        print('Address Name: ' + _address);
                        print('Contact Number: ' + _contactNumber.toString());
                        print('Room Number: ' + _roomNumber.toString());
                        print('Rate per Period: ' + _ratePerPeriod.toString());
                        print('Date in: ' + _reservationDate);
                        print('Remarks: ' + _remarks);

                        _showAlertDialog(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Lastname is Required';
        }
      },
      onSaved: (String value) {
        _lastName = value;
        this.occupant.lastName = _lastName;
      },
    );
  }

  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'First Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Firstname is Required';
        }
      },
      onSaved: (String value) {
        _firstName = value;
        this.occupant.firstName = _firstName;
      },
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Address'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is Required';
        }
      },
      onSaved: (String value) {
        _address = value;
        this.occupant.address = _address;
      },
    );
  }

  Widget _buildContactNumber() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Contact Number'),
      validator: (String value) {
        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        RegExp regExp = new RegExp(pattern);
        if (value.isEmpty) {
          return 'Contact Number is Required';
        }
        if (value.length != 11 && value.length != 10) {
          return 'Invalid Contact Number';
        }
        if (!regExp.hasMatch(value)) {
          return 'Invalid Contact Number';
        }
      },
      onSaved: (String value) {
        _contactNumber = int.parse(value);
        this.occupant.contactNumber = _contactNumber;
      },
    );
  }

  Widget _buildRoomNumber() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Room Number'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Room Number';
        }
        if (int.parse(value) <= 0) {
          return 'Invalid Contact Number';
        }
      },
      onSaved: (String value) {
        _roomNumber = int.parse(value);
        this.occupant.roomNumber = _roomNumber;
      },
    );
  }

  void _getDateIn() {
    final now = new DateTime.now();

    _reservationDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    this.occupant.reservationDate = _reservationDate;

    _dueDate =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(now.add(Duration(days: 30)));
    this.occupant.dueDate = _dueDate;
  }

  Widget _buildRatePerPeriod() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Rate per Period'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Rate (Must be in PHP)';
        }
      },
      onSaved: (String value) {
        _ratePerPeriod = double.parse(value);
        this.occupant.ratePerPeriod = _ratePerPeriod;
      },
    );
  }

  Widget _buildRemarks() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      maxLength: 50,
      decoration: InputDecoration(labelText: 'Remarks'),
      onSaved: (String value) {
        _remarks = value;
        this.occupant.remarks = _remarks;
      },
    );
  }

  void _save() async {
    await databaseHelper.insert(this.occupant);
    await _showNotification();
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
      title: Text("Reserved!"),
      content: Text('''Successfully added. 
      Date in: $_reservationDate'''),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
