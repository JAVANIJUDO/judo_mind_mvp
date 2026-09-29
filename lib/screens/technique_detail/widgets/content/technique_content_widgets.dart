import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';

/// Reusable, localization-neutral disclosure surface for long technique
/// explanations. Directionality is inherited from the selected app locale.
class TechniqueExpandableContentSection extends StatelessWidget {
  const TechniqueExpandableContentSection({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.child,
    this.initiallyExpanded = false,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return JudoCard(
      padding: EdgeInsets.zero,
      borderColor: accentColor.withValues(alpha: 0.25),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          key: key,
          initiallyExpanded: initiallyExpanded,
          maintainState: true,
          leading: Icon(icon, color: accentColor, size: JudoIconSize.sm),
          title: Text(
            title,
            style: JudoTypography.titleMedium.copyWith(color: accentColor),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            JudoSpacing.md,
            0,
            JudoSpacing.md,
            JudoSpacing.md,
          ),
          children: [child],
        ),
      ),
    );
  }
}

/// Zoom/accessibility wrapper for a future approved technique diagram.
/// Asset ownership and display eligibility are enforced by the data adapter.
class TechniqueZoomableVisual extends StatelessWidget {
  const TechniqueZoomableVisual({
    super.key,
    required this.semanticLabel,
    required this.child,
  });

  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        boundaryMargin: const EdgeInsets.all(JudoSpacing.xl),
        child: child,
      ),
    );
  }
}

class TechniqueTextContent extends StatelessWidget {
  final String title;
  final String text;
  final String emptyMessage;
  final IconData icon;
  final Color accentColor;
  final Key? contentKey;

  const TechniqueTextContent({
    super.key,
    required this.title,
    required this.text,
    required this.emptyMessage,
    required this.icon,
    required this.accentColor,
    this.contentKey,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedText = text.trim();

    return JudoCard(
      borderColor: accentColor.withValues(alpha: 0.28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: JudoIconSize.sm),
          const SizedBox(width: JudoSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: JudoTypography.titleMedium.copyWith(
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: JudoSpacing.sm),
                Text(
                  normalizedText.isEmpty ? emptyMessage : normalizedText,
                  key: contentKey,
                  style: JudoTypography.bodyMedium.copyWith(
                    color: normalizedText.isEmpty
                        ? JudoColors.textSecondary
                        : JudoColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TechniqueContentList extends StatelessWidget {
  final String title;
  final List<String> items;
  final String emptyMessage;
  final IconData icon;
  final Color accentColor;
  final String itemKeyPrefix;

  const TechniqueContentList({
    super.key,
    required this.title,
    required this.items,
    required this.emptyMessage,
    required this.icon,
    required this.accentColor,
    required this.itemKeyPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final visibleItems = items
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContentHeading(title: title, icon: icon, accentColor: accentColor),
        const SizedBox(height: JudoSpacing.md),
        if (visibleItems.isEmpty)
          TechniqueContentNotice(
            key: ValueKey<String>('$itemKeyPrefix-empty'),
            message: emptyMessage,
            icon: Icons.info_outline_rounded,
            accentColor: JudoColors.textSecondary,
          )
        else
          ...List.generate(visibleItems.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
              child: JudoCard(
                key: ValueKey<String>('$itemKeyPrefix-$index'),
                padding: const EdgeInsets.all(JudoSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: accentColor,
                      size: JudoIconSize.sm,
                    ),
                    const SizedBox(width: JudoSpacing.sm),
                    Expanded(
                      child: Text(
                        visibleItems[index],
                        style: JudoTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class TechniqueContentNotice extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color accentColor;

  const TechniqueContentNotice({
    super.key,
    required this.message,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return JudoCard(
      borderColor: accentColor.withValues(alpha: 0.25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: JudoIconSize.sm),
          const SizedBox(width: JudoSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TechniqueMetadataItem extends StatelessWidget {
  final String label;
  final String value;
  final String unavailableLabel;

  const TechniqueMetadataItem({
    super.key,
    required this.label,
    required this.value,
    required this.unavailableLabel,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedValue = value.trim();

    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: JudoTypography.labelSmall.copyWith(
              color: JudoColors.textSecondary,
            ),
          ),
          const SizedBox(height: JudoSpacing.xs),
          Text(
            normalizedValue.isEmpty ? unavailableLabel : normalizedValue,
            style: JudoTypography.titleSmall.copyWith(
              color: normalizedValue.isEmpty
                  ? JudoColors.textSecondary
                  : JudoColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentHeading extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;

  const _ContentHeading({
    required this.title,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: JudoIconSize.sm),
        const SizedBox(width: JudoSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: JudoTypography.headingSmall.copyWith(color: accentColor),
          ),
        ),
      ],
    );
  }
}
