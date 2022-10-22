import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/screens/splash/bloc/splash_event.dart';
import 'package:trivia_fun/screens/splash/bloc/splash_state.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashLoadingState()) {
    on((event, emit) async {
      try {
        if (event is SplashLoadingEvent) {
          emit(SplashLoadingState());
          try {
            await initPlatformState();
            await isUserLoggedin();
          } catch (e) {
            emit(SplashErrorState(e.toString()));
          }
        } else if (event is SplashNavigateToOtherScreenEvent) {
          emit(SplashNavigateToOtherScreenState(
              isUserLoggedin: event.isUserLoggedin));
        } else {
          emit(SplashErrorState('Something went wrong!'));
        }
      } catch (e) {
        emit(SplashErrorState(e.toString()));
      }
    });
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String deviceName = '';
    String deviceVersion = '';
    String identifier = '';

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
        await SharedpreferencesHelper.setDeviceId(identifier);
      } else if (Platform.isIOS) {
        // todo
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  isUserLoggedin() async {
    bool userIdExists = await SharedpreferencesHelper.checkUserIdKey();
    if (userIdExists) {
      String uid = await SharedpreferencesHelper.getUserId();
      print("User id is " + uid);
      if (uid != null || uid != '') {
        add(SplashNavigateToOtherScreenEvent(isUserLoggedin: true));
      } else {
        add(SplashNavigateToOtherScreenEvent(isUserLoggedin: false));
      }
    } else {
      add(SplashNavigateToOtherScreenEvent(isUserLoggedin: false));
    }
  }
}
