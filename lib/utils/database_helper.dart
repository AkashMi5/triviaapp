import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trivia_fun/models/quizquestion_model.dart';
import 'dart:async';


  class DatabaseHelper {

  final String questionTable = 'qTable' ;

  DatabaseHelper._() ;

  static final DatabaseHelper db = DatabaseHelper._() ;

   static Database _database;

  Future<Database> get database async {

    if(_database != null){
      return _database ;
    }
    _database =  await initDB();
    return _database;

  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'TriviaDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) { },
        onCreate: (Database db, int version) async  {
          await db.execute("CREATE TABLE $questionTable (qid INTEGER PRIMARY KEY, id TEXT, category_id TEXT, question TEXT, optionA TEXT, "
              "optionB TEXT, optionC TEXT, optionD TEXT, answer TEXT, imagepath TEXT, hint TEXT, userResponse TEXT)");
        }
    );
  }

  Future<int> insert(QuizQuestionModel ques) async {
    Database db = await database;
    int id = await db.insert(questionTable, ques.toJson());
    return id;
  }

  Future<List<QuizQuestionModel>> getQuizQs() async {
    final db = await database;
    var res = await db.query(questionTable);
    List<QuizQuestionModel> QuizQs = res.isNotEmpty ? res.map((quizqs) => QuizQuestionModel.fromJson(quizqs)).toList() : [];
    return QuizQs;
  }


  Future<bool> updateUserAnswer(QuizQuestionModel qs, String userAnswer) async {
    final db  = await database;
    String qsId = qs.qid ;
    print('Qid: $qsId');
    String uAnswer = userAnswer;
    var res = await db.query('qTable',
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [qsId],
    );
    if (res.length > 0){
      QuizQuestionModel qUpdatedAnswer = QuizQuestionModel (
        qid : qs.qid,
        catid: qs.catid,
        questionText: qs.questionText,
        optA : qs.optA,
        optB : qs.optB,
        optC : qs.optC,
        optD : qs.optD,
        answer : qs.answer,
        imagePath : qs.imagePath,
        hint : qs.hint,
        userResponse: uAnswer,
      );
      var res = await db.update(questionTable, qUpdatedAnswer.toJson(),
        where: 'id = ?',
        whereArgs: [qsId],
      );
      return true;
    }
    else {
      print('Question not found in db');
      return false;
    }
  }

  deleteAll() async {
    Database db = await database;
    await db.delete(questionTable);
  }


  }