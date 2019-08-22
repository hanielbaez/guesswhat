//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/costumTheme.dart';
import 'package:guess_what/providerSetup.dart';
import './ui/pages/homePage.dart';
import './router.dart' as router;

void main() => runApp(MyApp());

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
