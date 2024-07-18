import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';

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
          emissionFrequency: 0.1,
          numberOfParticles: 25,
          minBlastForce: 10,
          maxBlastForce: 50,
        ),
      ),
    ],
  );
}