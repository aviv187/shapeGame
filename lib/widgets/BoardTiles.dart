import 'dart:math';

import 'package:flutter/material.dart';

import './BoardTile.dart';
import '../helpers/tileModel.dart';
import '../helpers/gravityEnum.dart';
import '../helpers/makeIntToSize.dart';

class BoardTiles extends StatefulWidget {
  final int sides;
  final List<Tile> tileList;
  final double tileSize;
  final int colNum;
  final int rowNum;
  final Function changeScore;
  final Function gameOverFunc;

  BoardTiles({
    @required this.changeScore,
    @required this.sides,
    @required this.tileList,
    @required this.tileSize,
    @required this.colNum,
    @required this.rowNum,
    @required this.gameOverFunc,
  });

  @override
  _BoardTilesState createState() => _BoardTilesState();
}

class _BoardTilesState extends State<BoardTiles> {
  List<Tile> activeTileList = [];
  List<Map<String, dynamic>> tilesToRemove = [];

  bool canTheTilesbePressed = true;

  @override
  void initState() {
    super.initState();

    makeBoard();
  }

  void makeBoard() {
    widget.tileList.forEach((tile) {
      final int index = widget.tileList.indexOf(tile);
      Color color;
      Gravity tileGravity;
      Random random = Random();
      switch (random.nextInt(6)) {
        case 0:
          color = Colors.red;
          break;
        case 1:
          color = Colors.blue;
          break;
        case 2:
          color = Colors.orange;
          break;
        case 3:
          color = Colors.yellow;
          break;
        case 4:
          color = Colors.green;
          break;
        case 5:
          color = Colors.purple;
          break;
        default:
      }

      switch (random.nextInt(4)) {
        case 0:
          tileGravity = Gravity.bottom;
          break;
        case 1:
          tileGravity = Gravity.top;
          break;
        case 2:
          tileGravity = Gravity.right;
          break;
        case 3:
          tileGravity = Gravity.left;
          break;
        default:
      }

      activeTileList.add((Tile(
        topPosition: widget.tileList[index].topPosition,
        leftPosition: widget.tileList[index].leftPosition,
        color: color,
        key: tile.key,
        inRemoveList: false,
        gravity: tileGravity,
      )));

      tile.occupied = true;
    });
  }

  void startMovigTiles(Gravity gravity) {
    switch (gravity) {
      case Gravity.top:
        activeTileList.sort((a, b) {
          return a.topPosition.compareTo(b.topPosition);
        });
        break;
      case Gravity.bottom:
        activeTileList.sort((a, b) {
          return b.topPosition.compareTo(a.topPosition);
        });
        break;
      case Gravity.left:
        activeTileList.sort((a, b) {
          return a.leftPosition.compareTo(b.leftPosition);
        });
        break;
      case Gravity.right:
        activeTileList.sort((a, b) {
          return b.leftPosition.compareTo(a.leftPosition);
        });
        break;
      default:
    }

    activeTileList.forEach((tile) {
      checkTileNextPosition(tile, gravity);
    });
  }

  void checkTileNextPosition(Tile tile, Gravity gravity) {
    int nextTopP = tile.topPosition;
    int nextLeftP = tile.leftPosition;

    switch (gravity) {
      case Gravity.top:
        for (int i = tile.topPosition - 1; i >= 0; i--) {
          int tileInt = findTilePosition(i, tile.leftPosition);
          if (!widget.tileList[tileInt].occupied) {
            nextTopP--;
          } else {
            i = -1;
          }
        }
        break;
      case Gravity.right:
        for (int i = tile.leftPosition + 1; i < widget.colNum; i++) {
          int tileInt = findTilePosition(tile.topPosition, i);
          if (!widget.tileList[tileInt].occupied) {
            nextLeftP++;
          } else {
            i = widget.colNum;
          }
        }
        break;
      case Gravity.bottom:
        for (int i = tile.topPosition + 1; i < widget.rowNum; i++) {
          int tileInt = findTilePosition(i, tile.leftPosition);
          if (!widget.tileList[tileInt].occupied) {
            nextTopP++;
          } else {
            i = widget.rowNum;
          }
        }
        break;
      case Gravity.left:
        for (int i = tile.leftPosition - 1; i >= 0; i--) {
          int tileInt = findTilePosition(tile.topPosition, i);
          if (!widget.tileList[tileInt].occupied) {
            nextLeftP--;
          } else {
            i = -1;
          }
        }
        break;
      default:
    }

    final int nextTilePosition = findTilePosition(nextTopP, nextLeftP);

    if (nextTopP != tile.topPosition || nextLeftP != tile.leftPosition) {
      moveTile(
          tile: tile,
          nextTilePosition: nextTilePosition,
          moveTile: () {
            tile.topPosition = nextTopP;
            tile.leftPosition = nextLeftP;
          });
    }
  }

  void moveTile({Tile tile, int nextTilePosition, Function moveTile}) {
    final int tilePosition =
        findTilePosition(tile.topPosition, tile.leftPosition);

    widget.tileList[tilePosition].occupied = false;
    widget.tileList[nextTilePosition].occupied = true;

    if (mounted) {
      setState(() {
        moveTile();
      });
    }
  }

  void removeTile(Tile tile) {
    if (canTheTilesbePressed) {
      canTheTilesbePressed = false;

      final int tilePosition =
          findTilePosition(tile.topPosition, tile.leftPosition);

      tilesToRemove.add({'tile': tile, 'int': tilePosition});
      tile.inRemoveList = true;

      checkNearTiles(tile);

      final int tilesTRN = tilesToRemove.length;

      widget.changeScore(
          (tilesTRN == 1) ? -5 : (tilesTRN * tilesTRN * 0.8).floor());

      tilesToRemove.forEach((tileTR) {
        widget.tileList[tileTR['int']].occupied = false;
        setState(() {
          activeTileList.remove(tileTR['tile']);
        });
      });

      tilesToRemove = [];

      if (activeTileList.isEmpty) {
        widget.gameOverFunc();
      }

      startMovigTiles(tile.gravity);
      canTheTilesbePressed = true;
    }
  }

  void checkNearTiles(Tile tile) {
    if (tile.topPosition < widget.rowNum - 1) {
      addTileToRemoveList(tile.topPosition + 1, tile.leftPosition, tile.color);
    }
    if (tile.topPosition > 0) {
      addTileToRemoveList(tile.topPosition - 1, tile.leftPosition, tile.color);
    }
    if (tile.leftPosition < widget.colNum - 1) {
      addTileToRemoveList(tile.topPosition, tile.leftPosition + 1, tile.color);
    }
    if (tile.leftPosition > 0) {
      addTileToRemoveList(tile.topPosition, tile.leftPosition - 1, tile.color);
    }
  }

  void addTileToRemoveList(int topPosition, int leftPosition, Color color) {
    final int tilePosition = findTilePosition(topPosition, leftPosition);
    final int tileIndex = findTileByPosition(topPosition, leftPosition);

    try {
      final Tile tile = activeTileList[tileIndex];
      if (tile.color == color) {
        if (!tile.inRemoveList) {
          tilesToRemove.add({'tile': tile, 'int': tilePosition});
          tile.inRemoveList = true;
          checkNearTiles(tile);
        }
      }
    } catch (e) {}
  }

  int findTileByPosition(int topPosition, int leftPosition) {
    return activeTileList.indexWhere((tile) {
      if (tile.topPosition == topPosition &&
          tile.leftPosition == leftPosition) {
        return true;
      } else {
        return false;
      }
    });
  }

  // from the not active list
  int findTilePosition(int topPosition, int leftPosition) {
    return widget.colNum * (topPosition + 1) - widget.colNum + leftPosition;
  }

  @override
  Widget build(BuildContext context) {
    // draw all the current squares
    return Stack(
      children: activeTileList.map((Tile tile) {
        return BoardTile(
          key: tile.key,
          sides: widget.sides,
          size: widget.tileSize,
          color: tile.color,
          topPosition:
              makeTileIntToSizeForPaint(tile.topPosition, widget.tileSize),
          leftPosition:
              makeTileIntToSizeForPaint(tile.leftPosition, widget.tileSize),
          removeTile: () => removeTile(tile),
          gravity: tile.gravity,
        );
      }).toList(),
    );
  }
}
