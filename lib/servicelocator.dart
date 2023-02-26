// import 'package:fooddelivery/services/pickup/requestpickup.dart';
// import 'package:fooddelivery/services/pickup/requestpickupImpl.dart';
import 'package:get_it/get_it.dart';
import 'package:owner2/services/RestData/RestDataServices.dart';
import 'package:owner2/viewmodel/createaccount.dart';
import 'package:owner2/viewmodel/orderlistdata.dart';

import 'data/restdata.dart';
// import 'package:fooddelivery/services/account/createaccount.dart';
// import 'package:fooddelivery/services/account/createaccountimpl.dart';
// import '../business_logic/view_models/calculate_screen_viewmodel.dart';
// import '../business_logic/view_models/choose_favorites_viewmodel.dart';

// Using GetIt is a convenient way to provide services and view models
// anywhere we need them in the app.
GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // services
  serviceLocator.registerLazySingleton<RestDataService>(() => RestDataImpl());
  // serviceLocator.registerLazySingleton<CreateAccountServices>(
  //     () => CreateAccountServicesImpl());
  // serviceLocator
  //     .registerLazySingleton<RequestPickup>(() => RequestPickupImpl());
  // serviceLocator
  //     .registerLazySingleton<StorageService>(() => StorageServiceImpl());
  // serviceLocator
  //     .registerLazySingleton<CurrencyService>(() => CurrencyServiceImpl());

  // // You can replace the actual services above with fake implementations during development.
  // //
  // // serviceLocator.registerLazySingleton<WebApi>(() => FakeWebApi());
  // // serviceLocator.registerLazySingleton<StorageService>(() => FakeStorageService());
  // // serviceLocator.registerLazySingleton<CurrencyService>(() => CurrencyServiceFake());

  // // view models
  serviceLocator
      .registerFactory<CreateAccountViewModel>(() => CreateAccountViewModel());
  serviceLocator
      .registerFactory<OrderListDataViewModel>(() => OrderListDataViewModel());
}
