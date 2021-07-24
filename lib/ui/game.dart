import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

int _bestScore = 60;

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  var _numbersList = new List();
  var value, iterator = 0;
  Color myColor = Colors.red;
  List<bool> _selectedItems = List.generate(25, (i) => false);
  int _counter = 0;
  Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  bool startIsPressed = false;

  @override
  Widget build(BuildContext context) {
    printNumbersToTable();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          child: Text(
                            " START ",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            iterator++;
                            setState(() {
                              _startTimer(context);
                              startIsPressed = true;
                            });
                          },
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          child: Text(
                            "RESTART",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _counter = 0;
                            });
                            _timer.cancel();
                            _selectedItems = List.generate(25, (i) => false);
                            iterator = 0;
                            showToastMessage();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Game(),
                              ),
                            );
                          },
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "$_counter",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(numberBox, childCount: 25),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 10,
                    top: 15,
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    _bestScore == 60 ? "Best Score = 0" : "Best Score = $_bestScore",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void printNumbersToTable() {
    for (var i = 0; i < 1000; i++) {
      value = math.Random().nextInt(26);
      while (!_numbersList.contains(value) && value != 0) {
        _numbersList.add(value);
      }
    }
  }

  void _startTimer(BuildContext context) {
    _counter = 0;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter < 60) {
          _counter++;
        }
      });
    });
  }

  bool changeColorOfBox(int index) {
    if (startIsPressed && _selectedItems[index]) {
      return true;
    }

    return false;
  }

  void showToastMessage() {
    Fluttertoast.showToast(
      msg: "GAME RESTARTED",
      textColor: Colors.white,
      fontSize: 20,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.cyan[600],
    );
  }

  void showGameOverAlert(BuildContext ctx, var index) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Center(child: Text("GAME OVER")),
          content: SingleChildScrollView(
              //alertbox'ta scroll özelliği tanımlamak için kullandık
              child: ListBody(
            children: [
              Text(
                "Your Score: $_counter seconds \n\nDo you want to play again?",
                style: TextStyle(),
              ),
            ],
          )),
          actions: <Widget>[
            ButtonBar(
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _counter = 0;
                      printNumbersToTable();
                    });
                    _timer.cancel();
                    _selectedItems = List.generate(25, (i) => false);
                    iterator = 0;
                    showToastMessage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Game(),
                      ),
                    );
                  },
                  child: Text("YES"),
                  color: Colors.green,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("NO"),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showTimeOverAlert(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Center(child: Text("TIME OVER")),
          content: Text(
            "You must complete the game in 60 seconds!",
            style: TextStyle(),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  Widget numberBox(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_numbersList[index] == iterator) {
            _selectedItems[index] = true;
            iterator++;
          }
          if (iterator == 26) {
            _timer.cancel();
            if (_counter < _bestScore) {
              _bestScore = _counter;
            }
            showGameOverAlert(context, index);
          }
          //changeColorOfBox(index);
        });
      },
      child: Container(
        margin: EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.teal[300],
          border: Border.all(
            color: Colors.lightGreen,
            width: 3,
            style: BorderStyle.solid,
          ),
          gradient: LinearGradient(
            colors: [Colors.yellow[100], changeColorOfBox(index) ? Colors.cyan[900] : Colors.yellow[600]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Text(
          "${_numbersList[index]}",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
