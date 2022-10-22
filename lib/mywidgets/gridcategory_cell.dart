// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:trivia_fun/models/category_detail.dart';
import 'package:trivia_fun/screens/dashboard/view/dashboard_view.dart';
import 'package:trivia_fun/utils/sharedpreferences_helper.dart';
import 'package:trivia_fun/utils/constants.dart';
import 'package:trivia_fun/screens/play_single_game.dart';
import 'package:trivia_fun/utils/constants.dart';

class GridCategoryCell extends StatefulWidget {
  final CategoryDetail categoryDetail;
  final int index;
  final int clength;
  final ValueChanged<int> updateui;

  GridCategoryCell(
      context, this.categoryDetail, this.index, this.clength, this.updateui);

  @override
  _GridCategoryCellState createState() => _GridCategoryCellState();
}

class _GridCategoryCellState extends State<GridCategoryCell> {
  @override
  void initState() {
    initialStatus();
    print('Init in gridcell called');
    super.initState();
  }

  @override
  void dispose() {
    Constants.gridcellStatus.clear();
    super.dispose();
  }

//  List<bool> _selectedCard = [] ;

  initialStatus() {
    Constants.gridcellStatus.add(false);
    /*for(int i = 0; i < widget.clength ; i++) {
      Constants.gridcellStatus.add(false);
      print(false);
    }*/
  }

  selectCard(int cindex) async {
    for (int i = 0; i < widget.clength; i++) {
      if (i == cindex) {
        Constants.gridcellStatus[widget.index] =
            !Constants.gridcellStatus[widget.index];
        Constants.catChoose = !Constants.catChoose;
        print('True that');
      } else {
        Constants.gridcellStatus[i] = false;
        print('False that');
      }
    }

    for (int i = 0; i < widget.clength; i++) {
      if (Constants.gridcellStatus[i] == true) {
        Constants.catChoose = true;
        Constants.catIdChosen = widget.categoryDetail.categoryId;
        String qTime = widget.categoryDetail.time;
        String coins = widget.categoryDetail.coins;
        String exp = widget.categoryDetail.expPoints;
        SharedpreferencesHelper.setCatId(widget.categoryDetail.categoryId);
        SharedpreferencesHelper.setCatQtime(qTime);
        SharedpreferencesHelper.setCatCoins(coins);
        SharedpreferencesHelper.setCatExpPoints(exp);
        SharedpreferencesHelper.setSubOrRan('subjectwise');
        print('Category id: ' + Constants.catIdChosen);
        print('Catg coins: ' + await SharedpreferencesHelper.getCatCoins());
        print('Catg expPoints: ' +
            await SharedpreferencesHelper.getCatExpPoints());
      }
    }

    widget.updateui(1);
  }

  @override
  Widget build(BuildContext context) {
    double cheight = MediaQuery.of(context).size.height;
    double cwidth = MediaQuery.of(context).size.width;
    print('Build of gridcell is called');
    //  print('Check selected status ' + Constants.gridcellStatus[5].toString()) ;
    return Stack(
      children: <Widget>[
        Card(
          elevation: 6.0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    end: Alignment.topRight,
                    begin: Alignment.bottomLeft,
                    colors: [
                      Color(int.parse(widget.categoryDetail.color1)),
                      Color(int.parse(widget.categoryDetail.color2))
                    ]),
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(20.0),
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0),
                )),
            child: InkWell(
              onTap: () async {
                selectCard(widget.index);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: Colors.white.withOpacity(0.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.0, 10.0, 8.0, 8.0),
                              child: Image.network(
                                'http://avenirtechs.com/quizrn/assets/category_icons/' +
                                    widget.categoryDetail.categoryImage,
                                color: Colors.white,
                                height: cheight * 0.06,
                                width: cheight * 0.06,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.categoryDetail.categoryName,
                              style: new TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  fontSize: cheight * 0.03,
                                  fontFamily: 'Gilroyblcak_bold',
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.categoryDetail.gameType,
                              style: new TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                  fontSize: cheight * 0.02,
                                  color: Colors.white70,
                                  fontFamily: 'Gilroyblcak_bold',
                                  fontStyle: FontStyle.normal),
                            ),
                            Text(
                              " questions per game",
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                  fontSize: cheight * 0.02,
                                  color: Colors.white70,
                                  fontFamily: 'Gilroyblcak_bold',
                                  fontStyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.categoryDetail.time,
                            style: new TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: cheight * 0.02,
                                color: Colors.white70,
                                fontFamily: 'Gilroyblcak_bold',
                                fontStyle: FontStyle.normal),
                          ),
                          Flexible(
                            child: Text(
                              " seconds per question",
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                  fontSize: cheight * 0.02,
                                  color: Colors.white70,
                                  fontFamily: 'Gilroyblcak_bold',
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Constants.gridcellStatus[widget.index]
            ? Positioned(
                bottom: 20,
                right: 20,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                ),
              )
            : Container()
      ],
    );
  }
}
