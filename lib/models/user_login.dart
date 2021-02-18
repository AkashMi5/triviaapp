
 class UserLogin {

  String userId ;
  String username ;
  String deviceId ;
  String coins ;
  String expPoints ;
  String correct ;
  String attempted ;
  String gamesSubjectwise ;
  String gamesRandom ;
  String cumulativePoints ;


  UserLogin({ this.userId,  this.username, this.deviceId, this.coins, this.expPoints, this.correct, this.attempted, this.gamesSubjectwise, this.gamesRandom,
               this.cumulativePoints}) ;

  factory UserLogin.fromJson(Map<String, dynamic> jsonData) {
     return UserLogin(
         userId: jsonData['id'],
         username: jsonData['username'] ,
         deviceId: jsonData['deviceid'] ,
         coins: jsonData['coins'],
         expPoints: jsonData['exp_points'],
         correct: jsonData['correct_answers'],
         attempted: jsonData['attempted_ques'],
         gamesSubjectwise: jsonData['games_played_subjectwise'],
         gamesRandom: jsonData['games_played_random'],
       cumulativePoints: jsonData['cumulative_score']
     );
  }

  Map<String, dynamic> toJson() {
       return {
         'id' : userId,
         'username': username,
         'deviceid' : deviceId,
         'coins' : coins,
         'exp_points' : expPoints,
         'correct_answers' : correct,
         'attempted_ques' : attempted,
         'games_played_subjectwise' : gamesSubjectwise,
         'games_played_random' : gamesRandom,
         'cumulative_score' : cumulativePoints
       } ;
  }

 }