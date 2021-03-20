import 'package:stacked/stacked.dart';

class AlcoholListViewModel extends BaseViewModel {
  Future<void> loadOcyake() async {
    setBusy(true);

    /// [todo]
    /// get data from firebase
    await Future.delayed(Duration(seconds: 1));
    setBusy(false);
    notifyListeners();
  }
}
