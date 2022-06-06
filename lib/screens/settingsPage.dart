import 'package:flutter/material.dart';
import 'package:billing_management/model/company.dart';
import 'package:billing_management/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Company> companyList;
  int count;
  Company company;

  String _companyName;
  String _ownerLastName;
  String _ownerFirstName;
  String _companyAddress;
  int _companyContactNumber;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController ownerLastNameController = TextEditingController();
  TextEditingController ownerFirstNameController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyContactNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (companyList == null) {
      companyList = List<Company>();
      updateListView();
    }

    if (count == 1) {
      this.company = companyList[count - 1];
      companyNameController.text = this.company.companyName;
      ownerLastNameController.text = this.company.ownerLastName;
      ownerFirstNameController.text = this.company.ownerFirstName;
      companyAddressController.text = this.company.companyAddress;
      companyContactNumberController.text =
          this.company.companyContactNumber.toString();
    } else {
      company = new Company('', '', '', '', 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Company'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text('Company Profile'),
                        _buildCompanyName(),
                        Row(
                          children: <Widget>[
                            Flexible(child: _buildOwnerLastName()),
                            SizedBox(width: 20.0),
                            Flexible(child: _buildOwnerFirstName())
                          ],
                        ),
                        _buildCompanyAddress(),
                        _buildCompanyContactNumber(),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 35.0),
                Container(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();
                      _save();
                      print('Save Pressed');
                      _showAlertDialog(context);
                    },
                  ),
                ),
                // Container(
                //   child: RaisedButton(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30.0),
                //     ),
                //     child: Text(
                //       'Remove Information',
                //       style: TextStyle(color: Colors.white, fontSize: 15),
                //     ),
                //     color: Theme.of(context).primaryColor,
                //     onPressed: () async {
                //       if (count == 1) {
                //         _delete();
                //         _resetController();
                //       } else {
                //         print('none deleted');
                //         return;
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _resetController() {
    companyNameController.text = '';
    ownerLastNameController.text = '';
    ownerFirstNameController.text = '';
    companyAddressController.text = '';
    companyContactNumberController.text = '';
  }

  void _save() async {
    if (count == 0) {
      await databaseHelper.insertCompany(this.company);
      updateListView();
    } else {
      print('updating..');
      await databaseHelper.updateCompany(this.company);
      updateListView();
    }
  }

  void _delete() async {
    int result = await databaseHelper.deleteCompany(this.company.companyID);
    if (result != 0) {
      print('Successfully Deleted');
      _showAlertDialog(context);
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Company>> occupantListFuture =
          databaseHelper.getCompanyList();
      occupantListFuture.then((companyList) {
        setState(() {
          this.companyList = companyList;
          this.count = companyList.length;
        });
      });
    });
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
      title: Text('Successful'),
      content: Text("Changes Saved!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget _buildCompanyName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Company Name'),
      controller: companyNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Company name is required';
        }
      },
      onSaved: (String value) {
        _companyName = value;
        this.company.companyName = _companyName;
      },
    );
  }

  Widget _buildOwnerLastName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Owner Last Name'),
      controller: ownerLastNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Lastname is required';
        }
      },
      onSaved: (String value) {
        _ownerLastName = value;
        this.company.ownerLastName = _ownerLastName;
      },
    );
  }

  Widget _buildOwnerFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Owner First Name'),
      controller: ownerFirstNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Firstname is required';
        }
      },
      onSaved: (String value) {
        _ownerFirstName = value;
        this.company.ownerFirstName = _ownerFirstName;
      },
    );
  }

  Widget _buildCompanyAddress() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Company Address'),
      controller: companyAddressController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is required';
        }
      },
      onSaved: (String value) {
        _companyAddress = value;
        this.company.companyAddress = _companyAddress;
      },
    );
  }

  Widget _buildCompanyContactNumber() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Contact Number'),
      controller: companyContactNumberController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Contact number is required';
        }
        if (value.length != 11 && value.length != 10) {
          return 'Invalid Contact Number';
        }
      },
      onSaved: (String value) {
        _companyContactNumber = int.parse(value);
        this.company.companyContactNumber = _companyContactNumber;
      },
    );
  }
}
