import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/mywidgets/utility_widgets.dart';
import 'package:trivia_fun/routes.dart';
import 'package:trivia_fun/screens/login/bloc/login_bloc.dart';
import 'package:trivia_fun/screens/login/bloc/login_event.dart';
import 'package:trivia_fun/screens/login/bloc/login_state.dart';
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _usernameController = TextEditingController();
  bool visibilityOb = true;
  Color color1 = Color(0XFF015DEA);
  Color color2 = Color(0XFF01C4FA);
  String _dialogTitle = 'Alert';
  String _dialogDesc = 'Username already exists, try with other one!';
  String _dialogButtonText = 'Okay';
  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = LoginBloc();
    _usernameController.text = '';
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

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _loginBloc.close();
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

    return BlocProvider<LoginBloc>(
        create: (context) => _loginBloc,
        child: BlocListener<LoginBloc, LoginState>(listener: (context, state) {
          if (state is LoginErrorState) {
            UtilityWidgets.showSnackBar(context, state.errorMessage);
          } else if (state is LoginDataSubmittedState) {
            if (state.userLogin != null) {
              Navigator.of(context).pushReplacementNamed(Routes.dashboard);
            } else if (state.message != null) {
              if (state.message == 'Username taken by someone else') {
                _showDialog();
              } else {
                UtilityWidgets.showSnackBar(context, state.message);
              }
            } else {
              UtilityWidgets.showSnackBar(context, state.message);
            }
          }
        }, child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: cheight,
                  width: cwidth,
                  color: Color(0xff1D2951),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(
                                    color: Colors.lightBlueAccent, width: 2),
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
                                      onChanged: (val) => _usernameController
                                        ..text = val
                                        ..selection = TextSelection.collapsed(
                                            offset: _usernameController
                                                .text.length),
                                      //  validator: (val) => isPhoneNumberValid(val) ? null : null,
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
                                          color: Color(
                                              0XFF7EE8A9), //Color(0XFF7EE8A9),
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
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  onPressed: () {
                                    _loginBloc.add(UserNameSubmitEvent(
                                        userName: _usernameController.text));
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
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (state is LoginLoadingState)
                              CircularProgressIndicator(
                                color: Colors.white70,
                              ),
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
                                height: cheight * 0.2,
                                child: PolkadotsCanvas()))
                      ],
                    ),
                  ),
                ),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          },
        )));
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
      ],
    );
  }
}
