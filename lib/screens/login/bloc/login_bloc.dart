import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/screens/login/bloc/login_event.dart';
import 'package:trivia_fun/screens/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginEvent>((event, emit) async {
      try {
        if (event is CheckLoginStatusEvent) {
        } else if (event is UserLoginEvent) {}
      } catch (e) {}
    });
  }
}
