import 'package:flutter/material.dart';
import '../core/widgets/section_title.dart';

class DefineSection extends StatelessWidget {
  const DefineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          SectionTitle(title: 'Define Eng Eslam Ahmed'),
          SizedBox(height: 24),
          // Content will be added later
        ],
      ),
    );
  }
}
