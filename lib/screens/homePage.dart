import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './board.dart';
import './scorePage.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Polygons'),
          elevation: 0,
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Start'),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => Board(),
                ),
              );
            },
          ),
        ));
  }
}
