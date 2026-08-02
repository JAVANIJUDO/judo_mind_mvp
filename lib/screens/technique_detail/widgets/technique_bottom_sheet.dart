import 'package:flutter/material.dart';

import '../../../core/theme/judo_design_tokens.dart';
import '../../../core/theme/judo_typography.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Widget: Technique Bottom Sheet
/// Module: Techniques
/// Design System: JMDS
/// Version: 3.0.0
/// ----------------------------------------------------------------
///
/// Provides one unified presentation for all Technique sections.
///
/// Design rules:
/// - Compact header
/// - Small contextual icon
/// - Clear title
/// - Accessible close action
/// - Draggable and scrollable content
/// - No large decorative icon container
class TechniqueBottomSheet {
  const TechniqueBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    IconData? icon,
    Color accentColor = JudoColors.primary,
    double initialChildSize = 0.78,
    double minChildSize = 0.45,
    double maxChildSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.72,
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (
            context,
            scrollController,
          ) {
            return _TechniqueBottomSheetContent(
              title: title,
              icon: icon,
              accentColor: accentColor,
              scrollController: scrollController,
              child: child,
            );
          },
        );
      },
    );
  }
}

class _TechniqueBottomSheetContent
    extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color accentColor;
  final ScrollController scrollController;
  final Widget child;

  const _TechniqueBottomSheetContent({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.scrollController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: JudoColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              JudoRadius.xl,
            ),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: JudoSpacing.sm,
            ),

            _DragHandle(
              accentColor: accentColor,
            ),

            _CompactSheetHeader(
              title: title,
              icon: icon,
              accentColor: accentColor,
              onClose: () {
                Navigator.of(context).pop();
              },
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: accentColor.withValues(
                alpha: 0.16,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  JudoSpacing.lg,
                  JudoSpacing.lg,
                  JudoSpacing.lg,
                  JudoSpacing.xxxl,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  final Color accentColor;

  const _DragHandle({
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: accentColor.withValues(
          alpha: 0.34,
        ),
        borderRadius: BorderRadius.circular(
          JudoRadius.sm,
        ),
      ),
    );
  }
}

class _CompactSheetHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color accentColor;
  final VoidCallback onClose;

  const _CompactSheetHeader({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        JudoSpacing.lg,
        JudoSpacing.md,
        JudoSpacing.sm,
        JudoSpacing.md,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: accentColor,
              size: 21,
            ),

            const SizedBox(
              width: JudoSpacing.sm,
            ),
          ],

          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  JudoTypography.titleLarge.copyWith(
                color: JudoColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(
            width: JudoSpacing.xs,
          ),

          Semantics(
            button: true,
            label: 'Close',
            child: IconButton(
              tooltip: 'Close',
              onPressed: onClose,
              visualDensity:
                  VisualDensity.compact,
              constraints: const BoxConstraints(
                minWidth: 38,
                minHeight: 38,
              ),
              icon: const Icon(
                Icons.close_rounded,
                color: JudoColors.textSecondary,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}