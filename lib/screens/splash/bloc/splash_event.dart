import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SplashEvent extends Equatable {}

class SplashLoadingEvent extends SplashEvent {
  SplashLoadingEvent();

  @override
  List<Object> get props => [];
}

class SplashGetUserStatusEvent extends SplashEvent {
  SplashGetUserStatusEvent();

  @override
  List<Object> get props => [];
}

class SplashNavigateToOtherScreenEvent extends SplashEvent {
  SplashNavigateToOtherScreenEvent({@required this.isUserLoggedin});

  final bool isUserLoggedin;

  @override
  List<Object> get props => [isUserLoggedin];
}
