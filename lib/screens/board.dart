import 'package:flutter/material.dart';
import 'package:shapeGame/widgets/BoardTiles.dart';

import '../widgets/BoardTile.dart';
import '../models/tileModel.dart';
import '../models/makeIntToSize.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<Tile> tileList = [];

  int score = 0;

  void makeTileList(List<Tile> list) {
    for (int i = 0; i < 14; i++) {
      for (int j = 0; j < 9; j++) {
        list.add(
          Tile(
            color: Colors.grey,
            leftPosition: j,
            topPosition: i,
            key: UniqueKey(),
          ),
        );
      }
    }
  }

  void changeScore(int points) {
    setState(() {
      score = score + points;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double boardWidth = (screenWidth * 0.98).clamp(10, 500);

    final double tileSize = (boardWidth / 15);

    if (tileList.isEmpty) {
      makeTileList(tileList);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Polygons'),
          elevation: 0,
        ),
        body: Column(children: <Widget>[
          Container(
            height: 35,
            child: Center(child: Text('Score: $score')),
          ),
          Center(
              child: Container(
            width: boardWidth,
            height: boardWidth * 1.55,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                width: 3,
                color: Colors.grey[700],
              ),
            ),
            child: Stack(
              children: [
                Stack(
                  children: tileList.map((Tile tile) {
                    return BoardTile(
                      sides: 4,
                      size: tileSize,
                      leftPosition: makeTileIntToSizeForPaint(
                          tile.leftPosition, tileSize),
                      topPosition:
                          makeTileIntToSizeForPaint(tile.topPosition, tileSize),
                      color: Colors.grey,
                    );
                  }).toList(),
                ),
                BoardTiles(
                  sides: 4,
                  tileList: tileList,
                  tileSize: tileSize,
                  colNum: 9,
                  rowNum: 14,
                  changeScore: changeScore,
                ),
              ],
            ),
          ))
        ]));
  }
}
