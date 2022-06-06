class Occupant {
  int _occupantID;
  String _lastName;
  String _firstName;
  String _address;
  int _contactNumber;
  int _roomNumber;
  String _reservationDate;
  String _dueDate;
  double _ratePerPeriod;
  String _remarks;

  Occupant(
    this._lastName,
    this._firstName,
    this._address,
    this._contactNumber,
    this._roomNumber,
    this._reservationDate,
    this._dueDate,
    this._ratePerPeriod,
    this._remarks,
  );

  Occupant.withId(
    this._occupantID,
    this._lastName,
    this._firstName,
    this._address,
    this._contactNumber,
    this._roomNumber,
    this._reservationDate,
    this._dueDate,
    this._ratePerPeriod,
    this._remarks,
  );

  int get occupantID => _occupantID;
  String get lastName => _lastName;
  String get firstName => _firstName;
  String get address => _address;
  int get contactNumber => _contactNumber;
  int get roomNumber => _roomNumber;
  String get reservationDate => _reservationDate;
  String get dueDate => _dueDate;
  double get ratePerPeriod => _ratePerPeriod;
  String get remarks => _remarks;

  set lastName(String newLastName) {
    this._lastName = newLastName;
  }

  set firstName(String newFirstName) {
    this._firstName = newFirstName;
  }

  set address(String newAddress) {
    this._address = newAddress;
  }

  set contactNumber(int newContactNumber) {
    this._contactNumber = newContactNumber;
  }

  set roomNumber(int newRoomNumber) {
    this._roomNumber = newRoomNumber;
  }

  set reservationDate(String newReservationDate) {
    this._reservationDate = newReservationDate;
  }

  set dueDate(String newDueDate) {
    this._dueDate = newDueDate;
  }

  set ratePerPeriod(double newRatePerPeriod) {
    this._ratePerPeriod = newRatePerPeriod;
  }

  set remarks(String newRemarks) {
    this._remarks = newRemarks;
  }

  //insert occupant object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (occupantID != null) {
      map['id'] = _occupantID;
    }
    map['lastName'] = _lastName;
    map['firstName'] = _firstName;
    map['address'] = _address;
    map['contactNumber'] = _contactNumber;
    map['roomNumber'] = _roomNumber;
    map['reservationDate'] = _reservationDate;
    map['dueDate'] = _dueDate;
    map['ratePerPeriod'] = _ratePerPeriod;
    map['remarks'] = _remarks;

    return map;
  }

  //extract occupant object to map object
  Occupant.fromMapObject(Map<String, dynamic> map) {
    this._occupantID = map['id'];
    this._lastName = map['lastName'];
    this._firstName = map['firstName'];
    this._address = map['address'];
    this._contactNumber = map['contactNumber'];
    this._roomNumber = map['roomNumber'];
    this._reservationDate = map['reservationDate'];
    this._dueDate = map['dueDate'];
    this._ratePerPeriod = map['ratePerPeriod'];
    this._remarks = map['remarks'];
  }
}
