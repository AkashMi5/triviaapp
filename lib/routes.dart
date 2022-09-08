import 'package:flutter/material.dart';
import 'package:trivia_fun/screens/dashboard/view/dashboard_view.dart';
import 'package:trivia_fun/screens/login/view/login_view.dart';
import 'package:trivia_fun/screens/splash/view/splash_view.dart';

mixin Routes {
  static const String splash = '/';
  static const String login = 'login';
  static const String dashboard = 'dashboard';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
            settings: const RouteSettings(name: splash),
            builder: (BuildContext buildContext) => SplashView());
        break;
      case login:
        return MaterialPageRoute(
            settings: const RouteSettings(name: login),
            builder: (BuildContext buildContext) => LoginView());
        break;
      case dashboard:
        return MaterialPageRoute(
            settings: const RouteSettings(name: splash),
            builder: (BuildContext buildContext) => Dashboard());
    }
  }
}
