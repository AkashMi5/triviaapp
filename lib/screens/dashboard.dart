import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trivia_fun/mywidgets/elliptical_widget.dart';
import 'package:trivia_fun/mywidgets/elliptical2_widget.dart';
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trivia_fun/mywidgets/polkadots_card_canvas.dart';
import 'package:trivia_fun/screens/singleplayer_choose.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';
import 'package:trivia_fun/screens/profile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';
import 'package:trivia_fun/models/quizquestion_model.dart';
import 'package:trivia_fun/services/api_manager.dart';
import 'package:trivia_fun/utils/database_helper.dart';
import 'package:trivia_fun/screens/play_single_game.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _userName = '';
  String _coins = '0';
  String _expPoints = '0';
  String _perc = '0';
  String _sGamesNum = '0';
  String _rGamesNum = '0';
  API_Manager _apiM = API_Manager();
  ProgressDialog pr;
  List<QuizQuestionModel> _quesList = [];
  final DatabaseHelper database = DatabaseHelper.db;
  String _errorMssg = '';
  String _dialogTitle = 'Alert';
  String _dialogDesc = 'Not enough questions in this category, try other.';
  String _dialogButtonText = 'Okay';

  String mssg =
      "i) There are 2 modes to play the game: 1. Subject-wise 2. Random  \n \n"
      "ii) You can check experience points and coins for subjects while choosing them before the start of the game \n \n \n"
      "iii)	Random category will have 5 questions in each game and each question will have 10 seconds to answer. \n \n"
      "iv) Each random game will have 50 experience points and each correct answer will fetch you 10 coins. \n \n "
      "v)	If you exit the game in between you will not get any experience points or coins. \n \n"
      "vi) Each completed game will add to your cumulative score and thus improve your global rank \n \n"
      "vii) Cumulative score is arrived at by adding your coins and experience earned till now multiplied by your percentage of correct answers \n \n";

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    String uname = await SharedpreferencesHelper.getUserName();
    String coins = await SharedpreferencesHelper.getCoins();
    String exp = await SharedpreferencesHelper.getExppoints();
    String perc = await SharedpreferencesHelper.getPercentage();
    String sGNum = await SharedpreferencesHelper.getSubjectwiseGames();
    String rGNum = await SharedpreferencesHelper.getRandomGames();
    setState(() {
      _userName = uname;
      _coins = coins;
      _expPoints = exp;
      _perc = perc;
      _sGamesNum = sGNum;
      _rGamesNum = rGNum;
    });
    print("This is the username: $_userName");
  }

  getQuestions() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Getting data..',
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

    String uid = await SharedpreferencesHelper.getUserId();

    var qresponse = await _apiM.getCatwiseQuestions(uid, '1');

    QuizQuestionModel qModel;

    if (qresponse is List<QuizQuestionModel>) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      _quesList = qresponse;
      int numOfQues = _quesList.length;
      if (numOfQues > 0) {
        await database.deleteAll();
        for (int i = 0; i < numOfQues; i++) {
          qModel = _quesList[i];
          int id = await database.insert(qModel);
          print("Success");
        }
        await SharedpreferencesHelper.setCatId('1');
        await SharedpreferencesHelper.setCatQtime('10');
        await SharedpreferencesHelper.setCatCoins('10');
        await SharedpreferencesHelper.setCatExpPoints('10');
        await SharedpreferencesHelper.setSubOrRan('random');
        Navigator.of(context).push(_createRoute2());
      } else {
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        print('No questions received for this category');
      }
    } else if (qresponse is String) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      if (qresponse == 'No questions available for this category') {
        _showDialog();
      }
      print('No questions received for this category');
    } else if (qresponse is Exception) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print("Exception has occured");
      _errorMssg = qresponse.toString();
      print(qresponse);
    } else {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print("Some error occured");
      print(qresponse.toString());
    }
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
        description: mssg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double cheight = MediaQuery.of(context).size.height;
    double cwidth = MediaQuery.of(context).size.width;

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
                        Image.asset(
                          'user_avatar2.png',
                          height: cheight * 0.06,
                          width: cheight * .06,
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
                    _userName,
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
                                _coins,
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
                                _expPoints,
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
                                _perc,
                                style: TextStyle(
                                    textBaseline: TextBaseline.alphabetic,
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
                    Navigator.of(context).push(_createRoute());
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                          borderRadius: BorderRadius.all(Radius.circular(24)),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
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
                                          borderRadius: BorderRadius.all(
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
                                            "Played " + _sGamesNum + " games",
                                            style: TextStyle(
                                                fontSize: cheight * 0.022,
                                                color: Colors.white,
                                                fontFamily: 'PoppinsRegular'),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          height: 40,
                                          width: 2,
                                          decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) {
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
                                                          Radius.circular(16))),
                                              child: Center(
                                                child: Text(
                                                  "Choose",
                                                  style: TextStyle(
                                                      fontSize: cheight * 0.023,
                                                      color: Colors.white,
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
                          borderRadius: BorderRadius.all(Radius.circular(24)),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
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
                                          borderRadius: BorderRadius.all(
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
                                            "Played " + _rGamesNum + " games",
                                            style: TextStyle(
                                                fontSize: cheight * 0.022,
                                                color: Colors.white,
                                                fontFamily: 'PoppinsRegular'),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          height: 40,
                                          width: 2,
                                          decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              getQuestions();
                                            },
                                            child: Container(
                                              width: 80,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16))),
                                              child: Center(
                                                child: Text(
                                                  "Start",
                                                  style: TextStyle(
                                                      fontSize: cheight * 0.023,
                                                      color: Colors.white,
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

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double cheight = MediaQuery.of(context).size.height;
    double cwidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.cyan,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20.0,
                offset: const Offset(0.0, 20.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 36.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.black87,
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text("Ok", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /*   Positioned(
          left: 1,
          right:1,
          child: CircleAvatar(
            child: ClipRRect(
              borderRadius:BorderRadius.circular(Consts.avatarRadius) ,                    // BorderRadius.circular(50),
              child: Image.asset("images/quizlogo2.png"),
            ),
            //  backgroundImage: AssetImage('images/quizlogo2.png'),
            // backgroundColor: Colors.blueAccent,
            radius: Consts.avatarRadius,
          ),
        ),*/
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 20.0;
  static const double avatarRadius = 40.0;
}

class CustomDialog2 extends StatelessWidget {
  final String title, description;

  CustomDialog2({
    @required this.title,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(
                  top: Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding,
                ),
                margin: EdgeInsets.only(top: Consts.avatarRadius),
                decoration: new BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 20.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    SizedBox(height: 12.0),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    )
                  ],
                )),
            Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                top: 20,
                child: PolkadotsCardCanvas(Colors.white38))
          ],
        )
      ]),
    );
  }
}
