//Flutter and Dart import
import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Tekel',
        theme: costumTheme,
        home: HomePage(),
        onGenerateRoute: router.generateRoute,
        initialRoute: '/',
        //debugShowCheckedModeBanner: false,
      ),
    );
  }
}
