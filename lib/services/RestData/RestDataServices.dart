import '../../model/account.dart';
import '../../model/driver.dart';
import '../../model/notifications.dart';
import '../../model/pickorders.dart';

abstract class RestDataService {
  Future<String> login(String username, String password);
  Future<Account> accountGet(String username, String password);
  Future<String> createnewaccount({Map body});
  Future<Account> createAccountGet({Map body});
  Future<String> createphone({Map body});
  Future<Account> getloggedin(String username);
  Account getLoggedAccount(String username);
  Future<List<Pickorders>> getorders(String token, {Map body});
  Future<List<Pickorders>> getordersall(String token);
  Future<String> addstatno(String token, int id);
  Future<String> adddriver(String token, int id, String driverid);
  // Future<Pickorders> createpickuporders(String token, {Map body});
  // Future<String> changepassword(String token, {Map body});
  // Future<Account> editprofile(String token, {Map body});
  // Future<Pickorders> pickupprice(String token, {Map body});
  // Future<List<Pickorders>> getorders(String token, {Map body});
  Future<List<Notifications>> getnotify(String token, {Map body});
  Future<Notifications> deleteprofile(String token, {Map body});
  Future<Driver> driverget(String token, String email);
  Future<String> driverstat(String token, String email);
  Future<Account> editPhoto(
      String token, String email, String path, String name);
}
