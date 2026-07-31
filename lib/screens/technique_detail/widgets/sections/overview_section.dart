import 'package:flutter/material.dart';


import '../../../../models/technique_model.dart';
class OverviewSection extends StatelessWidget {
  final TechniqueModel technique;

  const OverviewSection({
    super.key,
    required this.technique,
  });

  Widget _buildTile(String title, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (technique.images.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              technique.images.first,
              fit: BoxFit.cover,
            ),
          ),

        const SizedBox(height: 20),

        _buildTile("English Name", technique.englishName),

        _buildTile("Japanese Name", technique.japaneseName),

        _buildTile("Category", technique.category),

        _buildTile("Type", technique.type),

        _buildTile("Belt Level", technique.beltLevel),

        _buildTile("Difficulty", technique.difficulty),

        _buildTile("Description", technique.description),
      ],
    );
  }
}