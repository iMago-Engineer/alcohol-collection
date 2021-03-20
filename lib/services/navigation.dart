import 'package:alcohol_collection/ui/alcohol_list/alcohol_list_view.dart';
import 'package:alcohol_collection/ui/root/root_view.dart';
import 'package:alcohol_collection/ui/splash/splash_view.dart';
import 'package:flutter/material.dart';

class NavigationService {
  /// Navigator を指定するキー
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// currentContext
  /// - context を navigatorKey から取得する
  BuildContext get currentContext => navigatorKey.currentContext;

  /// currentState
  /// 遷移するための関数の中で navigatorKey.currentState を何回も書いているから、currentState を外に出した
  NavigatorState get currentState => navigatorKey.currentState;

  /// routeName にページ遷移する (push)
  Future<dynamic> pushNamed({@required String routeName, dynamic args}) {
    return currentState.pushNamed(routeName, arguments: args);
  }

  /// routeName にページ遷移する (今の route が上書きされる　)
  Future<dynamic> pushAndReplace({@required String routeName, dynamic args}) {
    return currentState.pushReplacementNamed(routeName, arguments: args);
  }

  /// routeName にページを遷移するけど、今までの遷移記録を残さない
  Future<dynamic> pushNamedAndRemoveUntil(
      {@required String routeName, dynamic args}) {
    return currentState.pushNamedAndRemoveUntil(routeName, (route) => false,
        arguments: args);
  }

  /// 一個前の画面に戻る
  void pop() => navigatorKey.currentState.pop();

  /// 画面遷移
  void push(context) => navigatorKey.currentState.push(context);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashView.routeName:
        return MaterialPageRoute(builder: (_) => SplashView());
        break;
      case RootView.routeName:
        return MaterialPageRoute(builder: (_) => RootView());
        break;
      case AlcoholListView.routeName:
        return MaterialPageRoute(builder: (_) => AlcoholListView());
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                    body: Center(
                  child: Text('探してるページがないよ！！！'),
                )));
        break;
    }
  }
}
