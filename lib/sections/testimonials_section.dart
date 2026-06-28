import 'package:flutter/material.dart';
import '../core/widgets/section_title.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          SectionTitle(title: 'اراء العملاء (Customer Reviews)'),
          SizedBox(height: 24),
          // Content will be added later
        ],
      ),
    );
  }
}
