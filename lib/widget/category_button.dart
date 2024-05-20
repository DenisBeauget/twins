import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function() onPressed;

  const CategoryButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Text(text),
    );
  }
}
