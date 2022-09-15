import 'package:flutter/material.dart';
import 'package:trivia_fun/screens/dashboard/view/dashboard_view.dart';
import 'package:trivia_fun/screens/login/view/login_view.dart';
import 'package:trivia_fun/screens/play_single_game.dart';
import 'package:trivia_fun/screens/profile.dart';
import 'package:trivia_fun/screens/splash/view/splash_view.dart';

mixin Routes {
  static const String splash = '/';
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String playGame = 'playGame';
  static const String profile = 'profile';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute<SplashView>(
            settings: const RouteSettings(name: splash),
            builder: (BuildContext buildContext) => SplashView());
        break;
      case login:
        return MaterialPageRoute<LoginView>(
            settings: const RouteSettings(name: login),
            builder: (BuildContext buildContext) => LoginView());
        break;
      case dashboard:
        return MaterialPageRoute<Dashboard>(
            settings: const RouteSettings(name: dashboard),
            builder: (BuildContext buildContext) => Dashboard());
        break;
      case playGame:
        return MaterialPageRoute<PlaySingleGame>(
            settings: const RouteSettings(name: playGame),
            builder: (BuildContext context) => PlaySingleGame());
        break;
      case profile:
        return MaterialPageRoute<Profile>(
            settings: const RouteSettings(name: profile),
            builder: (context) => Profile());
    }
  }
}
