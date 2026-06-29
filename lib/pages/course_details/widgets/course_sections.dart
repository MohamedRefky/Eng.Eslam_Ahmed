// ─────────────────────────────────────────────────────────────────────────────
// All page-level section widgets and the nav bar item for CourseDetailsPage.
// Each section wraps its content in CourseSectionWrapper and returns
// SizedBox.shrink() when its data key is absent from courseData.
//
// Contains:
//   CourseNavBarItem, CourseDescriptionSection, CourseTargetAudienceSection,
//   CourseProgramsSection, CourseDrawingsSection, CourseChecksSection,
//   CourseProjectsSection, CourseAnalysisMethodsSection,
//   CourseOutcomesBenefitsSection, CourseFaqsSection, CourseContentSection
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_localizations.dart';
import 'course_base_widgets.dart';
import 'course_display_widgets.dart';
import 'course_grid_widgets.dart';

// ── CourseNavBarItem ──────────────────────────────────────────────────────────
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
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    );
  }
}

// ── CourseDescriptionSection ──────────────────────────────────────────────────
class CourseDescriptionSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseDescriptionSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_description') ?? 'نبذة عن الكورس',
      icon: Icons.info_outline_rounded,
      bottomPadding: 24,
      childTopSpacing: 12,
      child: Text(
        courseData['description'] ?? '',
        style: const TextStyle(color: AppColors.textSecondary, height: 1.9, fontSize: 15),
      ),
    );
  }
}

// ── CourseTargetAudienceSection ───────────────────────────────────────────────
class CourseTargetAudienceSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseTargetAudienceSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData['targetAudience'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_target_audience') ?? 'لمن هذا الكورس',
      icon: Icons.people_alt_outlined,
      child: CourseBulletList(
        items: List<String>.from(courseData['targetAudience']),
        icon: Icons.person_pin_rounded,
        iconColor: AppColors.accent,
      ),
    );
  }
}

// ── CourseProgramsSection ─────────────────────────────────────────────────────
class CourseProgramsSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseProgramsSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData['programs'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_programs') ?? 'البرامج المستخدمة في الدبلومة',
      icon: Icons.computer_rounded,
      child: CourseProgramsGrid(items: List<String>.from(courseData['programs'])),
    );
  }
}

// ── CourseDrawingsSection ─────────────────────────────────────────────────────
class CourseDrawingsSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseDrawingsSection({super.key, required this.courseData});

  String _label(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (courseData['id'] == 'csi_diploma') {
      return loc?.translate('course_drawings_csi') ?? 'القطاعات التي سيتم تصميمها';
    } else if (courseData['id'] == 'manual_design') {
      return loc?.translate('course_drawings_manual') ?? 'المحتوى التفصيلي لكورس التأسيس';
    }
    return loc?.translate('course_drawings_default') ?? 'اللوحات التي سيتم رسمها';
  }

  @override
  Widget build(BuildContext context) {
    if (courseData['drawings'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: _label(context),
      icon: Icons.straighten_rounded,
      child: CourseDrawingsGrid(
        items: List<String>.from(courseData['drawings']),
        isMobile: ResponsiveBreakpoints.of(context).isMobile,
      ),
    );
  }
}

// ── CourseChecksSection ───────────────────────────────────────────────────────
class CourseChecksSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseChecksSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData['checks'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_checks') ?? 'الـ CHECKS التي سنقوم بعملها',
      icon: Icons.done_all_rounded,
      child: CourseChecksGrid(items: List<String>.from(courseData['checks'])),
    );
  }
}

// ── CourseProjectsSection ─────────────────────────────────────────────────────
class CourseProjectsSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseProjectsSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData['projects'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_projects') ?? 'المشاريع والتطبيقات',
      icon: Icons.precision_manufacturing_rounded,
      child: CourseBulletList(
        items: List<String>.from(courseData['projects']),
        icon: Icons.rocket_launch_rounded,
        iconColor: AppColors.secondary,
      ),
    );
  }
}

// ── CourseAnalysisMethodsSection ──────────────────────────────────────────────
class CourseAnalysisMethodsSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseAnalysisMethodsSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData['analysisMethods'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_analysis_methods') ?? 'طرق تحليل المنشآت تحت تأثير الزلازل',
      icon: Icons.analytics_rounded,
      child: CourseBulletList(
        items: List<String>.from(courseData['analysisMethods']),
        icon: Icons.flash_on_rounded,
        iconColor: AppColors.accent,
      ),
    );
  }
}

// ── CourseOutcomesBenefitsSection ─────────────────────────────────────────────
class CourseOutcomesBenefitsSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseOutcomesBenefitsSection({super.key, required this.courseData});

  Widget _card(String label, List<String> items, IconData icon, Color iconColor) {
    return CourseGlassCard(
      child: CourseOutcomesBenefits(label: label, items: items, icon: icon, iconColor: iconColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasOutcomes = courseData['outcomes'] != null;
    final hasBenefits = courseData['benefits'] != null;
    if (!hasOutcomes && !hasBenefits) return const SizedBox.shrink();

    final labelOutcomes = AppLocalizations.of(context)?.translate('course_outcomes') ?? 'كيف سيصبح مستواك';
    final labelBenefits = AppLocalizations.of(context)?.translate('course_benefits') ?? 'مميزات الاشتراك';
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    Widget outcomeCard() => _card(labelOutcomes, List<String>.from(courseData['outcomes']), Icons.trending_up_rounded, AppColors.accent);
    Widget benefitCard() => _card(labelBenefits, List<String>.from(courseData['benefits']), Icons.star_rounded, AppColors.primary);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: isMobile
          ? Column(
              children: [
                if (hasOutcomes) outcomeCard(),
                if (hasOutcomes && hasBenefits) const SizedBox(height: 24),
                if (hasBenefits) benefitCard(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasOutcomes) Expanded(child: outcomeCard()),
                if (hasOutcomes && hasBenefits) const SizedBox(width: 24),
                if (hasBenefits) Expanded(child: benefitCard()),
              ],
            ),
    );
  }
}

// ── CourseFaqsSection ─────────────────────────────────────────────────────────
class CourseFaqsSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseFaqsSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData['faqs'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_faqs') ?? 'الأسئلة الشائعة',
      icon: Icons.quiz_outlined,
      childTopSpacing: 12,
      child: CourseFaqList(faqs: List<dynamic>.from(courseData['faqs'])),
    );
  }
}

// ── CourseContentSection ──────────────────────────────────────────────────────
class CourseContentSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const CourseContentSection({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData['content'] == null) return const SizedBox.shrink();
    return CourseSectionWrapper(
      label: AppLocalizations.of(context)?.translate('course_content') ?? 'محتوى الكورس',
      icon: Icons.playlist_play_rounded,
      bottomPadding: 60,
      child: CourseContentTable(content: List<dynamic>.from(courseData['content'])),
    );
  }
}
