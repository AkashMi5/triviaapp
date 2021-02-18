import 'package:flutter/material.dart' ;
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart' ;
import 'package:trivia_fun/models/category_detail.dart' ;
import 'package:trivia_fun/mywidgets/gridcategory_cell.dart' ;
import 'package:trivia_fun/services/api_manager.dart' ;
import 'package:progress_dialog/progress_dialog.dart' ;
import 'package:trivia_fun/screens/play_single_game.dart' ;
import 'package:trivia_fun/utils/constants.dart' ;
import 'package:trivia_fun/utils/sharedpreferences_helper.dart' ;
import 'package:trivia_fun/models/quizquestion_model.dart' ;
import 'package:trivia_fun/utils/database_helper.dart' ;

class SinglePlayerChoose extends StatefulWidget {
  @override
  _SinglePlayerChooseState createState() => _SinglePlayerChooseState();
}

class _SinglePlayerChooseState extends State<SinglePlayerChoose> {

  bool _dataLoad = false;
  API_Manager _apiM = API_Manager();
  ProgressDialog pr ;
  List<CategoryDetail> _catList = [] ;
  List<QuizQuestionModel> _quesList = [] ;
  String _errorMssg = '' ;
  final DatabaseHelper database = DatabaseHelper.db;
  String _dialogTitle = 'Alert';
  String _dialogDesc = 'Not enough questions in this category, try other.';
  String _dialogButtonText = 'Okay';

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _getCategoryData());
    super.initState();
  }


  _getCategoryData() async  {


    var uResposne = await _apiM.getCategoryData();

    if(uResposne is List<CategoryDetail>){

      print("Category List is fetched") ;
      _catList = uResposne ;
      setState(() {
        _dataLoad = true ;
      });
    }

    else if(uResposne is String){

      print(uResposne);
      setState(() {
        _dataLoad = true ;
      });
      //todo
      //Show exception message on dialog
    }

    else if(uResposne is Exception){
      print("Exception has occured") ;
      _errorMssg = uResposne.toString() ;
      print(uResposne);

      setState(() {
        _dataLoad = true ;
      });

      //todo
      //Show exception message on dialog
    }

    else {
      print("Some error occured") ;
      print(uResposne.toString());

      setState(() {
        _dataLoad = true ;
      });
    }

  }


  getQuestions() async {

    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Getting data..',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          child: Image.asset('images/double_ring_loading_io.gif'), // Image.asset('images/1_florian-7gif.gif'),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();

    String uid = await SharedpreferencesHelper.getUserId();
    String catId = await SharedpreferencesHelper.getCatId();

    var qresponse = await _apiM.getCatwiseQuestions(uid, catId);

    QuizQuestionModel qModel ;

     if(qresponse is List<QuizQuestionModel>){
       pr.hide().then((isHidden) {
         print(isHidden);
       });
       _quesList = qresponse ;
       int numOfQues = _quesList.length ;
       if(numOfQues > 0){
         await database.deleteAll();
         for (int i = 0; i < numOfQues; i++) {
           qModel = _quesList[i];
           int id = await database.insert(qModel);
           print("Success") ;
         }
         Navigator.of(context).pushReplacement(_createRoute());
       }

       else {
         pr.hide().then((isHidden) {
           print(isHidden);
         });
        print('No questions received for this category');
       }
     }

     else if(qresponse is String){
       pr.hide().then((isHidden) {
         print(isHidden);
       });

       if(qresponse == 'No questions available for this category') {
         _showDialog() ;
       }
       print('No questions received for this category') ;
     }

     else if(qresponse is Exception){
       pr.hide().then((isHidden) {
         print(isHidden);
       });
       print("Exception has occured") ;
       _errorMssg = qresponse.toString() ;
       print(qresponse);
     }

     else {
       pr.hide().then((isHidden) {
         print(isHidden);
       });
       print("Some error occured") ;
       print(qresponse.toString());
     }

  }

  void updateUI(int count){
    setState(() {
        print('Here is count: $count');
    });
  }


  _showDialog() {
    // return object of type Dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) =>
          CustomDialog(
            title: "$_dialogTitle",
            description:
            "$_dialogDesc",
            buttonText: "$_dialogButtonText",
          ),
    );
  }


  @override
  Widget build(BuildContext context) {

    print('Build method just called') ;

    double cheight = MediaQuery.of(context).size.height ;
    double cwidth = MediaQuery.of(context).size.width ;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: cheight,
            width: cwidth,
            color: Color(0xff1D2951),
          ),

          Container(
            margin: EdgeInsets.only(top: cheight*0.8),
            width: cwidth,
            child: PolkadotsCanvas(),
          ),

          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: cheight*0.05),

                child: Column(
                  children: <Widget>[

                    Container(
                      height: cheight*0.06,
                      width: cwidth*0.7,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                        child: Center(
                          child: Text(
                            "Choose Category",
                               style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'PoppinsRegular'
                            ),
                          ),
                        )
                    ),

                    _dataLoad ? GridView.count(
                          shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 10,
                      padding: const EdgeInsets.all(10.0),
                      childAspectRatio: 0.98,
                      children: List.generate(_catList.length, (index) {
                        return GridCategoryCell(context, _catList[index], index, _catList.length, updateUI);
                      }),
                    ) :
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            child:  CircularProgressIndicator(),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    InkWell(
                      onTap: (){
                       Constants.catChoose ?  getQuestions() : null;
                      },
                      child: Card(
                        elevation: 20,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))
                        ),
                        child: Container(
                            height: 50,
                            width: cwidth*0.4,
                            decoration: BoxDecoration(
                              color: Constants.catChoose ? Colors.blue : Colors.blueGrey,
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Center(
                              child: Text(
                                "Start",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'PoppinsRegular'
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
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
      pageBuilder: (context, animation, secondaryAnimation) => PlaySingleGame(),
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
    return Stack(
      children: <Widget>[
        Container (
          padding: EdgeInsets.only(
            top:  Consts.padding,
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
                      child: Text("Ok",
                          style: TextStyle(
                              color: Colors.white
                          )
                      ),
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
