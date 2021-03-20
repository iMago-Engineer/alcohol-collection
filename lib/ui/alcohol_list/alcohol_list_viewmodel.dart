import 'dart:math';

import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/services/firestore.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:stacked/stacked.dart';

class AlcoholListViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();
  Future<void> loadOcyake() async {
    setBusy(true);

    _ocyakes = await _firestore.fetchOcyakes();

    setBusy(false);
    notifyListeners();
  }

  List<Ocyake> get osyakes => _ocyakes;
  List<Ocyake> _ocyakes = [];

  var parser = EmojiParser();

  get emoji => parser.emojify(':beers:');

  String formatDateTime(String dateTime) {
    var splittedDateTime = dateTime.split(':');
    return splittedDateTime[0] + ':' + splittedDateTime[1];
  }

  void updateRate(Ocyake ocyake, double rating) {
    int newRate = rating.toInt();
    _firestore.updateRate(ocyake, newRate);
  }

  // static const List<String> emojiShortNames = [
  //   'sparkles',
  //   'boom',
  //   'beers',
  //   'beer',
  //   'cocktails',
  //   'sake',
  //   'zany_face'
  // ];

  // List _shuffle(List items) {
  //   var random = new Random();
  //   for (var i = items.length - 1; i > 0; i--) {
  //     var n = random.nextInt(i + 1);
  //     var temp = items[i];
  //     items[i] = items[n];
  //     items[n] = temp;
  //   }
  //   return items;
  // }
}
