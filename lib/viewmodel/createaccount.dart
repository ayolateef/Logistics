import 'package:flutter/cupertino.dart';

import '../model/account.dart';
import '../model/driver.dart';
import '../servicelocator.dart';
import '../services/RestData/RestDataServices.dart';

class CreateAccountViewModel extends ChangeNotifier {
  // static CreateAccountProvider of(BuildContext context, {bool listen = true}) =>
  //     Provider.of<CreateAccountProvider>(context, listen: listen);

  // String _prevSearchTerm = "";

  final RestDataService _restdataService = serviceLocator<RestDataService>();
  String _logOnEmail = "";
  String _logOnUsername = "";
  String _token = "";
  Account? _account;
  Driver? _drivers;

//  String get prevSearchTerm => _prevSearchTerm;
  String get logonemail => _logOnEmail;
  String get token => _token;
  String get logonusername => _logOnUsername;
  Account? get account => _account;
  Driver? get drivers => _drivers;
  String? _pid;

  String? get pIds => _pid;

  void setpId(String id) {
    _pid = id;
    print("pid -");
    print(_pid);
    notifyListeners();
  }

  void logOneMailSet(String newValue) {
    _logOnEmail = newValue;
    print("logon here now");
    print(_logOnEmail);
    notifyListeners();
  }

  void tokenSet(String newValue) {
    _token = newValue;
    print("logon here now");
    print(_token);

    notifyListeners();
  }

  Future<bool> accounts(String username) async {
    try {
      _account = await _restdataService.getloggedin(username);

      print("account -");
      print(account?.notifyCount);
      driverSet(_token, _account?.email ?? '');
      notifyListeners();
      return true;
    } catch (e) {
      print("createaccount.dart error in accounts notifier");
      return false;
    }
  }

  void driverSet(String token, String email) async {
    _drivers = await _restdataService.driverget(token, email);

    notifyListeners();
  }

  void userNameSet(String newValue) {
    _logOnUsername = newValue;
    print("logon here now");
    print(_logOnUsername);

    notifyListeners();
  }

  // set prevSearchTerm(String newValue) {
  //   _prevSearchTerm = newValue;
  // }
}
