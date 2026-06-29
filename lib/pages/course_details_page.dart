import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../core/theme/app_colors.dart';

class CourseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const CourseDetailsPage({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final imagePath = courseData['image'] as String?;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                courseData['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              background: Container(
                color: theme.primaryColor,
                child: imagePath != null && !imagePath.contains('placeholder')
                    ? Image.asset(imagePath, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image, size: 80, color: Colors.white54)),
                      )
                    : const Center(child: Icon(Icons.menu_book, size: 100, color: Colors.white54)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: courseData['title'] ?? ''),
                    const SizedBox(height: 16),
                    Text(
                      courseData['description'] ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
                    ),
                    const SizedBox(height: 32),
                    
                    if (courseData['targetAudience'] != null) ...[
                      _SectionTitle(title: _translate(context, 'target_audience', 'لمن هذا الكورس')),
                      _BulletList(items: List<String>.from(courseData['targetAudience'])),
                      const SizedBox(height: 32),
                    ],

                    if (courseData['drawings'] != null) ...[
                      _SectionTitle(title: _translate(context, 'drawings', 'اللوحات التي سيتم رسمها')),
                      _NumberedList(items: List<String>.from(courseData['drawings'])),
                      const SizedBox(height: 32),
                    ],

                    if (courseData['projects'] != null) ...[
                      _SectionTitle(title: _translate(context, 'projects', 'المشاريع والتطبيقات')),
                      _BulletList(items: List<String>.from(courseData['projects']), icon: Icons.precision_manufacturing),
                      const SizedBox(height: 32),
                    ],
                    
                    if (courseData['faqs'] != null) ...[
                      _SectionTitle(title: _translate(context, 'faqs', 'الأسئلة الشائعة')),
                      _FaqList(faqs: List<dynamic>.from(courseData['faqs'])),
                      const SizedBox(height: 32),
                    ],

                    if (courseData['outcomes'] != null) ...[
                      _SectionTitle(title: _translate(context, 'outcomes', 'كيف سيصبح مستواك بعد الكورس')),
                      _BulletList(items: List<String>.from(courseData['outcomes']), icon: Icons.trending_up),
                      const SizedBox(height: 32),
                    ],

                    if (courseData['benefits'] != null) ...[
                      _SectionTitle(title: _translate(context, 'benefits', 'مميزات الاشتراك')),
                      _BulletList(items: List<String>.from(courseData['benefits']), icon: Icons.star),
                      const SizedBox(height: 32),
                    ],

                    if (courseData['content'] != null) ...[
                      _SectionTitle(title: _translate(context, 'content', 'محتوى الكورس (COURSE CONTENT)')),
                      _ContentTable(content: List<dynamic>.from(courseData['content'])),
                      const SizedBox(height: 64),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _translate(BuildContext context, String key, String fallbackArabic) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar') return fallbackArabic;
    // Simple fallback for English if not found in i18n
    switch (key) {
      case 'target_audience': return 'Target Audience';
      case 'drawings': return 'Drawings Included';
      case 'projects': return 'Projects & Applications';
      case 'faqs': return 'FAQs';
      case 'outcomes': return 'Course Outcomes';
      case 'benefits': return 'Subscription Benefits';
      case 'content': return 'COURSE CONTENT';
      default: return fallbackArabic;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final IconData icon;

  const _BulletList({required this.items, this.icon = Icons.check_circle_outline});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _NumberedList extends StatelessWidget {
  final List<String> items;

  const _NumberedList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    entry.value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _FaqList extends StatelessWidget {
  final List<dynamic> faqs;

  const _FaqList({required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: faqs.map((faq) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(
              faq['question'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faq['answer'] ?? '',
                  style: const TextStyle(height: 1.6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ContentTable extends StatelessWidget {
  final List<dynamic> content;

  const _ContentTable({required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey.shade300)),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    isArabic ? 'رقم المحاضرة' : 'Lecture No',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    isArabic ? 'الموضوع' : 'Subject',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            ...content.map((item) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(item['lecture'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(item['subject'] ?? '', style: const TextStyle(height: 1.4)),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
