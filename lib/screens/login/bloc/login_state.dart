import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  LoginInitialState();

  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {
  LoginLoadingState();

  @override
  List<Object> get props => [];
}

class LoginLoadedState extends LoginState {
  LoginLoadedState();

  @override
  List<Object> get props => [];
}

class LoginErrorState extends LoginState {
  LoginErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
