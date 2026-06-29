import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

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
              bottom: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
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
