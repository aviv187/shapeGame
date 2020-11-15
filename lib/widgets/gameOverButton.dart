import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/database.dart';

class GameOverButton extends StatefulWidget {
  final Function restartGame;
  final String gameScore;

  GameOverButton({
    @required this.restartGame,
    @required this.gameScore,
  });

  @override
  _GameOverButtonState createState() => _GameOverButtonState();
}

class _GameOverButtonState extends State<GameOverButton> {
  TextEditingController _textEditingController = TextEditingController();
  bool canSave = true;

  void _insert(String name, String time) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnScore: time,
    };

    await DatabaseHelper.instance.insert(row);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 80),
          Stack(
            children: <Widget>[
              // Stroked text as border.
              Text(
                'GameOver',
                style: TextStyle(
                  fontSize: 50,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Colors.black,
                ),
              ),
              // Solid text as fill.
              Text(
                'GameOver',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          FlatButton(
            padding: EdgeInsets.all(0),
            highlightColor: Colors.white,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white.withOpacity(0.7),
              ),
              child: Text(
                'Play Again',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            onPressed: () async {
              widget.restartGame();
              canSave = false;
            },
          ),
          SizedBox(height: 20),
          Text(
            widget.gameScore,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 180,
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Enter your Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    const Radius.circular(12.0),
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
          FlatButton(
            child: Text(
              'Save Score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            onPressed: canSave
                ? () async {
                    HapticFeedback.heavyImpact();

                    if (_textEditingController.text == '') {
                      _insert('player', widget.gameScore);
                    } else {
                      _insert(_textEditingController.text, widget.gameScore);
                    }

                    setState(() {
                      canSave = false;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
