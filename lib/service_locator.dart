import 'package:alcohol_correction/service/navigation.dart';
import 'package:get_it/get_it.dart';

GetIt servicesLocator = GetIt.instance;

void setupServiceLocator() {
  servicesLocator.registerLazySingleton(() => NavigationService());
}
