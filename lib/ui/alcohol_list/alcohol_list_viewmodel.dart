import 'dart:math';

import 'package:alcohol_collection/models/comment.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/services/firestore.dart';
import 'package:alcohol_collection/service_locator.dart';
import 'package:alcohol_collection/services/navigation.dart';
import 'package:alcohol_collection/ui/root/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
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

  var parser = EmojiParser();

  get emoji => parser.emojify(':${emojiShortNames[2]}:');

  static const List<String> emojiShortNames = [
    'sparkles',
    'boom',
    'beers',
    'beer',
    'cocktails',
    'sake',
    'zany_face'
  ];

  String _commentInput = '';

  void setCommentInput(String value) {
    _commentInput = value;

    notifyListeners();
  }

  Future<void> sendComment(Ocyake ocyake) async {
    final draftComment = Comment(
      postedAt: DateTime.now(),
      content: _commentInput,
    );

    await servicesLocator<FirestoreService>()
        .postOcyakeComment(ocyake, draftComment);

    await servicesLocator<NavigationService>()
        .pushAndReplace(routeName: RootView.routeName);
  }

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
