// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:trivia_fun/models/user_login.dart';
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart';
import 'dart:async';
import 'package:trivia_fun/screens/win_screen.dart';
import 'package:trivia_fun/utils/database_helper.dart';
import 'package:trivia_fun/models/quizquestion_model.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';
import 'package:trivia_fun/screens/win_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:trivia_fun/services/api_manager.dart';
import 'package:trivia_fun/utils/constants.dart';

class PlaySingleGame extends StatefulWidget {
  @override
  _PlaySingleGameState createState() => _PlaySingleGameState();
}

class _PlaySingleGameState extends State<PlaySingleGame> {
  double _animatedWidth = 5;
  double cheight = 10;
  double cwidth = 10;
  Timer _timer;
  int _qTime = 10;
  DatabaseHelper database = DatabaseHelper.db;
  List<QuizQuestionModel> _qList;
  QuizQuestionModel _currentQ;
  int _currentQNum = 1;
  String _qText = "";
  String opA = "";
  String opB = "";
  String opC = "";
  String opD = "";
  String correctAns;
  bool _answerGiven = false;
  bool _answerIsA = false;
  bool _answerIsB = false;
  bool _answerIsC = false;
  bool _answerIsD = false;
  bool _selectedA = false;
  bool _selectedB = false;
  bool _selectedC = false;
  bool _selectedD = false;
  int numOfQues = 0;
  ProgressDialog pr;
  bool _quesUpdated = false;
  int _numOfCorrect = 0;
  API_Manager _apiM = API_Manager();

  @override
  void initState() {
    startWidth();
    getQuesList().then((_) {
      countDownTimer();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  startWidth() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        _quesUpdated = false;
        _animatedWidth = cwidth * 0.8;
      });
    });
  }

  countDownTimer() {
    Timer(Duration(seconds: 1), () {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (_qTime == 0) {
          _timer.cancel();
          if (_currentQNum == numOfQues) {
            submitGameData().then((_) {
              Navigator.of(context).pushReplacement(_createRoute());
            });
          } else {
            updateQs();
          }
        } else {
          setState(() {
            _qTime = _qTime - 1;
          });
        }
      });
    });
  }

  getQuesList() async {
    _qTime = int.parse(await SharedpreferencesHelper.getCatQtime());

    _qList = await database.getQuizQs();
    numOfQues = _qList.length;

    print("Number of Qs: $numOfQues");

    _currentQ = _qList[0];

    String _qtext = _currentQ.questionText;
    _qText = _qtext.replaceAll("\r\n", "");
    String opa = _currentQ.optA;
    opA = opa.replaceAll("\r\n", "");
    String opb = _currentQ.optB;
    opB = opb.replaceAll("\r\n", "");
    String opc = _currentQ.optC;
    opC = opc.replaceAll("\r\n", "");
    String opd = _currentQ.optD;
    opD = opd.replaceAll("\r\n", "");
    String correctans = _currentQ.answer;
    correctAns = correctans.replaceAll("\r\n", "");

    print("Questions is: $_qText");
    print("Correct option is $correctAns");
    print('Option A: $opA');
  }

  updateQs() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Going to next Qs..',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          child: Image.asset(
              'images/double_ring_loading_io.gif'), // Image.asset('images/1_florian-7gif.gif'),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    await pr.show();

    Timer(Duration(seconds: 2), () async {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      _currentQNum = _currentQNum + 1;

      _currentQ = _qList[_currentQNum - 1];

      String _qtext = _currentQ.questionText;
      _qText = _qtext.replaceAll("\r\n", "");
      String opa = _currentQ.optA;
      opA = opa.replaceAll("\r\n", "");
      String opb = _currentQ.optB;
      opB = opb.replaceAll("\r\n", "");
      String opc = _currentQ.optC;
      opC = opc.replaceAll("\r\n", "");
      String opd = _currentQ.optD;
      opD = opd.replaceAll("\r\n", "");
      String correctans = _currentQ.answer;
      correctAns = correctans.replaceAll("\r\n", "");

      _answerGiven = false;
      _answerIsA = false;
      _answerIsB = false;
      _answerIsC = false;
      _answerIsD = false;
      _selectedA = false;
      _selectedB = false;
      _selectedC = false;
      _selectedD = false;

      _qTime = int.parse(await SharedpreferencesHelper.getCatQtime());

      setState(() {
        _animatedWidth = 5;
        _quesUpdated = true;
        print('Set state method called');
      });

      startWidth();
      countDownTimer();
    });
  }

  _checkAnswer(String answer) {
    _answerGiven = true;
    switch (answer) {
      case ('A'):
        print('Case A ran');
        _selectedA = true;
        if (correctAns == 'A') {
          _numOfCorrect = _numOfCorrect + 1;
          _answerIsA = true;
          print('Case AnswerA : $_answerIsA');
        } else {
          print('Correct Ans is: $correctAns');
        }
        setState(() {});
        break;
      case ('B'):
        print('Case B ran');
        _selectedB = true;
        if (correctAns == 'B') {
          _numOfCorrect = _numOfCorrect + 1;
          _answerIsB = true;
          setState(() {});
          print('Case AnswerB : $_answerIsB');
        } else {
          print('Correct Ans is: $correctAns');
        }
        setState(() {});
        break;
      case ('C'):
        print('Case C ran');
        _selectedC = true;
        if (correctAns == 'C') {
          _numOfCorrect = _numOfCorrect + 1;
          _answerIsC = true;
          setState(() {});
          print('Case AnswerC : $_answerIsC');
        } else {
          print('Correct Ans is: $correctAns');
        }
        setState(() {});
        break;
      case ('D'):
        print('Case D ran');
        _selectedD = true;
        if (correctAns == 'D') {
          _numOfCorrect = _numOfCorrect + 1;
          _answerIsD = true;
          setState(() {});
          print('Case AnswerD : $_answerIsD');
        } else {
          print('Correct Ans is: $correctAns');
        }
        setState(() {});
        break;
    }
  }

  submitGameData() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Getting the game result..',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          child: Image.asset(
              'images/double_ring_loading_io.gif'), // Image.asset('images/1_florian-7gif.gif'),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    await pr.show();

    String userId = await SharedpreferencesHelper.getUserId();
    String _ccoins = await SharedpreferencesHelper.getCatCoins();
    int _iccoins = int.parse(_ccoins);
    String catCoins = (_iccoins * _numOfCorrect).toString();
    String _expp = await SharedpreferencesHelper.getCatExpPoints();
    int _iexpp = int.parse(_expp);
    String catexpPoints = (_iexpp * _numOfCorrect).toString();
    String _subOrRan = await SharedpreferencesHelper.getSubOrRan();

    print('Num of correct Ans ' + _numOfCorrect.toString());
    print('Number of coins won ' + catCoins);
    print('Number of Exp points won ' + catexpPoints);

    var uReponse = await _apiM.submitGame(userId, catCoins, catexpPoints,
        _numOfCorrect.toString(), numOfQues.toString(), _subOrRan);

    if (uReponse is UserLogin) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      UserLogin _uLogin = UserLogin();
      _uLogin = uReponse;

      SharedpreferencesHelper.setCoins(_uLogin.coins);
      SharedpreferencesHelper.setExppoints(_uLogin.expPoints);
      String _perc =
          ((int.parse(_uLogin.correct) / int.parse(_uLogin.attempted)) * (100))
              .toStringAsFixed(1);
      //   String _perc = _percc.substring(0,4);
      SharedpreferencesHelper.setPercentage(_perc);
      SharedpreferencesHelper.setRandomGames(_uLogin.gamesRandom);
      SharedpreferencesHelper.setSubjectwiseGames(_uLogin.gamesSubjectwise);
      SharedpreferencesHelper.setCumulativeScore(_uLogin.cumulativePoints);

      Constants.currentGameCorrectAns = _numOfCorrect;
      Constants.currentGameCoinsWon = int.parse(catCoins);
      Constants.currentGameExpPointsWon = int.parse(catexpPoints);
      Constants.currentGameNumOfQues = numOfQues;

      print('Exp points won ' + Constants.currentGameExpPointsWon.toString());

      String _perccc = await SharedpreferencesHelper.getPercentage();
      print('Percentage is ' + _perccc);
    } else if (uReponse is String) {
      print("Some error occurred");
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    } else if (uReponse is Exception) {
      print("Exception has occured");
      String _errorMssg = uReponse.toString();
      print(uReponse);
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    } else {
      print("Some error occured");
      print(uReponse.toString());
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    cheight = MediaQuery.of(context).size.height;
    cwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: cheight,
            width: cwidth,
            color: Color(0xff1D2951),
          ),
          Container(
            margin: EdgeInsets.only(top: cheight * 0.8),
            width: cwidth,
            child: PolkadotsCanvas(),
          ),
          Padding(
            padding: EdgeInsets.only(top: cheight * 0.06),
            child: Center(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: cwidth * 0.8,
                        height: cheight * 0.06,
                        decoration: BoxDecoration(
                            color: Color(0xff1D2951),
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            border: Border.all(
                                color: Colors.white38.withOpacity(0.2),
                                width: 3)),
                      ),
                      AnimatedContainer(
                        duration: _quesUpdated
                            ? Duration(milliseconds: 100)
                            : Duration(seconds: 10),
                        width: _animatedWidth,
                        height: cheight * 0.06,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0XFFb783ff), Color(0XFFffaebf)]),
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            border: Border.all(
                                color: Colors.white38.withOpacity(0.2),
                                width: 3)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: cwidth * 0.8,
                        height: cheight * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(''),
                            Row(
                              children: <Widget>[
                                Text(
                                  _qTime.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                      fontFamily: 'PoppinsRegular'),
                                ),
                                Text(
                                  " s",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                      fontFamily: 'PoppinsRegular'),
                                )
                              ],
                            ),
                            Icon(
                              Icons.alarm,
                              color: Colors.white54,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: cheight * 0.04),
                  SingleChildScrollView(
                    child: Container(
                        width: cwidth * 0.8,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Question ',
                                  style: TextStyle(
                                      fontSize: cheight * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                      fontFamily: 'PoppinsRegular'),
                                ),
                                Text(
                                  _currentQNum.toString(),
                                  style: TextStyle(
                                      fontSize: cheight * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                      fontFamily: 'PoppinsRegular'),
                                ),
                                Text(
                                  '/',
                                  style: TextStyle(
                                      fontSize: cheight * 0.03,
                                      color: Colors.blueGrey,
                                      fontFamily: 'PoppinsRegular'),
                                ),
                                Text(
                                  numOfQues.toString(),
                                  style: TextStyle(
                                      fontSize: cheight * 0.025,
                                      color: Colors.blueGrey,
                                      fontFamily: 'PoppinsRegular'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 2,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color: Colors.blueGrey.withOpacity(0.2)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                _qText,
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: cheight * 0.022,
                                    color: Colors.white,
                                    fontFamily: 'PoppinsRegular'),
                              ),
                            ),
                            SizedBox(height: cheight * 0.07),
                            InkWell(
                              onTap: () {
                                _answerGiven ? null : _checkAnswer('A');
                              },
                              child: Container(
                                width: cwidth * 0.8,
                                height: cheight * 0.07,
                                decoration: BoxDecoration(
                                    color: Color(0xff1D2951),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                    border: Border.all(
                                        color: Colors.white38.withOpacity(0.2),
                                        width: 3)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          opA,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: cheight * 0.022,
                                              color: Colors.white70,
                                              fontFamily: 'PoppinsRegular'),
                                        ),
                                      ),
                                      _answerGiven && _selectedA
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  /* decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                               color: Color(0xff1D2951),
                                               border: Border.all(width: 2, color: Colors.blueGrey)
                                           ),*/
                                                  child: _answerIsA
                                                      ? Icon(Icons.check_circle,
                                                          color:
                                                              Colors.blueAccent)
                                                      : Icon(
                                                          Icons.remove_circle,
                                                          color: Colors.red)),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xff1D2951),
                                                    border: Border.all(
                                                        width: 2,
                                                        color:
                                                            Colors.blueGrey)),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                _answerGiven ? null : _checkAnswer('B');
                              },
                              child: Container(
                                width: cwidth * 0.8,
                                height: cheight * 0.07,
                                decoration: BoxDecoration(
                                    color: Color(0xff1D2951),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                    border: Border.all(
                                        color: Colors.white38.withOpacity(0.2),
                                        width: 3)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        opB,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: cheight * 0.022,
                                            color: Colors.white70,
                                            fontFamily: 'PoppinsRegular'),
                                      ),
                                    ),
                                    _answerGiven && _selectedB
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                /* decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                               color: Color(0xff1D2951),
                                               border: Border.all(width: 2, color: Colors.blueGrey)
                                           ),*/
                                                child: _answerIsB
                                                    ? Icon(Icons.check_circle,
                                                        color:
                                                            Colors.blueAccent)
                                                    : Icon(Icons.remove_circle,
                                                        color: Colors.red)),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff1D2951),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.blueGrey)),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                _answerGiven ? null : _checkAnswer('C');
                              },
                              child: Container(
                                width: cwidth * 0.8,
                                height: cheight * 0.07,
                                decoration: BoxDecoration(
                                    color: Color(0xff1D2951),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                    border: Border.all(
                                        color: Colors.white38.withOpacity(0.2),
                                        width: 3)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        opC,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: cheight * 0.022,
                                            color: Colors.white70,
                                            fontFamily: 'PoppinsRegular'),
                                      ),
                                    ),
                                    _answerGiven && _selectedC
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                /* decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                               color: Color(0xff1D2951),
                                               border: Border.all(width: 2, color: Colors.blueGrey)
                                           ),*/
                                                child: _answerIsC
                                                    ? Icon(Icons.check_circle,
                                                        color:
                                                            Colors.blueAccent)
                                                    : Icon(Icons.remove_circle,
                                                        color: Colors.red)),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff1D2951),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.blueGrey)),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                _answerGiven ? null : _checkAnswer('D');
                              },
                              child: Container(
                                width: cwidth * 0.8,
                                height: cheight * 0.07,
                                decoration: BoxDecoration(
                                    color: Color(0xff1D2951),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                    border: Border.all(
                                        color: Colors.white38.withOpacity(0.2),
                                        width: 3)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        opD,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: cheight * 0.022,
                                            color: Colors.white70,
                                            fontFamily: 'PoppinsRegular'),
                                      ),
                                    ),
                                    _answerGiven && _selectedD
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                /* decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                               color: Color(0xff1D2951),
                                               border: Border.all(width: 2, color: Colors.blueGrey)
                                           ),*/
                                                child: _answerIsD
                                                    ? Icon(Icons.check_circle,
                                                        color:
                                                            Colors.blueAccent)
                                                    : Icon(Icons.remove_circle,
                                                        color: Colors.red)),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff1D2951),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.blueGrey)),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: cheight * 0.1),

                            /* Card(
                                elevation: 20,
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).pushReplacement(_createRoute()) ;
                                  },
                                  child: Container(
                                    width: cwidth*0.4,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(Radius.circular(24)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'PoppinsRegular'
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )*/
                          ],
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => WinScreen(),
      transitionDuration: Duration(milliseconds: 1000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
