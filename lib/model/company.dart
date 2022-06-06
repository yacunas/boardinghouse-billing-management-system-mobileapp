class Company {
  int _companyID;
  String _companyName;
  String _ownerLastName;
  String _ownerFirstName;
  String _companyAddress;
  int _companyContactNumber;

  Company(
    this._companyName,
    this._ownerLastName,
    this._ownerFirstName,
    this._companyAddress,
    this._companyContactNumber,
  );

  Company.withId(
    this._companyID,
    this._companyName,
    this._ownerLastName,
    this._ownerFirstName,
    this._companyAddress,
    this._companyContactNumber,
  );

  int get companyID => _companyID;
  String get companyName => _companyName;
  String get ownerLastName => _ownerLastName;
  String get ownerFirstName => _ownerFirstName;
  String get companyAddress => _companyAddress;
  int get companyContactNumber => _companyContactNumber;

  set companyName(String newCompanyName) {
    this._companyName = newCompanyName;
  }

  set ownerLastName(String newOwnerLastName) {
    this._ownerLastName = newOwnerLastName;
  }

  set ownerFirstName(String newOwnerFirstName) {
    this._ownerFirstName = newOwnerFirstName;
  }

  set companyAddress(String newCompanyAddress) {
    this._companyAddress = newCompanyAddress;
  }

  set companyContactNumber(int newCompanyContactNumber) {
    this._companyContactNumber = newCompanyContactNumber;
  }

  //insert occupant object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (companyID != null) {
      map['id'] = _companyID;
    }

    map['companyName'] = _companyName;
    map['companyOwnerLastName'] = _ownerLastName;
    map['companyOwnerFirstName'] = _ownerFirstName;
    map['companyOwnerAddress'] = _companyAddress;
    map['companyOwnerContactNumber'] = _companyContactNumber;

    return map;
  }

  //extract occupant object to map object
  Company.fromMapObject(Map<String, dynamic> map) {
    this._companyID = map['id'];
    this._companyName = map['companyName'];
    this._ownerLastName = map['companyOwnerLastName'];
    this._ownerFirstName = map['companyOwnerFirstName'];
    this._companyAddress = map['companyOwnerAddress'];
    this._companyContactNumber = map['companyOwnerContactNumber'];
  }
}
