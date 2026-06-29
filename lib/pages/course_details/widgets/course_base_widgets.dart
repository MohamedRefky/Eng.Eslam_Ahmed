// ─────────────────────────────────────────────────────────────────────────────
// Base UI primitives shared across all course-details section widgets
// Contains: CourseGlassCard, CourseSectionLabel, CourseSectionWrapper
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ── CourseGlassCard ───────────────────────────────────────────────────────────
class CourseGlassCard extends StatelessWidget {
  final Widget child;
  const CourseGlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── CourseSectionLabel ────────────────────────────────────────────────────────
class CourseSectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const CourseSectionLabel({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// ── CourseSectionWrapper ──────────────────────────────────────────────────────
/// Generic wrapper: Padding → GlassCard → Column → SectionLabel → child
class CourseSectionWrapper extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final double bottomPadding;
  final double childTopSpacing;

  const CourseSectionWrapper({
    super.key,
    required this.label,
    required this.icon,
    required this.child,
    this.bottomPadding = 24,
    this.childTopSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: CourseGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseSectionLabel(label: label, icon: icon),
            SizedBox(height: childTopSpacing),
            child,
          ],
        ),
      ),
    );
  }
}
