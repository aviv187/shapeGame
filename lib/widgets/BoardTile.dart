import 'package:flutter/material.dart';

import './shapePainter.dart';
import '../helpers/gravityEnum.dart';

class BoardTile extends StatefulWidget {
  final int sides;
  final double size;
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

  int duration = 1000;

  @override
  void didUpdateWidget(BoardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topPosition != widget.topPosition) {
      duration = (oldWidget.topPosition - widget.topPosition).abs().round() * 4;
    }
    if (oldWidget.leftPosition != widget.leftPosition) {
      duration =
          (oldWidget.leftPosition - widget.leftPosition).abs().round() * 4;
    }
  }

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
                    child: FlatButton(
                      onPressed: () {
                        widget.removeTile();
                      },
                      child: null,
                    ),
                  )),
      ),
      duration: Duration(milliseconds: duration),
    );
  }
}
