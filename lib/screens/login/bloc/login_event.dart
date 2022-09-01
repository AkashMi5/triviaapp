import 'dart:html';
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class CheckLoginStatusEvent extends LoginEvent {
  CheckLoginStatusEvent();

  @override
  List<Object> get props => [];
}

class UserLoginEvent extends LoginEvent {
  UserLoginEvent();

  @override
  List<Object> get props => [];
}
