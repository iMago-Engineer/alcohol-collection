import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/services/firebase_api.dart';
import 'package:get_it/get_it.dart';

GetIt servicesLocator = GetIt.instance;

void setupServiceLocator() {
  servicesLocator.registerLazySingleton(() => NavigationService());
  servicesLocator.registerLazySingleton(() => FirebaseAPIService());
}
