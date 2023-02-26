class Stats {
  int? _jobdone;
  List<double>? _earningweek = [];
  List<double>? _earningmonth = [];
  int? _totalamt;

  Stats(this._jobdone, this._earningweek, this._earningmonth, this._totalamt);

  int? get jobdone => _jobdone;
  int? get totalamt => _totalamt;
  List<double>? get earningweek => _earningweek;
  List<double>? get earningmonth => _earningmonth;

  Stats.map(dynamic obj) {
    _jobdone = obj['jobdone'];
    _totalamt = obj['totalamt'];
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
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["jobdone"] = _jobdone;
    map["earningweek"] = _earningweek;
    map["earningmonth"] = _earningmonth;
    map["totalamt"] = _totalamt;

    return map;
  }

  factory Stats.fromJson(Map<String, dynamic> data) {
    return Stats(
      data["jobdone"],
      data["earningweek"],
      data["earningmonth"],
      data["totalamt"],
    );
  }
}
