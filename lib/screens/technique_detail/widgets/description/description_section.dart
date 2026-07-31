import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  final String title;
  final String description;

  const DescriptionSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedDescription = description.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF).withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: Color(0xFF4D94FF),
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            normalizedDescription.isEmpty
                ? 'Description is not available.'
                : normalizedDescription,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}