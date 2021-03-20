import 'dart:convert';
import 'dart:math';

import 'package:alcohol_collection/models/comment.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/services/api.dart';
import 'package:alcohol_collection/services/firestore.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/services/snackbar.dart';
import 'package:alcohol_collection/ui/root/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:stacked/stacked.dart';

class AlcoholListViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();
  Future<void> loadOcyake() async {
    setBusy(true);

    _ocyakes = await _firestore.fetchOcyakes();
    // for (var i = 0; i < _ocyakes.length; i++) {
    //   var query = _ocyakes[i].name;
    //   _ocyakes[i].imageUrl = await APIService().getImageFromGoogle(query);
    // }
    setBusy(false);
    notifyListeners();
  }

  List<Ocyake> get osyakes => _ocyakes;
  List<Ocyake> _ocyakes = [];

  /// お気に入り

  void updateRate(Ocyake ocyake, double rating) {
    int newRate = rating.toInt();
    _firestore.updateRate(ocyake, newRate);
  }

  /// コメント入力部

  var parser = EmojiParser();

  get emoji => parser.emojify(':beers:');

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

  String formatDateTime(String dateTime) {
    var splittedDateTime = dateTime.split(':');
    return splittedDateTime[0] + ':' + splittedDateTime[1];
  }

  String _commentInput = '';

  void setCommentInput(String value) {
    _commentInput = value;

    notifyListeners();
  }

  Future<void> sendComment(Ocyake ocyake) async {
    if (_commentInput == '') {
      SnackbarService.showSnackBar(
          content: 'テキストを入力してください', backgroundColor: Colors.redAccent);
    } else {
      final draftComment = Comment(
        postedAt: DateTime.now(),
        content: _commentInput,
      );

      await servicesLocator<FirestoreService>()
          .postOcyakeComment(ocyake, draftComment);

      await servicesLocator<NavigationService>()
          .pushAndReplace(routeName: RootView.routeName);
    }
  }

  /// 画像取得

}
