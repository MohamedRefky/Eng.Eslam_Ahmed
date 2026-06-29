import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/data/office_data.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/app_localizations.dart';
import '../core/widgets/section_title.dart';
import '../pages/course_details/course_details_page.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> courses = OfficeData.data['courses'] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          SectionTitle(
            title: AppLocalizations.of(context)!.translate('courses'),
          ),
          const SizedBox(height: 48),
          if (courses.isEmpty)
            Text(
              AppLocalizations.of(context)?.translate('no_courses') ??
                  'No courses available',
              style: const TextStyle(color: AppColors.textSecondary),
            )
          else
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: courses.map((course) {
                return _CourseCard(course: course as Map<String, dynamic>);
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;

  const _CourseCard({required this.course});

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final double cardWidth = isMobile ? double.infinity : 380;
    final imagePath = widget.course['image'] as String?;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsPage(courseId: widget.course['id']),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: cardWidth,
          transform: _isHovered
              ? Matrix4.translationValues(0, -10.0, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: _isHovered ? 25 : 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Image / Header Section ───────────────────────────────────
                Stack(
                  children: [
                    Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF001122), Color(0xFF002244)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: imagePath != null &&
                              imagePath.isNotEmpty &&
                              !imagePath.contains('placeholder')
                          ? Image.asset(
                              imagePath,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.white24,
                                ),
                              ),
                            )
                          : Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.architecture_rounded,
                                    size: 110,
                                    color: AppColors.primary.withValues(alpha: 0.05),
                                  ),
                                  Icon(
                                    Icons.computer_rounded,
                                    size: 54,
                                    color: AppColors.primary.withValues(alpha: 0.6),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    // Glassmorphic Category Tag
                    Positioned(
                      top: 16,
                      right: isArabic ? null : 16,
                      left: isArabic ? 16 : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          isArabic ? 'هندسة مدنية' : 'Civil Engineering',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Info Section ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course['title'] ?? 'Course Title',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.course['description'] ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Technical stats
                      Row(
                        children: [
                          _StatChip(
                            icon: Icons.access_time_filled_rounded,
                            label: widget.course['duration'] ?? '',
                          ),
                          const SizedBox(width: 12),
                          _StatChip(
                            icon: Icons.video_library_rounded,
                            label: widget.course['lectures'] ?? '',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Interactive Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isHovered
                                ? [AppColors.accent, AppColors.primary]
                                : [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _isHovered
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailsPage(
                                  courseId: widget.course['id'],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                        ?.translate('view_details') ??
                                    'View Details',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isArabic
                                    ? Icons.arrow_back_rounded // in RTL
                                    : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
