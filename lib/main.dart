import 'package:flutter/material.dart';
import './colors.dart';

void main() => runApp(App());

class App extends StatelessWidget {
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

    @override _GamePageState createState() => _GamePageState();
}

class GamePainter extends CustomPainter {
  Offset clickPos = new Offset(10, 10);

  GamePainter(this.clickPos);

  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = BLUE_NORMAL
      ..isAntiAlias = true
      ..strokeWidth = 15;


    //var playerPosition = Offset(size.width / 2, size.height - 30);

    if (clickPos.dx != -1) {
      canvas.drawLine(
        new Offset(0,0),
        this.clickPos,
        paint
      );
      canvas.drawCircle(
        this.clickPos, // player position
        30, // radius
        paint // position
      );
    }

    canvas.save();
    canvas.restore();
  }

  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Game extends StatefulWidget {
  @override _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  Offset clickPosition = new Offset(-1, -1);

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
          painter: GamePainter(clickPosition)
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
