import 'package:flutter/material.dart';
import 'package:trivia_fun/routes.dart';
import 'package:trivia_fun/screens/splash/bloc/splash_bloc.dart';
import 'package:trivia_fun/screens/splash/bloc/splash_event.dart';
import 'package:trivia_fun/screens/splash/bloc/splash_state.dart';
import 'package:trivia_fun/services/push_notification_service.dart';
import 'package:trivia_fun/utils/helper_functions.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/mywidgets/functional_widgets.dart';
import 'package:trivia_fun/mywidgets/utility_widgets.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  PushNotificationService pushNotificationService;
  @override
  void initState() {
    pushNotificationService = PushNotificationService();
    pushNotificationService.firbaseInitialize();
    initialization();
    super.initState();
  }

  void initialization() {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    setDeviceOrientationPortraitOnly();
    return Scaffold(
      body: Material(
        child: BlocProvider<SplashBloc>(
            create: (BuildContext context) =>
                SplashBloc()..add(SplashLoadingEvent()),
            child: BlocListener<SplashBloc, SplashState>(
              listener: (context, state) {
                if (state is SplashNavigateToOtherScreenState) {
                  if (state.isUserLoggedin) {
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.dashboard);
                  } else {
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  }
                } else if (state is SplashErrorState) {
                  UtilityWidgets.showSnackBar(context, state.errorMessage);
                }
              },
              child: BlocBuilder<SplashBloc, SplashState>(
                builder: (BuildContext context, SplashState state) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFF9CA36),
                            const Color(0xFFF8B830)
                          ],
                          tileMode: TileMode.repeated),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Image.asset(
                                  'trivia_logo.png',
                                  color: Colors.white70,
                                  height: 190,
                                  width: 190,
                                ),
                              ),
                              SizedBox(height: 40),
                              if (state is SplashLoadingState)
                                CircularProgressIndicator(color: Colors.white70)
                              else if (state is SplashErrorState)
                                TryAgainButton(
                                    onButtonPress: () =>
                                        BlocProvider.of<SplashBloc>(context)
                                          ..add(SplashLoadingEvent()))
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Text(
                              "Avenir Technosys LLP",
                              style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NunitoSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
