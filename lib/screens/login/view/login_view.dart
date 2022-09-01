import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trivia_fun/services/api_manager.dart';
import 'package:trivia_fun/models/user_login.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:device_info/device_info.dart';
import 'package:trivia_fun/services/local_notification_service.dart';
import 'dart:io';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';
import 'package:trivia_fun/screens/dashboard.dart';
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart';
import 'package:trivia_fun/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _usernameController = TextEditingController();
  String _username;
  bool visibilityOb = true;
  Color color1 = Color(0XFF015DEA);
  Color color2 = Color(0XFF01C4FA);
  API_Manager apiM = API_Manager();
  List<UserLogin> _userList = [];
  List<String> _allUserNames = [];
  ProgressDialog pr;
  String _errorMssg = '';
  bool _isError = false;
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String _dialogTitle = 'Alert';
  String _dialogDesc = 'Username already exists, try with other one!';
  String _dialogButtonText = 'Okay';
  PushNotificationService pushNotificationService;

  @override
  void initState() {
    /* _usernameController.addListener(() {
      setState(() {
        if (_usernameController.text.length < 5  || _allUserNames.contains(_usernameController.text.toLowerCase())) {                                   // || _allUserNames.contains(_usernameController.text.toLowerCase())

          visibilityOb = false ;
          color1 = Color(0XFFD3D3D3);
          color2 = Color(0XFFB4B4B4);
        }
          else {
         visibilityOb ? null : visibilityOb = true ;
         color1 = Color(0XFF015DEA);
         color2 = Color(0XFF01C4FA);
        }
      });
    });*/
    super.initState();

    /* WidgetsBinding.instance
        .addPostFrameCallback((_) =>  getUsernameData());*/
  }

  addUserName() async {
    String username = _usernameController.text;

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
    var uResposne = await apiM.addUser(username, identifier);

    if (uResposne is UserLogin) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      UserLogin _userdata = uResposne;

      String _userId = _userdata.userId;
      String _coins = _userdata.coins;
      String _expp = _userdata.expPoints;
      int _attempted = int.parse(_userdata.attempted);
      int _correct = int.parse(_userdata.correct);
      int _subjectGames = int.parse(_userdata.gamesSubjectwise);
      int _randomGames = int.parse(_userdata.gamesRandom);

      String _perc = '';

      if (_attempted == 0) {
        _perc = '0.0';
      } else {
        _perc = ((_correct / _attempted) * 100).toStringAsFixed(1);
      }

      //   String _perc = _percc.substring(0,4);

      print("This is the percentage: $_perc");

      print("This is the exp points: $_expp");

      await SharedpreferencesHelper.setUserId(_userId);

      await SharedpreferencesHelper.setUserName(_userdata.username);

      await SharedpreferencesHelper.setCoins(_coins);

      await SharedpreferencesHelper.setExppoints(_expp);

      await SharedpreferencesHelper.setPercentage(_perc);

      await SharedpreferencesHelper.setSubjectwiseGames(
          _subjectGames.toString());

      await SharedpreferencesHelper.setRandomGames(_randomGames.toString());

      await SharedpreferencesHelper.setCumulativeScore(
          _userdata.cumulativePoints);

      await SharedpreferencesHelper.setProfilePic('');

      print(_userdata.username);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Dashboard();
          },
        ),
      );
    } else if (uResposne is String) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      if (uResposne == 'Username taken by someone else') {
        print('Username taken by someone else');
        _showDialog();
      } else {
        print("Some error occurred");
      }
    } else if (uResposne is Exception) {
      print("Exception thrown");
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      _errorMssg = uResposne.toString();
      print(uResposne);
      _isError = true;
    } else {
      print("Some error occured");
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      print(uResposne.toString());
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

  @override
  Widget build(BuildContext context) {
    double cheight = MediaQuery.of(context).size.height;
    double cwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: cheight,
          width: cwidth,
          color: Color(0xff1D2951),
          /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background1.png'),
              fit: BoxFit.fill
            )
          ),*/
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 36.0),
                  child: Text(
                    'GK Quiz for bright minds!',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'Poweto'),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.only(
                          left: 15, top: 10, right: 10, bottom: 10),
                      width: cwidth * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border:
                            Border.all(color: Colors.lightBlueAccent, width: 2),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'GilroySemiBold',
                                  fontSize: 18.0),
                              controller: _usernameController,
                              //  validator: (val) => isPhoneNumberValid(val) ? null : null,
                              onSubmitted: (val) => _username = val,
                              obscureText: false,
                              decoration: InputDecoration.collapsed(
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                      fontFamily: 'GilroySemiBold',
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18)),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                            flex: 1,
                          ),
                          visibilityOb
                              ? Container(
                                  width: 5,
                                )
                              : Icon(
                                  Icons.check_circle,
                                  size: 22,
                                  color: Color(0XFF7EE8A9), //Color(0XFF7EE8A9),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "*Username will work on this device only",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Poweto'),
                    ),
                    SizedBox(height: 24),
                    Material(
                      color: Colors.white.withOpacity(0.0),
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                end: Alignment.topLeft,
                                begin: Alignment.topRight,
                                colors: [color1, color2]),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(30.0),
                              topRight: const Radius.circular(30.0),
                              bottomLeft: const Radius.circular(30.0),
                              bottomRight: const Radius.circular(30.0),
                            )),
                        child: MaterialButton(
                          minWidth: cwidth * 0.5,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            visibilityOb ? addUserName() : null;
                          },
                          child: Text("You're welcome",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'GilroySemiBold',
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                    onTap: () {
                      /* Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Dashboard();
                        },
                      ),
                    );*/
                    },
                    child: Container(
                        height: cheight * 0.2, child: PolkadotsCanvas()))
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 40),
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
