import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/ui/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await DotEnv.load(fileName: ".env");
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = ThemeData(
        primaryColor: Color(0xff1DB954),
        accentColor: Color(0xff191414),
        visualDensity: VisualDensity.adaptivePlatformDensity);

    final materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: 'alcohol collection',
      navigatorKey: servicesLocator<NavigationService>().navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: SplashView.routeName,
    );
    return materialApp;
  }
}
