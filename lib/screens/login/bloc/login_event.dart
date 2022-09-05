import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {}

class LoginLoadingEvent extends LoginEvent {
  LoginLoadingEvent();

  @override
  List<Object> get props => [];
}

class LoginUserNameTypingEvent extends LoginEvent {
  LoginUserNameTypingEvent({@required this.userName});

  final String userName;

  @override
  List<Object> get props => [userName];
}

class UserNameSubmitEvent extends LoginEvent {
  UserNameSubmitEvent({@required this.userName});

  final String userName;

  @override
  List<Object> get props => [userName];
}

class LoginErrorEvent extends LoginEvent {
  LoginErrorEvent({@required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
