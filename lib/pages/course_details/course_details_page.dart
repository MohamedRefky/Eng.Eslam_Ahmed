import 'package:eslam_ahmed_portfolio/core/data/office_data.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/buttons/language_switch_button.dart';
import 'widgets/glass_card.dart';
import 'widgets/section_label.dart';
import 'widgets/bullet_list.dart';
import 'widgets/drawings_grid.dart';
import 'widgets/outcomes_benefits.dart';
import 'widgets/faq_list.dart';
import 'widgets/content_table.dart';
import 'widgets/nav_bar_item.dart';
import 'widgets/programs_grid.dart';
import 'widgets/checks_grid.dart';
import '../../main.dart';

class CourseDetailsPage extends StatefulWidget {
  final String courseId;

  const CourseDetailsPage({super.key, required this.courseId});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _courseData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final lang = Localizations.localeOf(context).languageCode;
    await OfficeData.load(lang);
    if (mounted) {
      final courses = OfficeData.data['courses'] as List<dynamic>? ?? [];
      final courseData = courses.firstWhere(
        (c) => c['id'] == widget.courseId,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      setState(() {
        _courseData = courseData;
        _isLoading = false;
      });
    }
  }

  Future<void> _bookCourse(Map<String, dynamic> courseData) async {
    final title = courseData['title'] ?? '';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final message = isArabic 
        ? 'مرحباً مهندس إسلام، أود الاستفسار وحجز كورس: $title'
        : 'Hello Eng. Eslam, I would like to book the course: $title';
    
    final encodedMessage = Uri.encodeComponent(message);
    final number = AppConstants.whatsappNumber.replaceAll('+', '').replaceAll(' ', '');
    final urlString = 'https://wa.me/$number?text=$encodedMessage';
    
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final courseData = _courseData;

    if (courseData == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            AppLocalizations.of(context)?.translate('no_courses') ?? 'Course not found',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isMobileOrTablet = isMobile || isTablet;
    final imagePath = courseData['image'] as String?;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Localized section labels
    final String labelDescription = AppLocalizations.of(context)?.translate('course_description') ?? 'نبذة عن الكورس';
    final String labelTargetAudience = AppLocalizations.of(context)?.translate('course_target_audience') ?? 'لمن هذا الكورس';
    
    final String labelDrawings;
    if (courseData['id'] == 'csi_diploma') {
      labelDrawings = AppLocalizations.of(context)?.translate('course_drawings_csi') ?? 'القطاعات التي سيتم تصميمها';
    } else if (courseData['id'] == 'manual_design') {
      labelDrawings = AppLocalizations.of(context)?.translate('course_drawings_manual') ?? 'المحتوى التفصيلي لكورس التأسيس';
    } else {
      labelDrawings = AppLocalizations.of(context)?.translate('course_drawings_default') ?? 'اللوحات التي سيتم رسمها';
    }

    final String labelProjects = AppLocalizations.of(context)?.translate('course_projects') ?? 'المشاريع والتطبيقات';
    final String labelFaqs = AppLocalizations.of(context)?.translate('course_faqs') ?? 'الأسئلة الشائعة';
    final String labelOutcomes = AppLocalizations.of(context)?.translate('course_outcomes') ?? 'كيف سيصبح مستواك';
    final String labelBenefits = AppLocalizations.of(context)?.translate('course_benefits') ?? 'مميزات الاشتراك';
    final String labelContent = AppLocalizations.of(context)?.translate('course_content') ?? 'محتوى الكورس';
    final String labelPrograms = AppLocalizations.of(context)?.translate('course_programs') ?? 'البرامج المستخدمة في الدبلومة';
    final String labelChecks = AppLocalizations.of(context)?.translate('course_checks') ?? 'الـ CHECKS التي سنقوم بعملها';
    final String labelAnalysisMethods = AppLocalizations.of(context)?.translate('course_analysis_methods') ?? 'طرق تحليل المنشآت تحت تأثير الزلازل';
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ─────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: isMobile ? 260 : 380,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: LanguageSwitchButton(
                    currentLocale: Localizations.localeOf(context),
                    onLocaleChanged: (newLocale) => appLocale.value = newLocale,
                  ),
                ),
              ),
              if (isMobileOrTablet)
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.menu, color: Colors.white, size: 20),
                    ),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                )
              else ...[
                ...[
                  'services',
                  'courses',
                  'projects',
                  'files',
                  'reviews',
                  'contact',
                ].map(
                  (key) => CourseNavBarItem(
                    title: AppLocalizations.of(context)!.translate(key),
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (imagePath != null && imagePath.isNotEmpty)
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: isMobile ? 64 : 96,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: isMobile ? 64 : 96,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  // Dark overlay gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Hero content
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'COURSE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          courseData['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body Content ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 960),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description Card
                    CourseGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CourseSectionLabel(
                            label: labelDescription,
                            icon: Icons.info_outline_rounded,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            courseData['description'] ?? '',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.9,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Call to Action Card (Book Now)
                    CourseGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.green,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isArabic ? 'احجز مقعدك الآن' : 'Book Your Seat Now',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isArabic 
                                          ? 'تواصل معنا مباشرة عبر الواتساب للاستفسار وحجز مكانك في الكورس'
                                          : 'Contact us directly on WhatsApp to inquire and book your seat',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF25D366), Color(0xFF075E54)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _bookCourse(courseData),
                              icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 20),
                              label: Text(
                                isArabic ? 'تواصل للحجز (واتساب)' : 'Inquire & Book (WhatsApp)',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Target Audience
                    if (courseData['targetAudience'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelTargetAudience,
                              icon: Icons.people_alt_outlined,
                            ),
                            const SizedBox(height: 16),
                            CourseBulletList(
                              items: List<String>.from(courseData['targetAudience']),
                              icon: Icons.person_pin_rounded,
                              iconColor: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Programs Used (Optional)
                    if (courseData['programs'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelPrograms,
                              icon: Icons.computer_rounded,
                            ),
                            const SizedBox(height: 16),
                            CourseProgramsGrid(
                              items: List<String>.from(courseData['programs']),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Drawings — numbered grid
                    if (courseData['drawings'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelDrawings,
                              icon: Icons.straighten_rounded,
                            ),
                            const SizedBox(height: 16),
                            CourseDrawingsGrid(
                              items: List<String>.from(courseData['drawings']),
                              isMobile: isMobile,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Checks to perform (Optional)
                    if (courseData['checks'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelChecks,
                              icon: Icons.done_all_rounded,
                            ),
                            const SizedBox(height: 16),
                            CourseChecksGrid(
                              items: List<String>.from(courseData['checks']),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Projects
                    if (courseData['projects'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelProjects,
                              icon: Icons.precision_manufacturing_rounded,
                            ),
                            const SizedBox(height: 16),
                            CourseBulletList(
                              items: List<String>.from(courseData['projects']),
                              icon: Icons.rocket_launch_rounded,
                              iconColor: AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Seismic Analysis Methods (Optional)
                    if (courseData['analysisMethods'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelAnalysisMethods,
                              icon: Icons.analytics_rounded,
                            ),
                            const SizedBox(height: 16),
                            CourseBulletList(
                              items: List<String>.from(courseData['analysisMethods']),
                              icon: Icons.flash_on_rounded,
                              iconColor: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Outcomes & Benefits — side by side on desktop
                    if (courseData['outcomes'] != null || courseData['benefits'] != null) ...[
                      isMobile
                          ? Column(
                              children: [
                                if (courseData['outcomes'] != null)
                                  CourseGlassCard(
                                    child: CourseOutcomesBenefits(
                                      label: labelOutcomes,
                                      items: List<String>.from(courseData['outcomes']),
                                      icon: Icons.trending_up_rounded,
                                      iconColor: AppColors.accent,
                                    ),
                                  ),
                                if (courseData['benefits'] != null) ...[
                                  const SizedBox(height: 24),
                                  CourseGlassCard(
                                    child: CourseOutcomesBenefits(
                                      label: labelBenefits,
                                      items: List<String>.from(courseData['benefits']),
                                      icon: Icons.star_rounded,
                                      iconColor: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (courseData['outcomes'] != null)
                                  Expanded(
                                    child: CourseGlassCard(
                                      child: CourseOutcomesBenefits(
                                        label: labelOutcomes,
                                        items: List<String>.from(courseData['outcomes']),
                                        icon: Icons.trending_up_rounded,
                                        iconColor: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                if (courseData['benefits'] != null) ...[
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: CourseGlassCard(
                                      child: CourseOutcomesBenefits(
                                        label: labelBenefits,
                                        items: List<String>.from(courseData['benefits']),
                                        icon: Icons.star_rounded,
                                        iconColor: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                      const SizedBox(height: 24),
                    ],

                    // FAQs
                    if (courseData['faqs'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelFaqs,
                              icon: Icons.quiz_outlined,
                            ),
                            const SizedBox(height: 12),
                            CourseFaqList(faqs: List<dynamic>.from(courseData['faqs'])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Course Content Table
                    if (courseData['content'] != null) ...[
                      CourseGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseSectionLabel(
                              label: labelContent,
                              icon: Icons.playlist_play_rounded,
                            ),
                            const SizedBox(height: 16),
                            CourseContentTable(
                              content: List<dynamic>.from(courseData['content']),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bookCourse(courseData),
        backgroundColor: const Color(0xFF25D366),
        elevation: 6,
        icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
        label: Text(
          isArabic ? 'احجز الآن' : 'Book Now',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.5,
          ),
        ),
      ),
    );
  }
}

