import '../../model/ChatMessage.dart';
import '../../model/account.dart';
import '../../model/chatusers.dart';
import '../../model/driver.dart';
import '../../model/notifications.dart';
import '../../model/pickorders.dart';
import '../../model/stats.dart';
import '../../model/statsprice.dart';

abstract class RestDataService {
  Future<String> login(String username, String password);
  Future<Account> accountGet(String username, String password);
  Future<String> createNewAccount({Map body});
  Future<Account> createAccountGet({Map body});
  Future<String> createphone({Map body});
  Future<Account> getloggedin(String username);
  Account getloggedaccount(String username);
  Future<List<Pickorders>> getOrders(String token, {Map body});
  Future<List<Pickorders>> getOrdersAll(String token);
  Future<String> addStatNo(String token, int id);
  Future<String> adddriver(String token, int id, String driverid);
  // Future<Pickorders> createpickuporders(String token, {Map body});
  // Future<String> changepassword(String token, {Map body});
  // Future<Account> editprofile(String token, {Map body});
  // Future<Pickorders> pickupprice(String token, {Map body});
  // Future<List<Pickorders>> getorders(String token, {Map body});
  Future<List<Notifications>> getNotify(String token, {Map body});
  Future<Notifications> deleteprofile(String token, {Map body});
  Future<List<Driver>> getAllDrivers(String token, {Map body});
  Future<Stats> getStats(String token);
  Future<Statsprice> getStatsPrice(String token);
  Future<Account> editPhoto(
      String token, String email, String path, String name);

  Future<List<ChatMessage>> getMessage(String token, String url, {Map body});
  Future<List<ChatUsers>> getChatsUSers(String token, {Map body});
}
