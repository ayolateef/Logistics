class Statsprice {
  int? _jobdone;
  List<double>? _earningweek = [];
  List<double>? _earningmonth = [];

  Statsprice(this._jobdone, this._earningweek, this._earningmonth);

  int? get jobdone => _jobdone;
  List<double>? get earningweek => _earningweek;
  List<double>? get earningmonth => _earningmonth;

  Statsprice.map(dynamic obj) {
    _jobdone = obj['jobdone'];
    List<dynamic> record1 = obj['earningweek'];
    for (dynamic record in record1) {
      double value = double.parse(record.toString());
      _earningweek?.add(value);
    }
    List<dynamic> record2 = obj['earningmonth'];
    for (dynamic record in record2) {
      double value = double.parse(record.toString());
      _earningmonth?.add(value);
    }
    //
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["jobdone"] = _jobdone;
    map["earningweek"] = _earningweek;
    map["earningmonth"] = _earningmonth;

    return map;
  }

  factory Statsprice.fromJson(Map<String, dynamic> data) {
    return Statsprice(
      data["jobdone"],
      data["earningweek"],
      data["earningmonth"],
    );
  }
}
