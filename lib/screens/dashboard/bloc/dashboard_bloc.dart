import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/models/quizquestion_model.dart';
import 'package:trivia_fun/screens/dashboard/bloc/dashboard_event.dart';
import 'package:trivia_fun/screens/dashboard/bloc/dashboard_state.dart';
import 'package:trivia_fun/services/api_manager.dart';
import 'package:trivia_fun/utils/database_helper.dart';
import 'package:trivia_fun/utils/helper_functions.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final API_Manager _apiM = API_Manager();
  final DatabaseHelper database = DatabaseHelper.db;

  DashboardBloc() : super(DashboardInitialState()) {
    on<DashboardEvent>((event, emit) async {
      if (event is DashboardInitialEvent) {
        try {
          Map<String, String> userData = await getUserData();
          emit(DashboardLoadedState(
              username: userData['username'],
              coins: userData['coins'],
              experiencePoints: userData['experiencePoints'],
              percentage: userData['percentage'],
              subjectWiseGames: userData['subjectWiseGames'],
              randomGames: userData['randomGames']));
        } catch (e) {
          emit(DashboardErrorState(e.toString()));
        }
      } else if (event is DashboardLoadingEvent) {
        emit(DashboardLoadingState());
      } else if (event is DashboardToCategoryScreenEvent) {
        try {
          bool isConnected = false;
          await checkNetworkConnection().then((value) {
            isConnected = value;
          });
          if (isConnected) {
            emit(DashboardLoadingState());
            var response = await getQuestions();
            if (response) {
              emit(DashboardToCategoryScreenState());
            } else {
              emit(DashboardErrorState(response));
            }
          } else {
            emit(DashboardErrorState('Internet not available'));
          }
        } catch (e) {
          emit(DashboardErrorState(e.toString()));
        }
      } else if (event is DashboardToProfileScreenEvent) {
        emit(DashboardToProfileScreenState());
      } else {
        emit(DashboardErrorState('Something went wrong!'));
      }
    });
  }

  Future<Map<String, String>> getUserData() async {
    String uname = await SharedpreferencesHelper.getUserName();
    String coins = await SharedpreferencesHelper.getCoins();
    String exp = await SharedpreferencesHelper.getExppoints();
    String perc = await SharedpreferencesHelper.getPercentage();
    String sGNum = await SharedpreferencesHelper.getSubjectwiseGames();
    String rGNum = await SharedpreferencesHelper.getRandomGames();

    return {
      'uername': uname,
      'coins': coins,
      'experiencePoints': exp,
      'percentage': perc,
      'subjectWiseGames': sGNum,
      'randomGames': rGNum
    };
  }

  Future<dynamic> getQuestions() async {
    String uid = await SharedpreferencesHelper.getUserId();
    List<QuizQuestionModel> _quesList = [];
    var qResponse = await _apiM.getCatwiseQuestions(uid, '1');
    QuizQuestionModel qModel;

    if (qResponse is List<QuizQuestionModel>) {
      _quesList = qResponse;
      int numOfQues = _quesList.length;
      if (numOfQues > 0) {
        await database.deleteAll();
        for (int i = 0; i < numOfQues; i++) {
          qModel = _quesList[i];
          await database.insert(qModel);
        }
        await SharedpreferencesHelper.setCatId('1');
        await SharedpreferencesHelper.setCatQtime('10');
        await SharedpreferencesHelper.setCatCoins('10');
        await SharedpreferencesHelper.setCatExpPoints('10');
        await SharedpreferencesHelper.setSubOrRan('random');
        return true;
      } else {
        return 'No questions available';
      }
    } else {
      return qResponse.toString();
    }
  }
}
