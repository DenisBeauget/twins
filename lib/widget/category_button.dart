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
    return Padding(padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
