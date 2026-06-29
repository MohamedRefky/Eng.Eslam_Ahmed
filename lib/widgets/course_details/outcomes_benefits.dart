import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'section_label.dart';

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
