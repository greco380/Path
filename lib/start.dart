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
            //home: GamePage(title: 'Path'),
        );
    }
}

// class GamePage extends StatefulWidget {
//     GamePage({Key key, this.title}) : super(key: key);

//     final String title;

//     //@override _GamePageState createState() => _GamePageState();
// }