import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
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
