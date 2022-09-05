import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SplashState extends Equatable {}

class SplashLoadingState extends SplashState {
  SplashLoadingState();

  List<Object> get props => [];
}

class SplashNavigateToOtherScreenState extends SplashState {
  SplashNavigateToOtherScreenState({@required this.isUserLoggedin});

  final bool isUserLoggedin;

  List<Object> get props => [isUserLoggedin];
}

class SplashErrorState extends SplashState {
  SplashErrorState(this.errorMessage);

  final String errorMessage;

  List<Object> get props => [errorMessage];
}
