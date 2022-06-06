import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:billing_management/model/occupant.dart';
import 'package:billing_management/model/payment.dart';
import 'package:billing_management/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sms_maintained/sms.dart';
import '../view/billingHistory.dart';

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Occupant> occupantList;
  List<Occupant> overdueOccupant = new List<Occupant>();
  List<Occupant> todayOccupant = new List<Occupant>();
  List<Occupant> thisweekOccupant = new List<Occupant>();
  List<Occupant> nextweekOccupant = new List<Occupant>();
  List<Occupant> upcomingOccupant = new List<Occupant>();

  int count = 0;
  int overdueCount = 0;
  int todayCount = 0;
  int thisweekCount = 0;
  int nextweekCount = 0;
  int upcomingCount = 0;

  List<String> heading = [
    'Overdue',
    'Today',
    'This Week',
    'Next Week',
    'Upcoming'
  ];

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    if (occupantList == null) {
      occupantList = List<Occupant>();
      updateListView();
    }

    if (occupantList != null) {
      sortDue();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
          key: _refreshKey,
          child: occupantList.isNotEmpty
              ? dueList()
              : Center(
                  child: Text('No Current Occupants',
                      style: TextStyle(color: Colors.grey))),
          onRefresh: () async {
            await refreshList();
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentHistory()))
              .then((value) => refreshList());
        },
        icon: Icon(Icons.history, color: Colors.white),
        label: Text('Payment History', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void sortDue() {
    DateTime dateTimeNow = new DateTime.now();
    int i = 0;

    while (i < count) {
      print(i);

      DateTime dueDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(this.occupantList[i].dueDate);
      if (dueDate.isBefore(dateTimeNow) && dueDate.day != dateTimeNow.day) {
        print('overdue');
        print(this.occupantList[i].lastName);
        this.overdueOccupant.add(this.occupantList[i]);
        this.overdueCount++;
        i++;
      } else if (dueDate.day == dateTimeNow.day &&
          dueDate.month == dateTimeNow.month) {
        print('today');
        print(this.occupantList[i].lastName);
        this.todayOccupant.add(this.occupantList[i]);
        this.todayCount++;
        i++;
      } else if (dueDate.isBefore(dateTimeNow.add(Duration(days: 7)))) {
        print('thisweek');
        print(this.occupantList[i].lastName);
        this.thisweekOccupant.add(this.occupantList[i]);
        this.thisweekCount++;
        i++;
      } else if (dueDate.isBefore(dateTimeNow.add(Duration(days: 14)))) {
        print('nextweek');
        print(this.occupantList[i].lastName);
        this.nextweekOccupant.add(this.occupantList[i]);
        this.nextweekCount++;
        i++;
      } else if (dueDate.isAfter(dateTimeNow.add(Duration(days: 14)))) {
        print('upcoming');
        print(this.occupantList[i].lastName);
        this.upcomingOccupant.add(this.occupantList[i]);
        this.upcomingCount++;
        i++;
      } else {
        print('error');
        i++;
      }
    }

    print('Occupant List Count: ' + count.toString());
    print('sorted');
  }

  ListView dueList() {
    return ListView.builder(
      itemCount: heading.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Builder(builder: (context) {
              if (index == 0 && overdueCount != 0) {
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(heading[0],
                          style: TextStyle(
                              color: Colors.red[400],
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0)),
                    ),
                    occupantsList(overdueOccupant, overdueCount, heading[0]),
                  ],
                );
              } else if (index == 1 && todayCount != 0) {
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(heading[1],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.0)),
                    ),
                    occupantsList(todayOccupant, todayCount, heading[1])
                  ],
                );
              } else if (index == 2 && thisweekCount != 0) {
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(heading[2],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.0)),
                    ),
                    occupantsList(thisweekOccupant, thisweekCount, '')
                  ],
                );
              } else if (index == 3 && nextweekCount != 0) {
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(heading[3],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.0)),
                    ),
                    occupantsList(nextweekOccupant, nextweekCount, '')
                  ],
                );
              } else if (index == 4 && upcomingCount != 0) {
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(heading[4],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.0)),
                    ),
                    occupantsList(upcomingOccupant, upcomingCount, '')
                  ],
                );
              } else {
                return SizedBox(
                  height: 0,
                );
              }
            }),
          ],
        );
      },
    );
  }

  ListView occupantsList(List<Occupant> occupant, int count, String heading) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, position) {
        return Card(
          elevation: 3,
          child: ListTile(
            title: Text(
              '${occupant[position].firstName} ${occupant[position].lastName}',
            ),
            subtitle: Text(
                '${DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd hh:mm:ss').parse(occupant[position].dueDate))}'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PaymentPage(occupant[position], heading)),
              );
            },
          ),
        );
      },

      shrinkWrap: true, // todo comment this out and check the result
      physics:
          ClampingScrollPhysics(), // todo comment this out and check the result
    );
  }

  Future<Null> refreshList() async {
    print('Refreshing..');
    _refreshKey.currentState.show();
    await Future.delayed(Duration(seconds: 2));
    occupantList = List<Occupant>();
    overdueOccupant = List<Occupant>();
    todayOccupant = List<Occupant>();
    thisweekOccupant = List<Occupant>();
    nextweekOccupant = List<Occupant>();
    upcomingOccupant = List<Occupant>();
    this.count = 0;
    this.overdueCount = 0;
    this.todayCount = 0;
    this.thisweekCount = 0;
    this.nextweekCount = 0;
    this.upcomingCount = 0;
    updateListView();
    if (occupantList != null) {
      sortDue();
    }
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
}

class PaymentPage extends StatefulWidget {
  final String heading;
  final Occupant occupant;

  PaymentPage(this.occupant, this.heading);

  @override
  State<StatefulWidget> createState() {
    return PaymentPageState(this.occupant, this.heading);
  }
}

class PaymentPageState extends State<PaymentPage> {
  PaymentPageState(this.occupant, this.heading);

  final Occupant occupant;
  final String heading;

  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController paymentChangeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const platform = const MethodChannel('sendSms');

  FlutterLocalNotificationsPlugin fltrNotification;

  String _dueDate;
  String _paymentDate;
  String _paymentDueDate;
  double _amountDue;
  double _amountPaid;
  double _change;
  int _occupantID;

  Payment payment = new Payment('', '', 0, 0, 0, 0);

  DatabaseHelper databaseHelper = DatabaseHelper();

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

    String payload = "${occupant.firstName} ${occupant.lastName} is due today";
    var scheduledTime = DateTime.now().add(Duration(days: 30));
    fltrNotification.schedule(occupant.roomNumber, "Duedate", "$payload",
        scheduledTime, generalNotificationDetails,
        payload: "$payload");
  }

  @override
  Widget build(BuildContext context) {
    paymentAmountController.text = occupant.ratePerPeriod.toString();
    paymentChangeController.text = (double.parse(paymentAmountController.text) -
            this.occupant.ratePerPeriod)
        .toString();

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar

              moveToLastScreen(context);
            }),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${occupant.firstName} ${occupant.lastName}'),
                      Text('Contact: ${occupant.contactNumber}'),
                      Text('Room: ${occupant.roomNumber}'),
                      Text('Rate: ${occupant.ratePerPeriod}'),
                      Text('Due Date: ${occupant.dueDate}'),
                      _buildPaymentAmount(),
                      _buildPaymentChange(),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sendsmsButton(context),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Confirm Payment',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      _showAlertDialog(context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sendsmsButton(context) {
    if (heading == 'Overdue' || heading == 'Today') {
      return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'Send SMS',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          sendSms();
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future<Null> sendSms() async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod(
          'send', <String, dynamic>{
        "phone": "+91XXXXXXXXXX",
        "msg": "Hello! I'm sent programatically."
      }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  // void sendSMS() async {
  //   SmsSender sender = new SmsSender();
  //   String address = occupant.contactNumber.toString();

  //   SmsMessage message = new SmsMessage(address, '''
  //       ${occupant.firstName} ${occupant.lastName}
  //       ${occupant.contactNumber}

  //       This is an automated message reminder that you are now past due in the current room you are staying, please contact the owner to extend your stay as soon as possible.
  //       ''');
  //   message.onStateChanged.listen((state) {
  //     if (state == SmsMessageState.Sent) {
  //       print("SMS is sent!");
  //     } else if (state == SmsMessageState.Delivered) {
  //       print("SMS is delivered!");
  //     }
  //   });
  //   sender.sendSms(message);
  // }

  void moveToLastScreen(context) {
    Navigator.pop(context, true);
  }

  Widget _buildPaymentChange() {
    return TextFormField(
      controller: paymentChangeController,
      decoration: InputDecoration(labelText: 'Change'),
      readOnly: true,
    );
  }

  Widget _buildPaymentAmount() {
    return TextFormField(
      controller: paymentAmountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Amount'),
      validator: (String value) {
        if (value.isEmpty ||
            double.parse(value) < this.occupant.ratePerPeriod) {
          return 'Invalid Amount';
        }
      },
      onChanged: (value) {
        paymentChangeController.text =
            (double.parse(paymentAmountController.text) -
                    this.occupant.ratePerPeriod)
                .toString();
      },
      onSaved: (String value) {
        final now = new DateTime.now();
        DateTime tempDate =
            new DateFormat("yyyy-MM-dd hh:mm:ss").parse(this.occupant.dueDate);
        _dueDate = DateFormat('yyyy-MM-dd hh:mm:ss')
            .format(tempDate.add(Duration(days: 30)));
        this.occupant.dueDate = _dueDate;

        _paymentDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);

        _paymentDueDate = this.occupant.dueDate;
        this.payment.paymentDueDate = _paymentDueDate;

        this.payment.paymentDate = _paymentDate;

        _amountDue = this.occupant.ratePerPeriod;
        this.payment.amountDue = _amountDue;

        _amountPaid = double.parse(paymentAmountController.text);
        this.payment.amountPaid = _amountPaid;

        _change = double.parse(paymentChangeController.text);
        this.payment.change = _change;

        _occupantID = this.occupant.occupantID;
        this.payment.occupant_id = _occupantID;

        _savePayment();
        _update();
      },
    );
  }

  void _savePayment() async {
    await databaseHelper.insertPayment(this.payment);
    await _showNotification();
    print('Payment Date $_paymentDate');
    print('Payment Due Date $_paymentDueDate');
    print('Amount Due $_amountDue');
    print('Amount Paid $_amountPaid');
    print('Amount Change $_change');
    print('Occupant ID $_occupantID');
  }

  void _update() async {
    int result;
    result = await databaseHelper.update(this.occupant);
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
