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

  bool clicked = false;

  int id = 1;

  Map<String, int> data;

  GamePainter(this.clickPos, this.time, this.clicked, this.data);

  Offset paintPivot(double r, double l, int offset, int spot) {
    double radius = r * dimensions.width;
    double location = l * dimensions.width;
    int side = spot % 2;
    int speed = 1000;
  
    var paint;
    if (this.data["id"] == spot) {
      paint = Paint()
        ..style = PaintingStyle.fill
        ..color = BLUE_NORMAL
        ..isAntiAlias = true
        ..strokeWidth = 15;
    } else {
      paint = Paint()
        ..style = PaintingStyle.fill
        ..color = BLUE_LIGHT
        ..isAntiAlias = true
        ..strokeWidth = 15;
    }

    double time = (this.time / speed) + offset;

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

    return position;
  }

  get obstacle => null;
  
  void paint(Canvas canvas, Size size) {
    this.dimensions = size;
    this.canvas = canvas;

    // setup randomizer
    this.rand = new Random(12);

    // draw pivots
    double dist = .3;
    double prevRadius = dist;
    int prevAngle = 0;
    Offset prevPosition = paintPivot(prevRadius, dist, prevAngle, 1);

    for (var i = 2; i < 5; i++) {
      double radius = 1 - prevRadius + getDouble(0, prevRadius);
      int angle = 180 - prevAngle;
      dist += sqrt(pow(radius + prevRadius, 2) - 1);
      Offset position = paintPivot(radius, dist, angle, i);

      if (this.data["clicked"] == 1 && this.data["id"] == i - 1) {
        double dist = pow(prevPosition.dx - position.dx, 2) + pow(prevPosition.dy - position.dy, 2);
        if (dist <= pow(60, 2)) {
          this.data["id"] += 1;
        }
      }

      prevAngle = angle;
      prevRadius = radius;
    }

    // draw obstacles
    drawObstacle();
    
    // draw to screen
    this.data["clicked"] = 0;
    canvas.save();
    canvas.restore();
  }

  double getDouble(double min, double max) {
    return rand.nextDouble() * (max - min) + min;
  }

  void drawObstacle() {
    double x = this.rand.nextDouble() * this.dimensions.width;
    double y = this.rand.nextDouble() * this.dimensions.height;

    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = RED_NORMAL
      ..isAntiAlias = true
      ..strokeWidth = 15;

    this.canvas.drawCircle(
      Offset(x, y),
      15,
      paint
    );
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

  bool clicked = false;

  Map<String, int> data = {"id": 1, "clicked": 0};

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
      onTapDown: (TapDownDetails details) {
        setState(() {
          data["clicked"] = 1;
        });
      },

      child: Container(
        child: CustomPaint(
          painter: GamePainter(clickPosition, stopwatch.elapsedMilliseconds, clicked, data)
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