import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/mywidgets/elliptical_widget.dart';
import 'package:trivia_fun/mywidgets/elliptical2_widget.dart';
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trivia_fun/mywidgets/polkadots_card_canvas.dart';
import 'package:trivia_fun/mywidgets/utility_widgets.dart';
import 'package:trivia_fun/routes.dart';
import 'package:trivia_fun/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:trivia_fun/screens/dashboard/bloc/dashboard_event.dart';
import 'package:trivia_fun/screens/dashboard/bloc/dashboard_state.dart';
import 'package:trivia_fun/screens/singleplayer_choose.dart';
import 'package:trivia_fun/screens/profile.dart';
import 'package:trivia_fun/screens/play_single_game.dart';
import 'package:trivia_fun/mywidgets/custom_dialog2.dart';
import 'package:trivia_fun/utils/strings.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _dialogTitle = 'Alert';
  String _dialogDesc = 'Not enough questions in this category, try other.';
  String _dialogButtonText = 'Okay';
  DashboardBloc _dashboardBloc;

  @override
  void initState() {
    _dashboardBloc = DashboardBloc();
    _dashboardBloc.add(DashboardInitialEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _dashboardBloc.close();
  }

  _showDialog() {
    // return object of type Dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "$_dialogTitle",
        description: "$_dialogDesc",
        buttonText: "$_dialogButtonText",
      ),
    );
  }

  _showInstructionsDialog(String mssg1) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog2(
        title: 'Game Rules',
        description: Strings.guidelines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double cheight = MediaQuery.of(context).size.height;
    double cwidth = MediaQuery.of(context).size.width;

    return BlocProvider<DashboardBloc>(
        create: (BuildContext context) => _dashboardBloc,
        child: BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
          if (state.navigateToPlayGameScreen) {
            Navigator.of(context)
                .pushNamed(Routes.playGame)
                .then((value) => _dashboardBloc.add(DashboardInitialEvent()));
          }
          if (state.navigateToProfileScreen) {
            Navigator.of(context).pushNamed(Routes.profile);
          }
          if (state.errorMessage != null && state.errorMessage != '') {
            UtilityWidgets.showSnackBar(context, state.errorMessage);
            _dashboardBloc.add(DashboardErrorClearEvent());
          }
        }, child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (BuildContext context, DashboardState state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellowAccent,
              ),
            );
          } else {
            return SafeArea(
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: cheight,
                      width: cwidth,
                      color: Color(0xff1D2951),
                    ),
                    EllipticalWidget(),
                    Elliptical2Widget(),
                    Container(
                      margin: EdgeInsets.only(top: cheight * 0.8),
                      width: cwidth,
                      child: PolkadotsCanvas(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: cheight * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.timer);
                                  },
                                  child: Image.asset(
                                    'user_avatar2.png',
                                    height: cheight * 0.06,
                                    width: cheight * .06,
                                  ),
                                ),
                                /*Positioned(
                            right: -1,
                              bottom: 1,
                              child: Icon(Icons.edit, color: Colors.white,)
                          )*/
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            state.username ?? '',
                            style: TextStyle(
                                fontSize: cheight * 0.025,
                                color: Colors.white,
                                fontFamily: 'Poweto'),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: cwidth * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg: "These are your total coins",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.blueGrey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset('coin3.png',
                                          height: cheight * 0.05,
                                          width: cheight * 0.05),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        state.coins,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'Poweto'),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg: "Number of games played by you",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.blueGrey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset('badge.png',
                                          height: cheight * 0.05,
                                          width: cheight * 0.05),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        state.experiencePoints,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'Poweto'),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Percentage of questions you have answered correctly",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.blueGrey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Image.asset('percentage.png',
                                          height: cheight * 0.04,
                                          width: cheight * 0.04),
                                      SizedBox(height: 5),
                                      Text(
                                        state.percentage ?? '0',
                                        style: TextStyle(
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'Poweto'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 60,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            print("Tap clicked");
                            _dashboardBloc.add(DashboardToProfileScreenEvent());
                          },
                          child: Image.asset(
                            'menu.png',
                            color: Colors.white70,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 30,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            _showInstructionsDialog("mssg");
                          },
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white60,
                              child: Center(
                                child: Text(
                                  "?",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: cheight * 0.35,
                          left: cwidth * 0.07,
                          right: cwidth * 0.07),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 6.0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Container(
                                height: cheight * 0.22,
                                width: cwidth * 0.86,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  color: Colors.pink,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    PolkadotsCardCanvas(Colors.pinkAccent),
                                    Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Text(
                                            "Subject-wise Game",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontFamily: 'PoppinsRegular'),
                                          ),
                                          SizedBox(height: 16),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: cwidth * 0.04),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 5,
                                                  width: cwidth * 0.3,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                                SizedBox(width: 15),
                                                Container(
                                                  height: 7,
                                                  width: 7,
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      shape: BoxShape.circle),
                                                ),
                                                SizedBox(width: 15),
                                                Container(
                                                  height: 5,
                                                  width: cwidth * 0.3,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: cwidth * 0.16),
                                            child: Container(
                                              height: 5,
                                              width: cwidth * 0.7,
                                              decoration: BoxDecoration(
                                                  color: Colors.white38,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                            ),
                                          ),
                                          SizedBox(height: cheight * 0.03),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: cwidth * 0.04),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    "Played " +
                                                            state.randomGames ??
                                                        '0' + " games",
                                                    style: TextStyle(
                                                        fontSize:
                                                            cheight * 0.022,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'PoppinsRegular'),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  height: 40,
                                                  width: 2,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute<void>(
                                                          builder: (BuildContext
                                                              context) {
                                                            return SinglePlayerChoose();
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 80,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          16))),
                                                      child: Center(
                                                        child: Text(
                                                          "Choose",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  cheight *
                                                                      0.023,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'PoppinsRegular'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: cheight * 0.06,
                          ),
                          Card(
                            elevation: 6.0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Container(
                                height: cheight * 0.22,
                                width: cwidth * 0.86,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  color: Colors.cyan,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    PolkadotsCardCanvas(Colors.cyanAccent),
                                    Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Text(
                                            "Random Game",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontFamily: 'PoppinsRegular'),
                                          ),
                                          SizedBox(height: 16),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: cwidth * 0.04),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 5,
                                                  width: cwidth * 0.3,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                                SizedBox(width: 15),
                                                Container(
                                                  height: 7,
                                                  width: 7,
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      shape: BoxShape.circle),
                                                ),
                                                SizedBox(width: 15),
                                                Container(
                                                  height: 5,
                                                  width: cwidth * 0.3,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: cwidth * 0.16),
                                            child: Container(
                                              height: 5,
                                              width: cwidth * 0.7,
                                              decoration: BoxDecoration(
                                                  color: Colors.white38,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                            ),
                                          ),
                                          SizedBox(height: cheight * 0.03),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: cwidth * 0.04),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    "Played " +
                                                            state
                                                                .subjectWiseGames ??
                                                        '0' + " games",
                                                    style: TextStyle(
                                                        fontSize:
                                                            cheight * 0.022,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'PoppinsRegular'),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  height: 40,
                                                  width: 2,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _dashboardBloc.add(
                                                          DashboardToCategoryScreenEvent());
                                                    },
                                                    child: Container(
                                                      width: 80,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          16))),
                                                      child: Center(
                                                        child: Text(
                                                          "Start",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  cheight *
                                                                      0.023,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'PoppinsRegular'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        })));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => Profile(),
      transitionDuration: Duration(milliseconds: 1000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
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

  Route _createRoute2() {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => PlaySingleGame(),
      transitionDuration: Duration(milliseconds: 1000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
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
