import 'package:flutter/material.dart';

import '../helpers/tileModel.dart';
import '../helpers/makeIntToSize.dart';
import '../widgets/BoardTile.dart';
import '../widgets/boardWidgets.dart';

class BoardDraw extends StatelessWidget {
  final int colNum = 9;
  final int rowNum = 14;

  final List<Tile> tileList = [];

  void makeTileList(List<Tile> list) {
    for (int i = 0; i < rowNum; i++) {
      for (int j = 0; j < colNum; j++) {
        list.add(
          Tile(
            leftPosition: j,
            topPosition: i,
            key: UniqueKey(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double tileSize = (screenWidth / (colNum * 2));

    final double boardWidth = tileSize * colNum * 1.9;

    if (tileList.isEmpty) {
      makeTileList(tileList);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Polygons'),
        elevation: 0,
      ),
      body: Stack(children: <Widget>[
        Column(children: <Widget>[
          SizedBox(
            height: 35,
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
                // draw the board
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
              ],
            ),
          )),
        ]),
        // all the statful widgets in the board
        BoardWidgets(
          tileList: tileList,
          colNum: colNum,
          rowNum: rowNum,
          tileSize: tileSize,
          boardWidth: boardWidth,
        ),
      ]),
    );
  }
}
