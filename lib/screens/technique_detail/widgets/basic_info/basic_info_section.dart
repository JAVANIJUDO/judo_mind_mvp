import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/recent_techniques_provider.dart';
import '../../../../models/technique_model.dart';

class BasicInfoSection extends StatefulWidget {
  final TechniqueModel technique;

  const BasicInfoSection({
    super.key,
    required this.technique,
  });

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  bool _recentlyViewedRecorded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_recentlyViewedRecorded) {
      return;
    }

    _recentlyViewedRecorded = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context
          .read<RecentTechniquesProvider>()
          .addRecentTechnique(widget.technique.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0066FF).withValues(alpha: 0.70),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _InfoChip(
            label: 'Category',
            value: widget.technique.category,
          ),
          _InfoChip(
            label: 'Type',
            value: widget.technique.type,
          ),
          _InfoChip(
            label: 'Level',
            value: widget.technique.beltLevel,
          ),
          _InfoChip(
            label: 'Difficulty',
            value: widget.technique.difficulty,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF080808),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            height: 1.25,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Color(0xFF4D94FF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}