import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:twins_front/style/style_schema.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String? content;
  final VoidCallback onConfirm;

  const PopupDialog({super.key, 
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {

    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: btnDialogStyle(),
          onPressed: onConfirm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
