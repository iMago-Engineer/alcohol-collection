import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = ThemeData(
      primaryColor: Color(0xff6DD86),
      accentColor: Color(0xff405E79),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: 'alcohol collection',
      // navigatorKey: servicesLocator<NavigationService>().navigatorKey,
      // navigatorObservers: [
      //   servicesLocator<AnalyticsService>().getAnalyticsObserver()
      // ],
      // onGenerateRoute: NavigationService.generateRoute,
      // initialRoute: StartUpView.routeName,
    );
    return materialApp;
  }
}
