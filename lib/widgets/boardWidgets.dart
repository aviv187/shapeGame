import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/tileModel.dart';
import 'gameOverButton.dart';
import './BoardTiles.dart';
import '../screens/boardPageDraw.dart';

class BoardWidgets extends StatefulWidget {
  final List<Tile> tileList;
  final double tileSize;
  final int colNum;
  final int rowNum;
  final double boardWidth;

  BoardWidgets({
    @required this.tileList,
    @required this.colNum,
    @required this.rowNum,
    @required this.tileSize,
    @required this.boardWidth,
  });

  @override
  _BoardWidgetsState createState() => _BoardWidgetsState();
}

class _BoardWidgetsState extends State<BoardWidgets> {
  int score = 0;
  bool gameOver = false;

  void changeScore(int points) {
    setState(() {
      score = score + points;
    });
  }

  void gameOverFunc() {
    setState(() {
      gameOver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 35,
        child: Center(child: Text('Score: $score')),
      ),
      Center(
          child: Container(
        width: widget.boardWidth,
        height: widget.boardWidth * 1.25,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
            width: 3,
            color: Colors.grey[700],
          ),
        ),
        child: Stack(
          children: [
            // draw all the moving tile
            BoardTiles(
              sides: 4,
              tileList: widget.tileList,
              tileSize: widget.tileSize,
              colNum: widget.colNum,
              rowNum: widget.rowNum,
              changeScore: changeScore,
              gameOverFunc: gameOverFunc,
            ),
            // game over buttom
            gameOver
                ? GameOverButton(
                    restartGame: () {
                      HapticFeedback.heavyImpact();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => BoardDraw(),
                        ),
                      );
                    },
                    gameScore: score.toString(),
                  )
                : Container(),
          ],
        ),
      ))
    ]);
  }
}
