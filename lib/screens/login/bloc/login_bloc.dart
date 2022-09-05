import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/models/user_login.dart';
import 'package:trivia_fun/screens/login/bloc/login_event.dart';
import 'package:trivia_fun/screens/login/bloc/login_state.dart';
import 'package:trivia_fun/services/api_manager.dart';
import 'package:trivia_fun/utils/helper_functions.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  API_Manager apiM = API_Manager();
  LoginBloc() : super(LoginInitialState(userName: '')) {
    on<LoginEvent>((event, emit) async {
      try {
        if (event is LoginLoadingEvent) {
          emit(LoginLoadingState());
        } else if (event is LoginUserNameTypingEvent) {
          debugPrint('typing ${event.userName}');
          emit(LoginUserNameUpdateState(userName: event.userName));
        } else if (event is UserNameSubmitEvent) {
          emit(LoginLoadingState());
          bool isConnected = false;
          await checkNetworkConnection().then((value) {
            isConnected = value;
          });
          if (isConnected) {
            String userName = event.userName;
            String deviceIdentifier =
                await SharedpreferencesHelper.getDeviceId();
            try {
              var uResponse = await apiM.addUser(userName, deviceIdentifier);
              if (uResponse is UserLogin) {
                await saveUserData(uResponse);
                emit(LoginDataSubmittedState(
                    message: null, userLogin: uResponse));
              } else if (uResponse is String) {
                print('1');
                emit(LoginDataSubmittedState(
                    message: uResponse, userLogin: null));
              } else {
                print('2');
                emit(LoginErrorState('Something went wrong!'));
              }
            } catch (e) {
              emit(LoginErrorState(e.toString()));
            }
          } else {
            emit(LoginErrorState('Internet not available'));
          }
        }
      } catch (e) {
        print('3');
        emit(LoginErrorState(e.toString()));
      }
    });
  }

  saveUserData(UserLogin userData) async {
    String _userId = userData.userId;
    String _coins = userData.coins;
    String _expp = userData.expPoints;
    int _attempted = int.parse(userData.attempted);
    int _correct = int.parse(userData.correct);
    int _subjectGames = int.parse(userData.gamesSubjectwise);
    int _randomGames = int.parse(userData.gamesRandom);
    String _perc = '';

    if (_attempted == 0) {
      _perc = '0.0';
    } else {
      _perc = ((_correct / _attempted) * 100).toStringAsFixed(1);
    }
    await SharedpreferencesHelper.setUserId(_userId);
    await SharedpreferencesHelper.setUserName(userData.username);
    await SharedpreferencesHelper.setCoins(_coins);
    await SharedpreferencesHelper.setExppoints(_expp);
    await SharedpreferencesHelper.setPercentage(_perc);
    await SharedpreferencesHelper.setSubjectwiseGames(_subjectGames.toString());
    await SharedpreferencesHelper.setRandomGames(_randomGames.toString());
    await SharedpreferencesHelper.setCumulativeScore(userData.cumulativePoints);
    await SharedpreferencesHelper.setProfilePic('');
  }
}
