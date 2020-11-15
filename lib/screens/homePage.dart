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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HomePageButton(
                text: 'Start',
                page: Board(),
              ),
              HomePageButton(
                page: ScorePage(),
                text: 'Scores',
              ),
            ]));
  }
}

class HomePageButton extends StatelessWidget {
  final String text;
  final Widget page;

  HomePageButton({@required this.page, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text(text),
        onPressed: () {
          HapticFeedback.heavyImpact();
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => page,
            ),
          );
        },
      ),
    );
  }
}
