import 'package:flutter/material.dart';
import './gravityEnum.dart';

class Tile {
  final Color color;
  final Key key;
  Gravity gravity;
  bool occupied;
  bool inRemoveList;
  int topPosition;
  int leftPosition;

  Tile({
    this.gravity,
    this.inRemoveList,
    @required this.key,
    this.color,
    @required this.leftPosition,
    @required this.topPosition,
    this.occupied = false,
  });
}
