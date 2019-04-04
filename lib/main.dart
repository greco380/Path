import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';
import './colors.dart';
import 'dart:math';

double abs(double a) {
  return a < 0 ? -a : a;
}

void main() => runApp(App());

class App extends StatelessWidget {
    @override Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Path Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: GamePage(title: 'Path'),
        );
    }
}

class GamePage extends StatefulWidget {
    GamePage({Key key, this.title}) : super(key: key);

    final String title;

    @override _GamePageState createState() => _GamePageState();
}

class GamePainter extends CustomPainter {
  Offset clickPos = new Offset(10, 10);
  int time;

  GamePainter(this.clickPos, this.time);

  get obstacle => null;

  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = BLUE_NORMAL
      ..isAntiAlias = true
      ..strokeWidth = 15;

      var paintObstacle = Paint()
      ..style = PaintingStyle.fill
      ..color = RED_NORMAL
      ..isAntiAlias = true
      ..strokeWidth = 15;

    double time = this.time / 200;
    canvas.drawLine(
      new Offset(0, 0),
      new Offset(100 *  abs(cos(time)),100 * sin(time)),
      paint
    );
    canvas.drawCircle(
      new Offset(100 * abs(cos(time)),100 * sin(time)), // player position
      30, // radius
      paint // position
    );

      //WHY DOES THIS WORK BUT MY drawObstacle DOESN'T?!?!?
    // canvas.drawCircle(
    //   new Offset(100 * abs(cos(time)),100 * sin(time)), // player position
    //   30, // radius
    //   paint // position
    // );

    drawObstacle(canvas);
      
      
      //   var randInt = new Random();
      //   for (var i = 0; i < size.width; i++) {
      //     int randWidth = randInt.nextInt(size.width);
      //   }
      
      
      // //class GamePainter extends CustomPainter {
      //   Offset obsticalPos = new Offset(rand[0, size.width]);
      
      //       canvas.drawCircle(
      //         randWidth, // player position
      //         15, // radius
      //         paintObstacle // position
      //       );
      // //rand[0, size.width]
      //     }
      
          canvas.save();
          canvas.restore();
        }

  drawObstacle(Canvas canvas) {
    var drawObstacle = obstacle;
        canvas.obstacle(
    new Offset(int nextInt(int max));
          30, // radius
          paint // position
        );
  }
      
        bool shouldRepaint(CustomPainter oldDelegate) => true;
      
        double nextInt(Type int, Function<T extends num>(a, b) max) {}
}


class Game extends StatefulWidget {
  @override _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  Offset clickPosition = new Offset(-1, -1);

  Stopwatch stopwatch;
  Timer timer;

  Duration duration;

  _GameState() {
    this.stopwatch = Stopwatch();
    this.stopwatch.reset();
    this.stopwatch.start();

    this.timer = new Timer.periodic(new Duration(milliseconds: 30), (Timer timer) {
      setState(() {
        duration = stopwatch.elapsed;
      });
    });
  }

  @override Widget build(BuildContext context) {
    return new GestureDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          clickPosition = details.globalPosition;
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          clickPosition = details.globalPosition;
        });
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          clickPosition = new Offset(-1, -1);
        });
      },


      child: Container(
        child: CustomPaint(
          painter: GamePainter(clickPosition, stopwatch.elapsedMilliseconds)
        ),
        constraints: BoxConstraints.expand() // make it fullscreen
      )
    );
  }
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Game()
    );
  }
}







