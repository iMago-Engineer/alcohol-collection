import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/ui/root/root_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../service_locator.dart';

class SplashViewModel extends BaseViewModel {
  void initialize() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
        servicesLocator<NavigationService>().currentContext,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => RootView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeUpwardsPageTransitionsBuilder().buildTransitions(
                MaterialPageRoute(builder: (context) => RootView()),
                context,
                animation,
                secondaryAnimation,
                child);
          },
        ),
        (_) => false);
  }
}
