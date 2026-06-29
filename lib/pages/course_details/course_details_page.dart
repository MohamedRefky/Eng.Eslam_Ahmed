import 'package:eslam_ahmed_portfolio/core/data/office_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/buttons/language_switch_button.dart';
import '../../main.dart';
import 'widgets/book_now_section.dart';
import 'widgets/course_sections.dart';

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
      final courseData =
          courses.firstWhere(
                (c) => c['id'] == widget.courseId,
                orElse: () => null,
              )
              as Map<String, dynamic>?;
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
    final number = AppConstants.whatsappNumber
        .replaceAll('+', '')
        .replaceAll(' ', '');
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
            AppLocalizations.of(context)?.translate('no_courses') ??
                'Course not found',
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
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
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
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 20,
                      ),
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
                      fit: BoxFit.fill,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
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
                    // Description
                    CourseDescriptionSection(courseData: courseData),
                    const SizedBox(height: 24),

                    // WhatsApp Booking (CTA Card)
                    CourseBookNowSection(
                      courseData: courseData,
                      onBookPressed: () => _bookCourse(courseData),
                    ),
                    const SizedBox(height: 24),

                    // Target Audience
                    CourseTargetAudienceSection(courseData: courseData),

                    // Programs Used
                    CourseProgramsSection(courseData: courseData),

                    // Drawings / Sections Grid
                    CourseDrawingsSection(courseData: courseData),

                    // Checks Grid
                    CourseChecksSection(courseData: courseData),

                    // Projects
                    CourseProjectsSection(courseData: courseData),

                    // Seismic Analysis Methods
                    CourseAnalysisMethodsSection(courseData: courseData),

                    // Outcomes & Benefits
                    CourseOutcomesBenefitsSection(courseData: courseData),

                    // FAQs
                    CourseFaqsSection(courseData: courseData),

                    // Content Table / Syllabus
                    CourseContentSection(courseData: courseData),
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
