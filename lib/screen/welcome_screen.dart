import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:twins_front/screen/app_explanation_1.dart';
import 'package:twins_front/screen/app_explanation_2.dart';
import 'package:twins_front/screen/app_explanation_3.dart';
import 'package:twins_front/screen/auth_screen.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1.1,
              aspectRatio: 5,
              height: double.maxFinite,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              animateToClosest: true,
              initialPage: 0,
              scrollDirection: Axis.vertical,
              scrollPhysics: const BouncingScrollPhysics(),

            ),
            items: const [
              AppExplanation1(),
              AppExplanation2(),
              AppExplanation3()
            ]
        ));
  }

}