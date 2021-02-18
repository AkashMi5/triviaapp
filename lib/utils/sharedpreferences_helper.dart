import 'package:shared_preferences/shared_preferences.dart' ;

class SharedpreferencesHelper {

      static Future<String> getDeviceId() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('deviceId');

      }

      static Future<bool> setDeviceId(String deviceId) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('deviceId', deviceId);

      }


      static Future<String> getUserId() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('userId');

      }

      static Future<bool> setUserId(String userId) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('userId', userId);

      }

      static Future<bool> setCatId(String catid) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('catId', catid);

      }

      static Future<String> getCatId() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('catId');

      }

      static Future<bool> setCatName(String catname) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('catName', catname);

      }

      static Future<String> getCatName() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('catName');

      }

      static Future<bool> setCatQtime(String qtime) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('catQtime', qtime);

      }

      static Future<String> getCatQtime() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('catQtime');

      }

      static Future<bool> setCatCoins(String coins) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('catCoins', coins);

      }

      static Future<String> getCatCoins() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('catCoins');

      }

      static Future<bool> setCatExpPoints(String exp) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('expPoints', exp);

      }

      static Future<String> getCatExpPoints() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('expPoints');

      }


      static Future<bool> setUserName(String uname) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('userName', uname);

      }

      static Future<String> getUserName() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('userName');

      }

      static Future<bool> setCoins(String coins) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('coins', coins);

      }

      static Future<String> getCoins() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('coins');

      }

      static Future<bool> setExppoints(String exppoints) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('expPoints', exppoints);

      }

      static Future<String> getExppoints() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('expPoints');

      }

      static Future<bool> setPercentage(String perc) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('percentage', perc);

      }

      static Future<String> getPercentage() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('percentage');

      }

      static Future<bool> setCorrect(String correct) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('correct', correct);

      }

      static Future<String> getCorrect() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('correct');

      }

      static Future<bool> setSubjectwiseGames(String sGames) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('sGamesNum', sGames);

      }

      static Future<String> getSubjectwiseGames() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('sGamesNum');

      }

      static Future<bool> setRandomGames(String rGames) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('rGamesNum', rGames);

      }

      static Future<String> getRandomGames() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('rGamesNum');

      }

      static Future<bool> clearSP() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.clear();

      }

      static Future<bool> checkUserIdKey() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.containsKey('userId') ;

      }

      static Future<bool> setSubOrRan(String suborran) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('SubOrRan', suborran);

      }

      static Future<String> getSubOrRan() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('SubOrRan') ;

      }

      static Future<bool> setCumulativeScore(String cumScore) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('cumScore', cumScore);

      }

      static Future<String> getCumulativeScore() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('cumScore') ;

      }

      static Future<bool> setProfilePic(String picFile) async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.setString('profilePic', picFile);

      }

      static Future<String> getProfilePic() async {

        final SharedPreferences prefs = await SharedPreferences.getInstance() ;

        return prefs.getString('profilePic') ;

      }

}