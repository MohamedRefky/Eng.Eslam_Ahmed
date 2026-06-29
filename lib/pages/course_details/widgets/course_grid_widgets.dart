// ─────────────────────────────────────────────────────────────────────────────
// Grid & chip widgets used inside course-details sections
// Contains: CourseChecksGrid, CourseProgramsGrid, CourseDrawingsGrid
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ── CourseChecksGrid ──────────────────────────────────────────────────────────
class CourseChecksGrid extends StatelessWidget {
  final List<String> items;
  const CourseChecksGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((check) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 16),
              const SizedBox(width: 8),
              Text(check, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── CourseProgramsGrid ────────────────────────────────────────────────────────
class CourseProgramsGrid extends StatelessWidget {
  final List<String> items;
  const CourseProgramsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((program) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.code_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                program,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── CourseDrawingsGrid ────────────────────────────────────────────────────────
class CourseDrawingsGrid extends StatelessWidget {
  final List<String> items;
  final bool isMobile;
  const CourseDrawingsGrid({super.key, required this.items, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final bool useVerticalList = items.any((item) => item.length > 30);

    if (useVerticalList) {
      return Column(
        children: items.asMap().entries.map((entry) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NumberBadge(number: entry.key + 1),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.asMap().entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NumberBadge(number: entry.key + 1, size: 22),
              const SizedBox(width: 8),
              Text(
                entry.value,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── _NumberBadge (private helper) ─────────────────────────────────────────────
class _NumberBadge extends StatelessWidget {
  final int number;
  final double size;
  const _NumberBadge({required this.number, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
