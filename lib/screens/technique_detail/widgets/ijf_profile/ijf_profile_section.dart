import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';

class IjfProfileSection extends StatelessWidget {
  final TechniqueModel technique;

  const IjfProfileSection({
    super.key,
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(
            alpha: 0.70,
          ),
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
                  color: const Color(0xFFD4AF37).withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFFD4AF37),
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  l10n.ijfProfile,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const _OfficialBadge(),
            ],
          ),
          const SizedBox(height: 16),
          _ProfileRow(
            title: l10n.classification,
            value: technique.ijfClassification,
            icon: Icons.category_outlined,
          ),
          _ProfileRow(
            title: l10n.difficulty,
            value: technique.difficulty,
            icon: Icons.signal_cellular_alt_rounded,
          ),
          _ProfileRow(
            title: l10n.competitionUsage,
            value: technique.competitionUsage,
            icon: Icons.emoji_events_outlined,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _OfficialBadge extends StatelessWidget {
  const _OfficialBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(
            alpha: 0.40,
          ),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            color: Color(0xFFD4AF37),
            size: 14,
          ),
          SizedBox(width: 4),
          Text(
            'Official',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isLast;

  const _ProfileRow({
    required this.title,
    required this.value,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 12,
        top: isLast ? 2 : 0,
      ),
      margin: EdgeInsets.only(
        bottom: isLast ? 0 : 12,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white38,
            size: 19,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.trim().isEmpty
                  ? 'Not available'
                  : value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}