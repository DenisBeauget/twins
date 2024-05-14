import 'package:flutter/material.dart';
import 'package:twins_front/style/style_schema.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset('assets/img/twins logo bg removed.png'),
      ),
    );
  }
}