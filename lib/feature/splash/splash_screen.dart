import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:night_fall_restaurant/feature/main_tables/main_table_screen.dart';

class SplashScreen extends StatefulWidget {
  static const splashRoute = '/';

  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String lottieFilePath = 'assets/anim/animation_lnom89oi.json';
  static LottieBuilder lottieAnimation =
      Lottie.asset(lottieFilePath, width: 360, height: 360);
  static const Color textColor = Color(0xffdfdff3);
  static const Color backgroundColor = Color(0xFF0B1B26);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      await MainTableScreen.open(context);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(child: lottieAnimation),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Night fall Restaurant',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 36.0,
                        fontFamily: 'GreatVibes'),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
