import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trivia_fun/models/user_login.dart';
import 'package:trivia_fun/services/api_exception.dart';
import 'package:trivia_fun/models/category_detail.dart';
import 'package:trivia_fun/models/quizquestion_model.dart';

class API_Manager {
  final String _baseUrl = "http://avenirtechs.com/TriviaApp/triviacontroller/";

  Future<dynamic> addUser(String username, String deviceid) async {
    //  var sendOtp_response ;

    var candidateData;
    try {
      final adduser_response = await http.post(Uri.parse(_baseUrl + 'add_user'),
          body: {
            'username': username,
            'deviceid': deviceid
          }).timeout(Duration(seconds: 10));

      print("In try block");

      if (adduser_response.statusCode == 200) {
        print("In try block after statuscode 200");

        var resbody = json.decode(adduser_response.body);
        if (resbody['mssg'] == 'user data inserted successfully') {
          var userjson = resbody['data'];
          print('Hello $userjson');
          UserLogin userData = UserLogin.fromJson(userjson);
          //    print(canData);
          return userData;
        } else if (resbody['mssg'] == 'Login successful') {
          var userjson = resbody['data'];
          print('Hello $userjson');
          UserLogin userData = UserLogin.fromJson(userjson);
          //    print(canData);
          return userData;
        } else if (resbody['mssg'] == 'username taken by someone else') {
          return 'Username taken by someone else';
        } else {
          return 'Some error occurred';
        }
      } else {
        print("In else block");
        _returnResponse(adduser_response);
      }
    } on SocketException catch (e) {
      print("Socket exception $e");
      return FetchDataException('No Internet connection');
    } on TimeoutException catch (e) {
      print("Inside Timeout exception");
      return FetchDataException('No Internet connection');
    } catch (e) {
      print("In catch exception block");
      print(e);
      return e.toString();
    }
  }

  Future<dynamic> getUsernames() async {
    try {
      final username_response = await http
          .get(Uri.parse(_baseUrl + 'getusernames'))
          .timeout(Duration(seconds: 10));

      if (username_response.statusCode == 200) {
        print("Inside successful response");

        var resbody = json.decode(username_response.body);

        if (resbody['mssg'] == 'usernames fetched') {
          var userData = resbody['data'];

          List<UserLogin> userLoginList = [];
          UserLogin userM;

          for (int i = 0; i < userData.length; i++) {
            userM = UserLogin.fromJson(userData[i]);
            userLoginList.add(userM);
            print("Added");
          }

          return userLoginList;
        }
      } else {
        print("In else block");
        _returnResponse(username_response);
      }
    } on SocketException catch (e) {
      print("Socket exception $e");
      return FetchDataException('No Internet connection');
    } on TimeoutException catch (e) {
      print("Inside Timeout exception");
      return FetchDataException('No Internet connection');
    } catch (e) {
      print("In catch exception block");
      print(e);
      return e.toString();
    }
  }

  Future<dynamic> getCategoryData() async {
    List<CategoryDetail> _list = [];

    try {
      final categorylist_response = await http
          .get(Uri.parse(_baseUrl + 'category_list'))
          .timeout(Duration(seconds: 10));

      if (categorylist_response.statusCode == 200) {
        var jdata = json.decode(categorylist_response.body);

        if (jdata['mssg'] == 'Category data retrieved') {
          print('Data came successfully');

          CategoryDetail cat;

          int numOfCat = jdata['categorydata'].length;
          print('Number of categories: $numOfCat');
          var catList = jdata['categorydata'];

          var catzz = catList[0];
          print('List1: $catzz');

          for (int i = 0; i < numOfCat; i++) {
            cat = CategoryDetail.fromJson(catList[i]);
            String catNam = cat.categoryName;
            print('catName: $catNam');
            _list.add(cat);
          }
          return _list;
        } else if (jdata['mssg'] == 'No category data available') {
          return 'No category data available';
        }
      } else {
        print("In else block");
        _returnResponse(categorylist_response);
      }
    } on SocketException catch (e) {
      print("Socket exception $e");
      return FetchDataException('No Internet connection');
    } on TimeoutException catch (e) {
      print("Inside Timeout exception");
      return FetchDataException('No Internet connection');
    } catch (e) {
      print("In catch exception block");
      print(e);
      return e;
    }
  }

  Future<dynamic> getCatwiseQuestions(String userId, String catId) async {
    List<QuizQuestionModel> _qlist = [];

    try {
      print('User and cat id: $userId $catId');
      final question_response = await http
          .post(Uri.parse(_baseUrl + 'get_questions'), body: {
        'user_id': userId,
        'category_id': catId
      }).timeout(Duration(seconds: 10));

      print('Are we here?');

      if (question_response.statusCode == 200) {
        var jdata = json.decode(question_response.body);

        if (jdata['mssg'] == 'questions retrieved successfully') {
          print('Data came successfully');

          int numOfQues = jdata['questions'].length;

          QuizQuestionModel que;

          for (int i = 0; i < numOfQues; i++) {
            que = QuizQuestionModel.fromJson(jdata['questions'][i]);
            _qlist.add(que);
            print('Question added successfully');
          }

          return _qlist;
        } else if (jdata['mssg'] == 'Not enough questions in this category') {
          return 'No questions available for this category';
        }
      } else {
        print("In else block");
        _returnResponse(question_response);
      }
    } on SocketException catch (e) {
      print("Socket exception $e");
      return FetchDataException('No Internet connection');
    } on TimeoutException catch (e) {
      print("Inside Timeout exception");
      return FetchDataException('No Internet connection');
    } catch (e) {
      print("In catch exception block");
      print(e);
      return e;
    }
  }

  Future<dynamic> submitGame(String userId, String coins, String expp,
      String correct, String attempted, String gametype) async {
    UserLogin _uL;

    try {
      final gamedata_response =
          await http.post(Uri.parse(_baseUrl + 'submit_game'), body: {
        'user_id': userId,
        'coins': coins,
        'exp_points': expp,
        'correct': correct,
        'attempted': attempted,
        'gametype': gametype
      });

      if (gamedata_response.statusCode == 200) {
        var jdata = json.decode(gamedata_response.body);

        if (jdata['mssg'] == 'Game data inserted successfully') {
          _uL = UserLogin.fromJson(jdata['data']);

          return _uL;
        } else {
          return 'Proper response not received';
        }
      } else {
        print("In else block");
        _returnResponse(gamedata_response);
      }
    } on SocketException catch (e) {
      print("Socket exception $e");
      return FetchDataException('No Internet connection');
    } on TimeoutException catch (e) {
      print("Inside Timeout exception");
      return FetchDataException('No Internet connection');
    } catch (e) {
      print("In catch exception block");
      print(e);
      return e;
    }
  }

  Future<dynamic> getRank(String userId) async {
    try {
      var rank_response =
          await http.get(Uri.parse(_baseUrl + 'get_rank?user_id=' + userId));

      if (rank_response.statusCode == 200) {
        var jdata = json.decode(rank_response.body);

        if (jdata['mssg'] == 'Rank fetched successfully') {
          String _rank = jdata['rank'].toString();

          return _rank;
        } else {
          return 'Rank not fetched';
        }
      } else {
        print("In else block");
        _returnResponse(rank_response);
      }
    } on SocketException catch (e) {
      print("Socket exception $e");
      return FetchDataException('No Internet connection');
    } on TimeoutException catch (e) {
      print("Inside Timeout exception");
      return FetchDataException('No Internet connection');
    } catch (e) {
      print("In catch exception block");
      print(e);
      return e;
    }
  }

  Future<dynamic> updateProfilePic(String userid, String filePath) async {
    try {
      String _url = _baseUrl + 'save_profilepic';

      var request = http.MultipartRequest('POST', Uri.parse(_url));

      request.files
          .add(await http.MultipartFile.fromPath('profile_pic', filePath));

      print("user id: " + userid);

      request.fields['user_id'] = '$userid';

      var response = await request.send();
      print('File path: ' + filePath);
      print('send executed');
      var decode = await response.stream.bytesToString().then(json.decode);
      //   var decode = await response.stream.bytesToString();
      String res = decode.toString();
      print('done: $res');
      String message = decode['mssg'];

      if (decode['mssg'] == 'Profile pic updated successfully') {
        String _imageFileName = decode['image_url'];
        return _imageFileName;
      } else {
        return 'Image not uploaded';
      }
    } on SocketException catch (e) {
      print("Socket exception $e");
      return FetchDataException('No Internet connection');
    } on TimeoutException catch (e) {
      print("Inside Timeout exception");
      return FetchDataException('No Internet connection');
    } catch (e) {
      print("In catch exception block");
      print(e);
      return e;
    }
  }

  dynamic _returnResponse(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 400:
      case 404:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
