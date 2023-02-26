import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../model/account.dart';
import '../model/stats.dart';
import '../model/statsprice.dart';
import '../servicelocator.dart';
import '../services/RestData/RestDataServices.dart';

class CreateAccountViewModel extends ChangeNotifier {
  // static CreateAccountProvider of(BuildContext context, {bool listen = true}) =>
  //     Provider.of<CreateAccountProvider>(context, listen: listen);

  // String _prevSearchTerm = "";

  final RestDataService _restdataService = serviceLocator<RestDataService>();
  String _logOneMail = "";
  String _loginUsername = "";
  String _token = "";
  Account? _account;
  Stats? _stats;
  Statsprice? _statsprices;
  String? _pid;
  String? _chatusername;

//  String get prevSearchTerm => _prevSearchTerm;
  String get logonemail => _logOneMail;
  String get token => _token;
  String get logonusername => _loginUsername;
  Account? get account => _account;
  Stats? get stats => _stats;
  Statsprice? get statsprices => _statsprices;
  String? get chatusername => _chatusername;

  String? get pids => _pid;

  void setpid(String id) {
    _pid = id;
    print("pid -");
    print(_pid);
    notifyListeners();
  }

  void setstats(Stats id) {
    _stats = id;
    print("stats -");
    print(_stats);
    notifyListeners();
  }

  void setstatsprice(Statsprice id) {
    _statsprices = id;
    print("statsprice -");
    print(_statsprices);
    notifyListeners();
  }

  void logonemailset(String newValue) {
    _logOneMail = newValue;
    print("logon here now");
    print(_logOneMail);
    notifyListeners();
  }

  void tokenset(String newValue) {
    _token = newValue;
    print("logon here now");
    print(_token);
    notifyListeners();
  }

  void accounts(String username) async {
    _account = await _restdataService.getloggedin(username);

    print("account -");
    print(account?.notifyCount);
    notifyListeners();
  }

  void usernameset(String newValue) {
    _loginUsername = newValue;
    print("logon here now");
    print(_loginUsername);

    notifyListeners();
  }

  void chatusernameset(String newValue) {
    _chatusername = newValue;
    print("logon here now");
    print(_chatusername);

    notifyListeners();
  }

  // set prevSearchTerm(String newValue) {
  //   _prevSearchTerm = newValue;
  // }
}
