import 'package:flutter/material.dart';
import 'package:lije/features/pregnancy_calc/services/calculator_constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: BC.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BC.borderLight, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: BC.primary.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4))
          ],
        ),
        child: child,
      );
}

class GlassBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const GlassBtn({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: BC.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BC.border),
            boxShadow: [
              BoxShadow(
                  color: BC.primary.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Center(child: child),
        ),
      );
}
