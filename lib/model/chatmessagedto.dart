class ChatRequestDTO2 {
  String _username;
  String _rusername;
  String _content;
  String _date;

  ChatRequestDTO2(
    this._username,
    this._rusername,
    this._content,
    this._date,
  );
  String get username => _username;
  String get rusername => _rusername;
  String get content => _content;
  String get date => _date;

  void setusername(String username) {
    _username = username;
  }

  void setrusername(String rusername) {
    _rusername = rusername;
  }

  void setcontent(String content) {
    _content = content;
  }

  void setdate(String date) {
    _date = date;
  }

  ChatRequestDTO2.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _rusername = json['rusername'],
        _content = json['content'],
        _date = json['date'];

  Map<String, dynamic> toJson() => {
        'username': _username,
        'rusername': _rusername,
        'content': _content,
        'date': _date
      };
}
