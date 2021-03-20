import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../service_locator.dart';
import 'navigation.dart';

/// 画面の下方にメッセージを一定時間表示するサービス
///
/// 表示されるメッセージとその箱を Snackbar というらしい
///
/// static 関数で機能を提供している かつ サービスの初期化がない
/// ので、servicesLocator に登録しない
class SnackbarService {
  /// - `backgroundColor` (default): `primaryColor`
  /// - `duration` (default): `Duration(seconds: 3)`
  static void showSnackBar({
    @required String content,
    Color backgroundColor,
    Duration duration,
  }) {
    final currentContext = servicesLocator<NavigationService>().currentContext;

    Flushbar(
      message: '$content',
      backgroundColor: backgroundColor ?? Theme.of(currentContext).primaryColor,
      maxWidth: MediaQuery.of(currentContext).size.width * 0.8,
      margin: EdgeInsets.all(8),
      borderRadius: 8.0,
      duration: duration ?? Duration(seconds: 3),
    )..show(currentContext);
  }
}
