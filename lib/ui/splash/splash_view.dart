import 'package:alcohol_collection/ui/splash/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () => SplashViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Scaffold(body: _SplashScreen()),
    );
  }
}

class _SplashScreen extends ViewModelWidget<SplashViewModel> {
  @override
  Widget build(BuildContext context, SplashViewModel model) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Container(
                width: screenSize.width * 0.7,
                child: Image.asset('images/puha-color.png'))));
  }
}
