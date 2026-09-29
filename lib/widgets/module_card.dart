import 'package:flutter/material.dart';

import '../models/module_model.dart';

class ModuleCard extends StatelessWidget {
  final ModuleModel module;

  const ModuleCard({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: module.isReachable
          ? () => Navigator.pushNamed(context, module.route!)
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: const Color(0xFF111111),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: const Color(0xFF0066FF)),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (module.icon != null)
              Icon(module.icon, color: const Color(0xFFD4AF37), size: 35),

            const SizedBox(height: 10),

            Text(
              module.title,

              textAlign: TextAlign.center,

              style: const TextStyle(
                color: Colors.white,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
