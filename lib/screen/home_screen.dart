import 'package:flutter/material.dart';
import 'package:twins_front/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthService.logout();
    return Container();
  }
}
