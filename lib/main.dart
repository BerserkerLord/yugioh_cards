import 'package:flutter/material.dart';
import 'package:yugioh_cards/screens/splash_screen.dart';
import 'package:yugioh_cards/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: getApplicationRoutes(),
        home: const SplashScreen()
    );
  }
}
