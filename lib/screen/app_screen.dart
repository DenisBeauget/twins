import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/main.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/screen/payment_screen.dart';
import 'package:twins_front/screen/profil_screen.dart';
import 'package:twins_front/services/deeplink_service.dart';
import 'package:twins_front/utils/confetti_controller.dart';
import 'package:twins_front/utils/toaster.dart';

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
      ProfilScreen(),
      AdminScreen()
    ];

    return Scaffold(
      body: IndexedStack(
        index: navBarIndex,
        key: key,
        children: widgetOptions,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            height: 2,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navBarIndex,
            selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
            items: [
              BottomNavigationBarItem(
                icon: buildIcon(const Icon(IconsaxPlusLinear.home_2)),
                label: '',
                activeIcon: buildIcon(const Icon(IconsaxPlusBold.home_2)),
              ),
              BottomNavigationBarItem(
                icon: buildIcon(const Icon(IconsaxPlusLinear.search_normal_1)),
                label: '',
                activeIcon:
                    buildIcon(const Icon(IconsaxPlusBold.search_normal_1)),
              ),
              BottomNavigationBarItem(
                  icon: buildIcon(const Icon(IconsaxPlusLinear.profile)),
                  label: '',
                  activeIcon: buildIcon(const Icon(IconsaxPlusBold.profile))),
              if (isAdmin)
                BottomNavigationBarItem(
                  icon: buildIcon(const Icon(IconsaxPlusLinear.edit)),
                  label: '',
                  activeIcon: buildIcon(const Icon(IconsaxPlusBold.edit)),
                ),
            ],
            onTap: (index) {
              navBarIndex = index;
              screenindexprovider.setIndex(index);
              Haptics.vibrate(HapticsType.light);
            },
          ),
        ],
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

Widget buildIcon(Icon icon) {
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: icon,
  );
}
