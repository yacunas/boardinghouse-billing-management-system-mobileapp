import 'dart:io';
import 'package:billing_management/model/company.dart';
import 'package:billing_management/model/occupant.dart';
import 'package:billing_management/model/payment.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "occupantsDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;
  //This is the actual name of the table in the database.
  static final _usersTableName = 'usersTable';
  static final _occupantTableName = 'occupantsTable';
  static final _paymentsTableName = 'paymentsTable';
  static final _companyTableName = 'companyTable';

  // database table and column names
  static final columnUsername = 'username';
  static final columnPassword = 'password';

  static final columnOccupantID = 'id';
  static final columnLastName = 'lastName';
  static final columnFirstName = 'firstName';
  static final columnGender = 'gender';
  static final columnAddress = 'address';
  static final columnContactNumber = 'contactNumber';
  static final columnRoomNumber = 'roomNumber';
  static final columnReservationDate = 'reservationDate';
  static final columnDueDate = 'dueDate';
  static final columnRatePerPeriod = 'ratePerPeriod';
  static final columnRemarks = 'remarks';

  static final columnPaymentID = 'id';
  static final columnPaymentDate = 'paymentDate';
  static final columnPaymentDueDate = 'dueDate';
  static final columnAmountDue = 'amountDue';
  static final columnAmountPaid = 'amountPaid';
  static final columnChange = 'change';
  static final columnPaymentOccupantID = 'occupant_id';

  static final columnCompanyID = 'id';
  static final columnCompanyName = 'companyName';
  static final columnCompanyOwnerLastName = 'companyOwnerLastName';
  static final columnCompanyOwnerFirstName = 'companyOwnerFirstName';
  static final columnCompanyContactNumber = 'companyOwnerContactNumber';
  static final columnCompanyAddress = 'companyOwnerAddress';

  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _databaseName;

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    return notesDatabase;
  }

  // SQL string to create the database
  void _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $_usersTableName (
                $columnUsername TEXT NOT NULL,
                $columnPassword TEXT NOT NULL)''');

    await db.execute('''
              CREATE TABLE $_occupantTableName (
                $columnOccupantID INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnLastName TEXT NOT NULL,
                $columnFirstName TEXT NOT NULL,
                $columnAddress TEXT NOT NULL,
                $columnContactNumber INTEGER NOT NULL,
                $columnRoomNumber INTEGER NOT NULL,
                $columnReservationDate TEXT NOT NULL,
                $columnDueDate TEXT NOT NULL,
                $columnRatePerPeriod DOUBLE NOT NULL,
                $columnRemarks TEXT)''');

    await db.execute('''
              CREATE TABLE $_paymentsTableName (
                $columnPaymentID INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnPaymentDate TEXT NOT NULL,
                $columnPaymentDueDate TEXT NOT NULL,
                $columnAmountDue DOUBLE NOT NULL,
                $columnAmountPaid DOUBLE NOT NULL,
                $columnChange DOUBLE NOT NULL,
                $columnPaymentOccupantID INTEGER NOT NULL,
                FOREIGN KEY ($columnPaymentOccupantID) REFERENCES $_occupantTableName ($columnOccupantID) 
                ON DELETE NO ACTION ON UPDATE NO ACTION)''');

    await db.execute('''
              CREATE TABLE $_companyTableName (
                $columnCompanyID INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnCompanyName TEXT,
                $columnCompanyOwnerLastName TEXT,
                $columnCompanyOwnerFirstName TEXT,
                $columnCompanyContactNumber INTEGER,
                $columnCompanyAddress TEXT)''');
  }

  Future<List<Map<String, dynamic>>> getOccupantMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result =
        await db.query(_occupantTableName, orderBy: '$columnOccupantID ASC');
    return result;
  }

  // Database helper methods:
  //add occupant to database
  Future<int> insert(Occupant occupant) async {
    Database db = await this.database;
    var result = await db.insert(_occupantTableName, occupant.toMap());
    return result;
  }

  //edit occupant from database with room number
  Future<int> update(Occupant occupant) async {
    var db = await this.database;
    var result = await db.update(_occupantTableName, occupant.toMap(),
        where: '$columnOccupantID = ?', whereArgs: [occupant.occupantID]);
    return result;
  }

  //delete occupant from database with room number
  Future<int> delete(int id) async {
    var db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $_occupantTableName WHERE $columnOccupantID = $id');
    return result;
  }

  //display all occupant from the table
  Future<List<Occupant>> getOccupantList() async {
    var occupantMapList = await getOccupantMapList();
    int count = occupantMapList.length;

    List<Occupant> occupantList = List<Occupant>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      occupantList.add(Occupant.fromMapObject(occupantMapList[i]));
    }

    return occupantList;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $_occupantTableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // ------------------------------Company---------------------------
  Future<List<Map<String, dynamic>>> getCompanyMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result =
        await db.query(_companyTableName, orderBy: '$columnOccupantID ASC');
    return result;
  }

  Future<List<Company>> getCompanyList() async {
    var companyMapList = await getCompanyMapList();
    int count = companyMapList.length;

    List<Company> companyList = List<Company>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      companyList.add(Company.fromMapObject(companyMapList[i]));
    }

    return companyList;
  }

  Future<int> insertCompany(Company company) async {
    Database db = await this.database;
    var result = await db.insert(_companyTableName, company.toMap());
    return result;
  }

  //edit occupant from database with room number
  Future<int> updateCompany(Company company) async {
    var db = await this.database;
    var result = await db.update(_companyTableName, company.toMap(),
        where: '$columnCompanyID = ?', whereArgs: [company.companyID]);
    return result;
  }

  Future<int> deleteCompany(id) async {
    var db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $_companyTableName WHERE $columnCompanyID = $id');
    return result;
  }

  //------------------------------Payments----------------------------
  Future<List<Map<String, dynamic>>> getPaymentsMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result =
        await db.query(_paymentsTableName, orderBy: '$columnPaymentID DESC');
    return result;
  }

  Future<int> insertPayment(Payment payment) async {
    Database db = await this.database;
    var result = await db.insert(_paymentsTableName, payment.toMap());
    return result;
  }

  //edit occupant from database with room number
  Future<int> updatePayment(Payment payment) async {
    var db = await this.database;
    var result = await db.update(_paymentsTableName, payment.toMap(),
        where: '$columnPaymentID = ?', whereArgs: [payment.occupant_id]);
    return result;
  }

  //delete occupant from database with room number
  Future<int> deletePayment(int id) async {
    var db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $_paymentsTableName WHERE $columnPaymentOccupantID = $id');
    return result;
  }

  //display all occupant from the table
  Future<List<Payment>> getPaymentsList() async {
    var paymentMapList = await getPaymentsMapList();
    int count = paymentMapList.length;

    List<Payment> paymentList = List<Payment>();
    // For loop to create a 'Payment List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      paymentList.add(Payment.fromMapObject(paymentMapList[i]));
    }

    return paymentList;
  }

  Future<List<Payment>> getOccupantPayments(id) async {
    var paymentsList = await getPaymentsList();
    int count = paymentsList.length;

    List<Payment> occupantPaymentList = List<Payment>();
    // For loop to create a 'Payment List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      if (id == paymentsList[i].occupant_id) {
        occupantPaymentList.add(paymentsList[i]);
      }
    }

    return occupantPaymentList;
  }

  Future<int> getPaymentCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $_paymentsTableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
