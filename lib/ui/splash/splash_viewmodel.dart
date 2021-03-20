import 'package:alcohol_collection/service/navigation.dart';
import 'package:alcohol_collection/ui/root/root_view.dart';
import 'package:stacked/stacked.dart';

import '../../service_locator.dart';

class SplashViewModel extends BaseViewModel {
  void initialize() async {
    await Future.delayed(Duration(seconds: 1));
    servicesLocator<NavigationService>()
        .pushNamedAndRemoveUntil(routeName: RootView.routeName);
  }
}
