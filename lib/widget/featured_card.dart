import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? categoryName;

  const FeaturedCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          if (categoryName != null)
            Text(
              categoryName!,
              style: const TextStyle(color: Colors.white70),
            ),
        ],
      ),
    );
  }
}
