import 'package:flutter/material.dart';
import 'package:billing_management/model/occupant.dart';
import 'package:billing_management/model/payment.dart';
import 'package:billing_management/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class PaymentHistory extends StatefulWidget {
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Occupant> occupantList;
  List<Payment> paymentList;
  Occupant occupant;

  int pCount = 0;
  int oCount = 0;

  @override
  Widget build(BuildContext context) {
    if (paymentList == null && occupantList == null) {
      paymentList = List<Payment>();
      occupantList = List<Occupant>();
      updateOccupantList();
      updatePaymentList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: paymentList.isNotEmpty
          ? getPaymentsListView()
          : Center(
              child: Text('No Payments History',
                  style: TextStyle(color: Colors.grey))),
    );
  }

  void updateOccupantList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Occupant>> occupantListFuture =
          databaseHelper.getOccupantList();
      occupantListFuture.then((occupantList) {
        setState(() {
          this.occupantList = occupantList;
          this.oCount = occupantList.length;
        });
      });
    });
  }

  void updatePaymentList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Payment>> paymentListFuture =
          databaseHelper.getPaymentsList();

      paymentListFuture.then((paymentList) {
        setState(() {
          this.paymentList = paymentList;
          this.pCount = paymentList.length;
        });
      });
    });
  }

  ListView getPaymentsListView() {
    return ListView.builder(
        itemCount: pCount,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            elevation: 5,
            child: ListTile(
              title: Text(
                '${getOccuppant(this.paymentList[position].occupant_id).firstName} ${getOccuppant(this.paymentList[position].occupant_id).lastName}',
                //'${this.occupantList[position].firstName}',
              ),
              trailing: Text('${this.paymentList[position].paymentDate}'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OccupantHistory(getOccuppant(
                          this.paymentList[position].occupant_id))),
                );
              },
            ),
          );
        });
  }

  Occupant getOccuppant(id) {
    //Occupant occupant;
    for (int i = 0; i < oCount; i++) {
      if (id == occupantList[i].occupantID) {
        occupant = occupantList[i];
      }
    }
    return occupant;
  }
}

class OccupantHistory extends StatefulWidget {
  final Occupant occupant;

  const OccupantHistory(this.occupant);

  @override
  _OccupantHistoryState createState() => _OccupantHistoryState();
}

class _OccupantHistoryState extends State<OccupantHistory> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController roomNumberController = TextEditingController();
  final TextEditingController ratePerPeriodController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  Occupant occupant;
  List<Payment> paymentList;
  //List<Payment> payments;
  //Payment payment;
  int pCount = 0;

  @override
  Widget build(BuildContext context) {
    if (paymentList == null) {
      paymentList = List<Payment>();
      updatePaymentList();
    }

    lastNameController.text = widget.occupant.lastName;
    firstNameController.text = widget.occupant.firstName;
    addressController.text = widget.occupant.address;
    contactNumberController.text = widget.occupant.contactNumber.toString();
    roomNumberController.text = widget.occupant.roomNumber.toString();
    ratePerPeriodController.text = widget.occupant.ratePerPeriod.toString();
    remarksController.text = widget.occupant.remarks;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.occupant.firstName} ${widget.occupant.lastName}'),
      ),
      body: Scrollbar(
        controller: _scrollController1,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
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
                          Center(child: Text('Basic Information')),
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
                        ],
                      ),
                    )),
                SizedBox(height: 10.0),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('Payment History'),
                          SizedBox(height: 5),
                          Scrollbar(
                            isAlwaysShown: true,
                            controller: _scrollController2,
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 300),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: viewPayments(),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView viewPayments() {
    return ListView.builder(
      //controller: _scrollController2,

      shrinkWrap: true, // todo comment this out and check the result
      physics: ClampingScrollPhysics(),
      itemCount: pCount,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          title: Text(
            this.paymentList[position].paymentDate,
          ),
        );
      },
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      controller: addressController,
      decoration: InputDecoration(labelText: 'Address'),
      readOnly: true,
    );
  }

  Widget _buildContactNumber() {
    return TextFormField(
      controller: contactNumberController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Contact Number'),
      readOnly: true,
    );
  }

  Widget _buildRoomNumber() {
    return TextFormField(
      controller: roomNumberController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Room Number'),
      readOnly: true,
    );
  }

  Widget _buildRatePerPeriod() {
    return TextFormField(
      controller: ratePerPeriodController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Rate per Period'),
      readOnly: true,
    );
  }

  Widget _buildRemarks() {
    return TextFormField(
      controller: remarksController,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      maxLength: 50,
      decoration: InputDecoration(labelText: 'Remarks'),
      readOnly: true,
    );
  }

  void updatePaymentList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Payment>> paymentListFuture =
          databaseHelper.getOccupantPayments(widget.occupant.occupantID);

      paymentListFuture.then((paymentList) {
        setState(() {
          this.paymentList = paymentList;
          this.pCount = paymentList.length;
        });
      });
    });
  }
}
