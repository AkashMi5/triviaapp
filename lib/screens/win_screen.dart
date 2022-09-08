import 'package:flutter/material.dart';
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart';
import 'dart:async';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';
import 'package:trivia_fun/screens/dashboard/view/dashboard_view.dart';
import 'package:trivia_fun/utils/constants.dart';

class WinScreen extends StatefulWidget {
  @override
  _WinScreenState createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> {
  double cheight = 10;
  double cwidth = 10;
  double _animatedWidth = 300;
  double _animatedHeight = 300;
  String _userName = '';
  String _correctAns = '0';
  String _coinsWon = '0';
  String _expPointsWon = '0';
  String _numofQues = '0';

  @override
  void initState() {
    startSize();
    getUsername();
    super.initState();
  }

  startSize() {
    Timer(Duration(milliseconds: 300), () {
      setState(() {
        _animatedWidth = cwidth * 0.2;
        _animatedHeight = cheight * 0.2;
      });
    });
  }

  getUsername() async {
    _userName = await SharedpreferencesHelper.getUserName();
    _coinsWon = Constants.currentGameCoinsWon.toString();
    _correctAns = Constants.currentGameCorrectAns.toString();
    _expPointsWon = Constants.currentGameExpPointsWon.toString();
    _numofQues = Constants.currentGameNumOfQues.toString();
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
          SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(top: cheight * 0.06, left: 24, right: 24),
              child: Center(
                child: Column(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: _animatedWidth,
                      height: _animatedHeight,
                      child: Image.asset('trophy.png'),
                    ),
                    SizedBox(height: cheight * 0.02),
                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Hey! ',
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white70,
                                    fontFamily: 'Poweto'),
                              ),
                              Text(
                                '$_userName ',
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white70,
                                    fontFamily: 'Poweto'),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'You scored ',
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontFamily: 'Poweto'),
                              ),
                              Text(
                                _correctAns,
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontFamily: 'Poweto'),
                              ),
                              Text(
                                '/' + _numofQues,
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontFamily: 'Poweto'),
                              ),
                            ],
                          ),
                          SizedBox(height: 36),
                          Text(
                            'You\'ve won',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontFamily: 'Poweto'),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('coin3.png', height: 35, width: 35),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                _coinsWon + ' Coins',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: 'Poweto'),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('badge.png', height: 35, width: 35),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                _expPointsWon + ' Experience points',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: 'Poweto'),
                              )
                            ],
                          ),
                          SizedBox(height: 36),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Card(
                                elevation: 20,
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacement(_createRoute());
                                  },
                                  child: Container(
                                    width: cwidth * 0.4,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Home",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'PoppinsRegular'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]))
                  ],
                ),
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
      pageBuilder: (context, animation, secondaryAnimation) => Dashboard(),
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
