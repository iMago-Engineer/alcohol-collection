import 'package:alcohol_collection/service/navigation.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/ui/splash/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = ThemeData(
      primaryColor: Color(0xFF6DDA86),
      accentColor: Color(0xFF405E79),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

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
