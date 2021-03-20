import 'package:alcohol_collection/models/comment.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/services/firestore.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:stacked/stacked.dart';

class AlcoholListViewModel extends BaseViewModel {
  Future<void> loadOcyake() async {
    setBusy(true);

    _ocyakes = await servicesLocator<FirestoreService>().fetchOcyakes();

    setBusy(false);
    notifyListeners();
  }

  List<Ocyake> get osyakes => _ocyakes;
  List<Ocyake> _ocyakes = [];

  List<Ocyake> _dummyData = [
    Ocyake(
        name: 'ブラックニッカ',
        type: 'ウイスキー',
        alcohol: 37,
        madeIn: '日本',
        likes: 1,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAoctK6ARFsOmMtDLq9lLj8bIP6hzsI6Ro_eNldR8IQgr6nynAA65B0swMSYqUUWhxpG8Al9E1&usqp=CAc',
        comments: [Comment(postedAt: DateTime.now(), content: '不味すぎワロタ')]),
    Ocyake(
        name: 'ブラックニッカ',
        type: 'ウイスキー',
        alcohol: 37,
        madeIn: '日本',
        likes: 1,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAoctK6ARFsOmMtDLq9lLj8bIP6hzsI6Ro_eNldR8IQgr6nynAA65B0swMSYqUUWhxpG8Al9E1&usqp=CAc',
        comments: [Comment(postedAt: DateTime.now(), content: '不味すぎワロタ')])
  ];
}
