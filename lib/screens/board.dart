import 'package:flutter/material.dart';
import 'package:shapeGame/widgets/BoardTiles.dart';

import '../widgets/BoardTile.dart';
import '../models/tileModel.dart';

class Board extends StatelessWidget {
  void makeTileList(List<Tile> list) {
    for (int i = 0; i < 14; i++) {
      for (int j = 0; j < 8; j++) {
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double boardWidth = (screenWidth * 0.95).clamp(10, 500);

    final int tileSize = (boardWidth / 14).ceil();

    final List<Tile> tileList = [];

    if (tileList.isEmpty) {
      makeTileList(tileList);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Polygons'),
          elevation: 0,
        ),
        body: Center(
            child: Container(
          width: boardWidth,
          height: boardWidth * 1.72,
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
                    leftPosition:
                        tileSize / 2 + tile.leftPosition * 1.63 * tileSize,
                    topPosition:
                        tileSize / 2 + tile.topPosition * 1.63 * tileSize,
                    color: Colors.grey,
                  );
                }).toList(),
              ),
              BoardTiles(
                sides: 4,
                tileList: tileList,
                tileSize: tileSize,
                colNum: 8,
                rowNum: 14,
              ),
            ],
          ),
        )));
  }
}
