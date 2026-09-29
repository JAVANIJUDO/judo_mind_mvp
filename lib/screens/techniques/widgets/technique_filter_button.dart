import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class TechniqueFilterButton extends StatelessWidget {
  const TechniqueFilterButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.filter_alt, color: Color(0xFFD4AF37)),
      label: Text(l10n.filtersTitle),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(45),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF0066FF)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
