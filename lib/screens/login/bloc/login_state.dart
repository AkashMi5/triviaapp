import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/models/user_login.dart';

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  LoginInitialState({@required this.userName});

  final String userName;

  @override
  List<Object> get props => [userName];
}

class LoginLoadingState extends LoginState {
  LoginLoadingState();

  @override
  List<Object> get props => [];
}

class LoginDataSubmittedState extends LoginState {
  LoginDataSubmittedState({@required this.message, @required this.userLogin});

  final String message;
  final UserLogin userLogin;

  @override
  List<Object> get props => [message, userLogin];
}

class LoginUserNameUpdateState extends LoginState {
  LoginUserNameUpdateState({@required this.userName});

  final String userName;

  @override
  List<Object> get props => [userName];
}

class LoginErrorState extends LoginState {
  LoginErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
