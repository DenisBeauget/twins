import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/services/auth_service.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<AuthController>(context).firstName;

    return Container(
        width: 100,
        decoration: BoxDecoration(border: Border.all()),
        child: Text(overflow: TextOverflow.ellipsis, 'Hello $name'));
  }
}
