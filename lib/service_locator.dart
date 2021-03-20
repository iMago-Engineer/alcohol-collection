import 'package:alcohol_collection/services/firestore.dart';
import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/services/firebase_api.dart';
import 'package:alcohol_collection/services/line_ocr_api.dart';
import 'package:alcohol_collection/services/process_api_response.dart';
import 'package:get_it/get_it.dart';

GetIt servicesLocator = GetIt.instance;

void setupServiceLocator() {
  servicesLocator.registerLazySingleton(() => NavigationService());
  servicesLocator.registerLazySingleton(() => FirebaseAPIService());
  servicesLocator.registerLazySingleton(() => FirestoreService());
  servicesLocator.registerLazySingleton(() => LINEOCRService());
  servicesLocator.registerLazySingleton(() => ProcessAPIService());
}
