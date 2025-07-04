import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:zad_aldaia/features/onboarding/presentation/screens/user_type_screen.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<Introduction> list = [
    Introduction(
      title: 'Welcome to Zad Al-Daiya',
      subTitle: 'A comprehensive da\'wah platform for spreading Islam and educating new Muslims',
      imageUrl: 'assets/images/png/onboarding1.png',
      titleTextStyle: TextStyle(
        fontSize: 26,
            fontFamily: 'Exo',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subTitleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.5),
      ),
    ),
    Introduction(
      title: 'Learn Your Religion Easily',
      subTitle: 'Lessons, videos, books - everything you need to understand Islam',
      imageUrl: 'assets/images/png/onboarding2.png',
      titleTextStyle: TextStyle(
        fontSize: 28,
          fontFamily: 'Exo',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subTitleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.5),
      ),
    ),
    Introduction(
      title: 'Be a Caller to Allah',
      subTitle: 'Contribute to spreading Islam and impact others\' lives',
      imageUrl: 'assets/images/png/onboarding4.png',
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontFamily: 'Exo',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subTitleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.5),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0FAE6), 
      body: IntroScreenOnboarding(
        backgroudColor: Color(0xFFF0FAE6),
        foregroundColor: Colors.green.shade700, 
        introductionList: list,
        onTapSkipButton: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserTypeScreen(),
          ),
        ),
        skipTextStyle:  TextStyle(
          color: Colors.grey.shade500,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}