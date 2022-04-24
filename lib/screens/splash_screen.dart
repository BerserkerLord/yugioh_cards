import 'package:flutter/material.dart';
import 'package:yugioh_cards/screens/list_card_screen.dart';
import 'package:yugioh_cards/settings/settings_color.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const Cards(),
      duration: 5000,
      imageSize: 110,
      imageSrc: "assets/logo.png",
      textType: TextType.ScaleAnimatedText,
      backgroundColor: SettingsColor.backColor,
    );
  }
}