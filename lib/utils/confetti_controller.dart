import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twins_front/theme.dart';

final ConfettiController confettiController =
ConfettiController(duration: const Duration(seconds: 2));

Widget integrateConfetti(Widget screen) {
  return Stack(
    children: [
      screen,
      Align(
        alignment: Alignment.center,
        child: ConfettiWidget(
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.3,
          numberOfParticles: 50,
          minBlastForce: 10,
          maxBlastForce: 50,
          colors: [MaterialTheme.darkScheme().primary,MaterialTheme.darkScheme().secondary],
        ),
      ),
    ],
  );
}