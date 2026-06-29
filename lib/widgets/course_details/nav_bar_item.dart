import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CourseNavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CourseNavBarItem({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        overlayColor: AppColors.primary,
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }
}
