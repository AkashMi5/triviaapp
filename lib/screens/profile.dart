import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_fun/mywidgets/elliptical_widget.dart';
import 'package:trivia_fun/mywidgets/elliptical2_widget.dart';
import 'package:trivia_fun/mywidgets/polkadots_canvas.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trivia_fun/mywidgets/polkadots_card_canvas.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';
import 'package:trivia_fun/main.dart';
import 'package:trivia_fun/services/api_manager.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:trivia_fun/utils/constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _username = '';
  String _coins = '10';
  String _expPoints = '';
  String _percCorrect = '';
  String _cumlScore = '0';
  API_Manager _apiM = API_Manager();
  String _userId = '';
  String _rank = '#';
  ProgressDialog pr;
  ImagePicker imagePicker = ImagePicker();
  File _croppedFile;
  PickedFile _image;
  String imageFile;
  String _fileName = '';
  String _imageBaseUrl = Constants.imageBaseUrl;
  int imagecheck = 2;

  @override
  void initState() {
    _getUserData().then((_) {
      _getUserRank();
    });
    // TODO: implement initState
    super.initState();
  }

  _getUserData() async {
    String _uusername = await SharedpreferencesHelper.getUserName();
    String _ccoins = await SharedpreferencesHelper.getCoins();
    String _eexpPoints = await SharedpreferencesHelper.getExppoints();
    String _ppercCorrect = await SharedpreferencesHelper.getPercentage();
    // String _userId = await SharedpreferencesHelper.getUserId() ;
    String _cumScore = await SharedpreferencesHelper.getCumulativeScore();
    _userId = await SharedpreferencesHelper.getUserId();
    String fileN = await SharedpreferencesHelper.getProfilePic();

    if (fileN.isNotEmpty) {
      _fileName = fileN;
    }

    int _coinsx = int.parse(_ccoins);
    int _expx = int.parse(_eexpPoints);
    double _percx = double.parse(_ppercCorrect);

    //  double _cumScorex = ((_coinsx + _expx)/100)*_percx ;

    //  _cumlScore = _cumScorex.toStringAsFixed(0);

    setState(() {
      _username = _uusername;
      _coins = _ccoins;
      _expPoints = _eexpPoints;
      _percCorrect = _ppercCorrect;
      _cumlScore = _cumScore;
    });
  }

  Future getImage(int imagecheck) async {
    print(imagecheck);
    if (imagecheck == 1) {
      var image = await imagePicker.getImage(source: ImageSource.camera);
      _image = image;
      //   imageFile = _image.path;
      _cropImage();
    } else if (imagecheck == 2) {
      var image = await imagePicker.getImage(source: ImageSource.gallery);
      _image = image;
      //      imageFile = _image.path;
      _cropImage();
    } else {}
    print("check" + _image.toString());
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper().cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        cropStyle: CropStyle.circle,
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      //    File file = File(imageFile) ;
      _croppedFile = croppedFile;
      setState(() {
        imageFile = _croppedFile.path;
        //   state = AppState.cropped;
      });

      _uploadImage();
    }
  }

  _uploadImage() async {
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

    var uploadimageResponse = await _apiM.updateProfilePic(_userId, imageFile);

    pr.hide().then((isHidden) {
      print(isHidden);
    });

    if (uploadimageResponse is Exception) {
      print("Exception has occured");
      String _errorMssg = uploadimageResponse.toString();
      print(_errorMssg);
    } else {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      if (uploadimageResponse == 'Image not uploaded') {
        print(uploadimageResponse);
      } else {
        setState(() {
          _fileName = uploadimageResponse;
        });

        await SharedpreferencesHelper.setProfilePic(_fileName);
      }
    }
  }

  _getUserRank() async {
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

    var _rankResponse = await _apiM.getRank(_userId);

    if (int.parse(_rankResponse) > 0) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      print(_rankResponse.toString());

      setState(() {
        _rank = _rankResponse;
      });
    } else if (_rankResponse is Exception) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print("Exception has occured");
      String _errorMssg = _rankResponse.toString();
      print(_errorMssg);
    } else {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print("Some error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    double cheight = MediaQuery.of(context).size.height;
    double cwidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: cheight,
        width: cwidth,
        color: Color(0xff1D2951),
      ),
      //   EllipticalWidget(),
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: _fileName.isEmpty
                            ? Image.asset('user_avatar2.png',
                                height: cheight * 0.06, width: cheight * .06)
                            : Container(
                                width: cheight * 0.07,
                                height: cheight * 0.07,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            _imageBaseUrl + _fileName)))),
                        /* CircleAvatar(
                                           radius: 20,
                                             child: Image.network(_imageBaseUrl + _fileName, height: cheight*0.06, width: cheight*.06)
                                         ),*/
                      ),
                      Positioned(
                        right: 5,
                        bottom: 1,
                        child: InkWell(
                          onTap: () {
                            _modalBottomSheetMenu();
                          },
                          child: Icon(
                            Icons.camera_enhance,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _username,
                        style: TextStyle(
                            fontSize: cheight * 0.025,
                            color: Colors.white,
                            fontFamily: 'Poweto'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: cheight * 0.03,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Global Rank',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontFamily: 'Poweto'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: cheight * 0.04,
                      width: cheight * 0.04,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.pink),
                      child: Center(
                        child: Text(
                          _rank,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Poweto'),
                        ),
                      ),
                    )
                  ],
                ),
              ])),

      Container(
          margin: EdgeInsets.only(
              top: cheight * 0.35, left: cwidth * 0.1, right: cwidth * 0.1),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Image.asset('coin3.png',
                      height: cheight * 0.05, width: cheight * 0.05),
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _coins,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Coins',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                )
              ],
            ),
            SizedBox(height: cheight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Image.asset('badge.png',
                        height: cheight * 0.05, width: cheight * 0.05),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _expPoints,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Experience points',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                )
              ],
            ),
            SizedBox(height: cheight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Image.asset('percentage.png',
                        height: cheight * 0.04, width: cheight * 0.04),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _percCorrect,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                ),
                Expanded(
                  child: Text(
                    '% Correct Ans',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                )
              ],
            ),
            SizedBox(height: cheight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Container(
                      height: cheight * 0.04,
                      width: cheight * 0.04,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      child: Center(
                        child: Text(
                          "CS",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Poweto'),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _cumlScore,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Cumulative Score',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poweto'),
                  ),
                )
              ],
            ),
            SizedBox(height: cheight * 0.1)
          ])),

      Container(
        margin: EdgeInsets.only(top: cheight * 0.7),
        child: InkWell(
          onTap: () async {
            await SharedpreferencesHelper.clearSP();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage()),
                (Route<dynamic> route) => false);
          },
          child: Center(
            child: Text(
              'Log out',
              style: TextStyle(
                  fontSize: 20, color: Colors.cyan, fontFamily: 'Poweto'),
            ),
          ),
        ),
      ),
    ]));
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Profile Photo",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      imagecheck = 1;
                                      getImage(imagecheck);
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.camera_enhance,
                                      size: 45,
                                      color: Colors.blue[300],
                                    ),
                                  )),
                              Text(
                                "Camera",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[300]),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      imagecheck = 2;
                                      getImage(imagecheck);
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.perm_media,
                                      size: 45,
                                      color: Colors.blue[300],
                                    ),
                                  )),
                              Text(
                                "Gallery",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[300]),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            );
          });
        });
  }
}
