import 'package:alcohol_correction/service/navigation.dart';
import 'package:alcohol_correction/service_locator.dart';
import 'package:alcohol_correction/ui/root/root_view.dart';
import 'package:stacked/stacked.dart';

class SplashViewModel extends BaseViewModel {
  void initialize() async {
    await Future.delayed(Duration(seconds: 1));
    servicesLocator<NavigationService>()
        .pushNamedAndRemoveUntil(routeName: RootView.routeName);
  }
}
