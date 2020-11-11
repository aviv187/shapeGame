import 'package:flutter/material.dart';

import './shapePainter.dart';
import '../models/gravityEnum.dart';

class BoardTile extends StatefulWidget {
  final int sides;
  final int size;
  final double topPosition;
  final double leftPosition;
  final Color color;
  final Function removeTile;
  final Gravity gravity;

  BoardTile({
    Key key,
    this.gravity,
    @required this.sides,
    @required this.size,
    @required this.topPosition,
    @required this.leftPosition,
    @required this.color,
    this.removeTile,
  }) : super(key: key);

  @override
  _BoardTileState createState() => _BoardTileState();
}

class _BoardTileState extends State<BoardTile> {
  double shapeAngle;

  @override
  Widget build(BuildContext context) {
    switch (widget.gravity) {
      case Gravity.top:
        shapeAngle = 30;
        break;
      case Gravity.bottom:
        shapeAngle = 90;
        break;
      case Gravity.left:
        shapeAngle = 60;
        break;
      case Gravity.right:
        shapeAngle = 0;
        break;
      default:
    }

    return AnimatedPositioned(
      top: widget.topPosition,
      left: widget.leftPosition,
      child: CustomPaint(
        painter: ShapePainter(
          color: widget.color,
          shapeSize: widget.size.toDouble(),
          shapeAngle: (widget.sides == 4) ? 45 : 30,
          sides: widget.sides,
        ),
        child: Container(
            height: widget.size.toDouble(),
            width: widget.size.toDouble(),
            child: (widget.gravity == null)
                ? null
                : CustomPaint(
                    painter: ShapePainter(
                      color: Colors.grey[400],
                      shapeSize: widget.size / 3.5,
                      shapeAngle: shapeAngle,
                      sides: 3,
                    ),
                    child: GameButton(widget.removeTile),
                  )),
      ),
      duration: Duration(milliseconds: 300),
    );
  }
}

class GameButton extends StatelessWidget {
  final Function removeTile;

  GameButton(this.removeTile);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (removeTile != null)
          ? () {
              removeTile();
            }
          : null,
      child: null,
    );
  }
}
