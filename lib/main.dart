import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import './widgets/food.dart';
import './widgets/pixel.dart';
import './widgets/snake.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numberOfSquares = 540;
  int numberInRows = 20;
  bool gameHasStarted = false;
  List<int> snakePosition = [45, 65, 85, 105, 125];
  static var randomNumber = Random();

  void startGame() {
    if (gameHasStarted == false) {
      snakePosition = [45, 65, 85, 105, 125];
      gameHasStarted = true;
      myfood();
      const duration = const Duration(milliseconds: 175);
      Timer.periodic(duration, (Timer timer) {
        updateSnake();
        if (gameOver()) {
          timer.cancel();
          //_showGameOverScreen();
        }
      });
    }
  }

  var direction = "down";

  int food = 0;

  void myfood() {
    setState(() {
      food = randomNumber.nextInt(numberOfSquares - 1);
    });
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case "down":
          if (snakePosition.last > numberOfSquares) {
            snakePosition
                .add(snakePosition.last + numberInRows - numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last + numberInRows);
          }
          break;

        case "up":
          if (snakePosition.last < numberInRows) {
            snakePosition
                .add(snakePosition.last - numberInRows + numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last - numberInRows);
          }
          break;

        case "left":
          if (snakePosition.last % numberInRows == 0) {
            snakePosition.add(snakePosition.last + numberInRows - 1);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;

        case "right":
          if ((snakePosition.last + 1) % numberInRows == 0) {
            snakePosition.add(snakePosition.last - numberInRows + 1);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }
      if (snakePosition.last == food) {
        myfood();
      } else {
        snakePosition.removeAt(0);
        //print(snakePosition);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != "up" && details.delta.dy > 0) {
                  direction = "down";
                } else if (direction != "down" && details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != "left" && details.delta.dx > 0) {
                  direction = "right";
                  print("right");
                } else if (direction != "right" && details.delta.dx < 0) {
                  direction = "left";
                  print("left");
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberInRows),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return MySnake();
                      }
                      if (index == food) {
                        return MyFood();
                      } else {
                        return MyPixel();
                      }

                      // return Container(
                      //   padding: EdgeInsets.all(2),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(2),
                      //     child: Container(
                      //       color: Colors.grey[900],
                      //     ),
                      //   ),
                      // );
                    }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    if (gameHasStarted == false) {
                      startGame();
                    }
                  },
                  child: Center(
                    child: Text(
                      "s t a r t",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
