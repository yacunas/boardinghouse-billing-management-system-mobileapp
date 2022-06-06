class Payment {
  int _paymentID;
  String _paymentDate;
  String _paymentDueDate;
  double _amountDue;
  double _amountPaid;
  double _change;
  int _occupantID;

  Payment(this._paymentDate, this._paymentDueDate, this._amountDue,
      this._amountPaid, this._change, this._occupantID);

  // Payment(this._paymentDate, this._paymentDueDate, this._amountDue,
  //     this._amountPaid, this._change, this._occupant_id);

  Payment.withId(this._paymentID, this._paymentDate, this._paymentDueDate,
      this._amountDue, this._amountPaid, this._change, this._occupantID);

  int get paymentID => _paymentID;
  String get paymentDate => _paymentDate;
  String get paymentDueDate => _paymentDueDate;
  double get amountDue => _amountDue;
  double get amountPaid => _amountPaid;
  double get change => _change;
  // ignore: non_constant_identifier_names
  int get occupant_id => _occupantID;

  set paymentDate(String newPaymentDate) {
    this._paymentDate = newPaymentDate;
  }

  set paymentDueDate(String newPaymentDueDate) {
    this._paymentDueDate = newPaymentDueDate;
  }

  set amountDue(double newAmountDue) {
    this._amountDue = newAmountDue;
  }

  set amountPaid(double newAmountPaid) {
    this._amountPaid = newAmountPaid;
  }

  set change(double newChange) {
    this._change = newChange;
  }

  // ignore: non_constant_identifier_names
  set occupant_id(int newOccupantID) {
    this._occupantID = newOccupantID;
  }

  //insert occupant object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (paymentID != null) {
      map['id'] = _paymentID;
    }

    map['paymentDate'] = _paymentDate;
    map['dueDate'] = _paymentDueDate;
    map['amountDue'] = _amountDue;
    map['amountPaid'] = _amountPaid;
    map['change'] = _change;
    map['occupant_id'] = _occupantID;

    return map;
  }

  //extract occupant object to map object
  Payment.fromMapObject(Map<String, dynamic> map) {
    this._paymentID = map['id'];
    this._paymentDate = map['paymentDate'];
    this._paymentDueDate = map['dueDate'];
    this._amountDue = map['amountDue'];
    this._amountPaid = map['amountPaid'];
    this._change = map['change'];
    this._occupantID = map['occupant_id'];
  }
}
