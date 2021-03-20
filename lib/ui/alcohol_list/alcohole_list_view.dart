import 'package:alcohol_collection/models/comment.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:stacked/stacked.dart';

class AlcoholListViewModel extends BaseViewModel {
  Future<void> loadOcyake() async {
    setBusy(true);

    /// [todo]
    /// get data from firebase
    await Future.delayed(Duration(seconds: 1));
    _ocyakes = _dummyData;
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
        comments: [
          Comment(postedAt: DateTime.now(), content: '不味すぎワロタ'),
          Comment(postedAt: DateTime.now(), content: '不味すぎワロタ'),
          Comment(postedAt: DateTime.now(), content: '不味すぎワロタ')
        ]),
    Ocyake(
        name: 'ブラックニッカ',
        type: 'ウイスキー',
        alcohol: 37,
        madeIn: '日本',
        likes: 1,
        comments: [Comment(postedAt: DateTime.now(), content: '不味すぎワロタ')])
  ];
}
