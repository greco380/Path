import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';
import './colors.dart';

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
  Random rand = new Random(12);

  Offset clickPos = new Offset(10, 10);
  int time;

  Canvas canvas;
  Size dimensions;

  GamePainter(this.clickPos, this.time);

  void paintPivot(double r, double l, int side) {
    double radius = r * dimensions.width;
    double location = l * dimensions.width;
    int speed = 500;
  
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = BLUE_NORMAL
      ..isAntiAlias = true
      ..strokeWidth = 15;

    double time = this.time / speed + rand.nextInt(500);

    Offset position = new Offset(
      -(side * 2 - 1) * radius *  abs(cos(time)) + dimensions.width * side,
      radius * sin(time) + dimensions.height - location
    );
    
    canvas.drawLine(
      new Offset(dimensions.width * side, dimensions.height - location),
      position,
      paint
    );
    canvas.drawCircle(
      position,
      30,
      paint
    );
  }

  get obstacle => null;
  
  void paint(Canvas canvas, Size size) {
    this.dimensions = size;
    this.canvas = canvas;

    // setup randomizer
    this.rand = new Random(12);

    // draw pivots
    double dist = rand.nextDouble();
    paintPivot(dist, dist, 1);

    for (var i = 0; i < 3; i++) {
      double radious = rand.nextDouble();
      dist += rand.nextDouble();
      paintPivot(radious, dist, i % 2);
    }

    // draw obstacles
    drawObstacle();
      
    // draw to screen
    canvas.save();
    canvas.restore();
  }

  void drawObstacle() {
    int width = this.rand.nextInt(100);
    
  }

  bool shouldRepaint(CustomPainter oldDelegate) => true;
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