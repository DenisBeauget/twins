import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/main.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/screen/payment_screen.dart';
import 'package:twins_front/services/deeplink_service.dart';
import 'package:twins_front/utils/confetti_controller.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService.userAlreadyExists(context);
    DeeplinkService.handleDeepLink(context);
    final isAdmin = Provider.of<AuthController>(context).isAdmin;
    final screenindexprovider = Provider.of<ScreenIndexProvider>(context);
    int navBarIndex = screenindexprovider._index;
    const List<Widget> widgetOptions = <Widget>[
      HomeScreen(),
      HomeScreen(),
      PaymentScreen(),
      AdminScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: navBarIndex,
        key: key,
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navBarIndex,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: '',
            activeIcon: Icon(Icons.home),
            key: Key('home'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: '',
            activeIcon: Icon(Icons.search),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: '',
            activeIcon: Icon(Icons.payment),
          ),
          if (isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined),
              label: '',
              activeIcon: Icon(Icons.admin_panel_settings),
            ),
        ],
        onTap: (index) {
          navBarIndex = index;
          screenindexprovider.setIndex(index);
          Haptics.vibrate(HapticsType.light);
        },
      ),
    );
  }
}

class ScreenIndexProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
