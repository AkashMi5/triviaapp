class QuizQuestionModel {
  String qid;
  String catid;
  String questionText;
  String  optA;
  String optB;
  String optC;
  String optD;
  String answer;
  String imagePath;
  String hint;
  String userResponse;

  QuizQuestionModel({this.qid, this.catid, this.questionText, this.optA, this.optB, this.optC, this.optD, this.answer, this.imagePath, this.hint, this.userResponse});

  factory QuizQuestionModel.fromJson(Map<String, dynamic> parsedJson){
    return QuizQuestionModel(
        qid: parsedJson['id'],
        catid: parsedJson['category_id'],
        questionText: parsedJson['question'],
        optA: parsedJson['optionA'],
        optB: parsedJson['optionB'],
        optC: parsedJson['optionC'],
        optD: parsedJson['optionD'],
        answer: parsedJson['answer'],
        imagePath: parsedJson['imagepath'],
        hint: parsedJson['hint'],
        userResponse: parsedJson['userResponse']
    );
  }

  Map<String, dynamic> toJson() => {
    'id' : qid,
    'category_id' : catid,
    'question' : questionText,
    'optionA'  : optA,
    'optionB'  : optB,
    'optionC'  : optC,
    'optionD'  : optD,
    'answer' : answer,
    'imagepath' : imagePath,
    'hint' : hint,
    'userResponse': userResponse
  };

}