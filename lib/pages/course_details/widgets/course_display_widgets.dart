// ─────────────────────────────────────────────────────────────────────────────
// Display widgets: lists and tables used inside course-details sections
// Contains: CourseBulletList, CourseFaqList, CourseContentTable, CourseOutcomesBenefits
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'course_base_widgets.dart';

// ── CourseBulletList ──────────────────────────────────────────────────────────
class CourseBulletList extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final Color iconColor;

  const CourseBulletList({
    super.key,
    required this.items,
    this.icon = Icons.check_circle_rounded,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── CourseFaqList ─────────────────────────────────────────────────────────────
class CourseFaqList extends StatelessWidget {
  final List<dynamic> faqs;
  const CourseFaqList({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: faqs.map((faq) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.textSecondary,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Text(
              faq['question'] ?? '',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
            children: [
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 12),
              Text(
                faq['answer'] ?? '',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.7,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── CourseContentTable ────────────────────────────────────────────────────────
class CourseContentTable extends StatelessWidget {
  final List<dynamic> content;
  const CourseContentTable({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: content.asMap().entries.map((entry) {
        final isEven = entry.key % 2 == 0;
        return Container(
          decoration: BoxDecoration(
            color: isEven
                ? AppColors.background
                : AppColors.primary.withValues(alpha: 0.04),
            borderRadius: entry.key == 0
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : entry.key == content.length - 1
                    ? const BorderRadius.vertical(bottom: Radius.circular(12))
                    : BorderRadius.zero,
            border: Border(
              bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    entry.value['lecture'] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    entry.value['subject'] ?? '',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                Icon(
                  Icons.play_circle_outline_rounded,
                  color: AppColors.primary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── CourseOutcomesBenefits ────────────────────────────────────────────────────
class CourseOutcomesBenefits extends StatelessWidget {
  final String label;
  final List<String> items;
  final IconData icon;
  final Color iconColor;

  const CourseOutcomesBenefits({
    super.key,
    required this.label,
    required this.items,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourseSectionLabel(label: label, icon: icon),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
