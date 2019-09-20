//Flutter and Dart import
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/costumTheme.dart';
import 'package:Tekel/providerSetup.dart';
import './ui/pages/homePage.dart';
import 'package:Tekel/core/custom/customMobileOrientation.dart';
import './router.dart' as router;

void main() {
  setPortraitOrientation();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConfettiController controllerTopCenter;

  @override
  void initState() {
    controllerTopCenter = ConfettiController(duration: Duration(seconds: 5));
    super.initState();
  }

  @override
  void dispose() {
    controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Tekel',
        theme: costumTheme,
        home: Stack(
          children: <Widget>[
            ListenableProvider<ConfettiController>.value(
              value: controllerTopCenter,
              child: HomePage(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: controllerTopCenter,
                blastDirection: pi / 2,
                maxBlastForce: 10,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 5,
              ),
            ),
          ],
        ),
        onGenerateRoute: router.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
