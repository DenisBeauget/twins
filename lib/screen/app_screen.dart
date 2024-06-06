import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/bloc/category_bloc.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/component/fade_indexed_stack.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/widget/category_button.dart';
import 'package:twins_front/widget/featured_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_screen.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthController>(context).isAdmin;
    final _screenindexprovider = Provider.of<ScreenIndexProvider>(context);
    int navBarIndex = _screenindexprovider._index;
    const List<Widget> _widgetOptions = <Widget>[
      HomeScreen(),
      HomeScreen(),
      AdminScreen()
    ];

    return Scaffold(
      body: IndexedStack(
        index: navBarIndex,
        key: key,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navBarIndex,
        selectedItemColor: Colors.green,
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
          if (isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: '',
              activeIcon: Icon(Icons.settings),
            ),
        ],
        onTap: (index) {
          navBarIndex = index;
          _screenindexprovider.setIndex(index);
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
