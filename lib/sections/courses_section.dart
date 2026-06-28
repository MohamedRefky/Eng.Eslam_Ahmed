import 'package:flutter/material.dart';
import '../core/widgets/section_title.dart';
import '../core/utils/app_localizations.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          SectionTitle(title: AppLocalizations.of(context)!.translate('courses')),
          const SizedBox(height: 24),
          // Content will be added later
        ],
      ),
    );
  }
}
