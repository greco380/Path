import 'package:flutter/material.dart';
import './colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
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

    @override
    _GamePageState createState() => _GamePageState();
}

class GamePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = BLUE_NORMAL
      ..isAntiAlias = true;


    var playerPosition = Offset(size.width / 2, size.height - 30);

    canvas.drawCircle(
      playerPosition, // player position
      30, // radius
      paint // position
    );

    canvas.save();
    canvas.restore();
  }

  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _GamePageState extends State<GamePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
              child: CustomPaint(
                painter: GamePainter()
              ),
              constraints: BoxConstraints.expand() // make it fullscreen
            )
        );
    }
}
