import 'package:flutter/material.dart';

import '../helpers/database.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<Map> yourScoreList = [];

  void _getYourScoreboard() async {
    List<Map> list = await DatabaseHelper.instance.queryAll();
    setState(() => yourScoreList = list);
  }

  @override
  void initState() {
    super.initState();
    _getYourScoreboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 300,
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                  'Your Score Board',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                (yourScoreList.isEmpty)
                    ? Text('empty :(')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: yourScoreList.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 10,
                          ),
                          itemBuilder: (BuildContext context, int i) {
                            return Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('${i + 1}. ${yourScoreList[i]['name']}'),
                                  Text(yourScoreList[i]['score']),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
