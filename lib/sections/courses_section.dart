import 'package:flutter/material.dart';
import '../core/widgets/section_title.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          SectionTitle(title: 'Courses'),
          SizedBox(height: 24),
          // Content will be added later
        ],
      ),
    );
  }
}
