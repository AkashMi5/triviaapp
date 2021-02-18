import 'package:meta/meta.dart';
import 'package:flutter/material.dart' ;


class CategoryDetail  {
  String color1;
  String color2;
  String categoryName;
  String categoryImage;
  String categoryActivePlayers;
  String categoryId;
  String gameType;
  String time;
  String coins ;
  String expPoints ;

  CategoryDetail({@required this.color1, @required this.color2, @required this.categoryName, @required this.categoryImage, @required this.categoryId,
    @required this.categoryActivePlayers, this.gameType, this.time, this.coins, this.expPoints});


  factory CategoryDetail.fromJson(Map<String, dynamic> parsedJson){
    return CategoryDetail(
      categoryName: parsedJson['name'],
      color1: parsedJson['color1'],
      color2: parsedJson['color2'],
      categoryId: parsedJson['id'].toString(),
      categoryActivePlayers: parsedJson['activeplayers'].toString(),
      categoryImage: parsedJson['icon'],
      gameType: parsedJson['game_type'],
      time: parsedJson['time'],
      coins: parsedJson['coins'],
      expPoints: parsedJson['exp_points']
    );
  }


}