import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final void Function() onPressed;

  const CategoryButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
