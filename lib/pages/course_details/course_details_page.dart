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
import 'widgets/youtube_video_player.dart';

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
    final videoUrl = courseData['videoUrl'] as String?;
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ─────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: isMobile
                ? (hasVideo ? 380 : 440)
                : (hasVideo ? 340 : 360),
            pinned: true,
            backgroundColor: const Color(0xFF0a0a18),
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
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
              background: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3),
                    radius: 1.2,
                    colors: [
                      Color(0xFF151535),
                      Color(0xFF0c0c1e),
                      Color(0xFF080816),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // ── Ambient glow behind course cover ─────────────────────
                    Positioned(
                      top: isMobile ? 75 : 60,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: isMobile
                              ? (hasVideo ? 260 : 180)
                              : (hasVideo ? 340 : 220),
                          height: isMobile
                              ? (hasVideo ? 200 : 140)
                              : (hasVideo ? 260 : 180),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: hasVideo ? 0.35 : 0.25,
                                ),
                                blurRadius: hasVideo ? 100 : 80,
                                spreadRadius: hasVideo ? 30 : 20,
                              ),
                              BoxShadow(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Decorative grid dots ────────────────────────────────
                    Positioned.fill(
                      child: CustomPaint(painter: _DotGridPainter()),
                    ),

                    // ── Main content ────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        isMobile ? 55 : 45,
                        24,
                        10,
                      ),
                      child: isMobile
                          ? Column(
                              children: [
                                // Floating course cover / Video
                                if (hasVideo)
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final videoWidth = (MediaQuery.of(context).size.width - 48).clamp(280.0, 420.0);
                                      final videoHeight = videoWidth * 9 / 16;
                                      return YouTubeVideoPlayer(
                                        videoUrl: videoUrl,
                                        width: videoWidth,
                                        height: videoHeight,
                                        borderRadius: BorderRadius.circular(12),
                                      );
                                    },
                                  )
                                else
                                  _PremiumCourseCover(
                                    imagePath: imagePath,
                                    width: 280,
                                    height: 157,
                                    showReflection: false,
                                  ),
                                const SizedBox(height: 12),
                                _CourseHeroMeta(
                                  courseData: courseData,
                                  isMobile: true,
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(),
                                if (hasVideo)
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final screenWidth = MediaQuery.of(context).size.width;
                                      final videoWidth = (screenWidth * 0.38).clamp(400.0, 580.0);
                                      final videoHeight = videoWidth * 9 / 16;
                                      return YouTubeVideoPlayer(
                                        videoUrl: videoUrl,
                                        width: videoWidth,
                                        height: videoHeight,
                                        borderRadius: BorderRadius.circular(12),
                                      );
                                    },
                                  )
                                else
                                  _PremiumCourseCover(
                                    imagePath: imagePath,
                                    width: 360,
                                    height: 202,
                                    showReflection: true,
                                  ),
                                const SizedBox(width: 36),
                                Expanded(
                                  flex: 3,
                                  child: _CourseHeroMeta(
                                    courseData: courseData,
                                    isMobile: false,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                    ),
                  ],
                ),
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

// ── Premium Course Cover (3D floating with reflection) ───────────────────────
class _PremiumCourseCover extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final bool showReflection;

  const _PremiumCourseCover({
    required this.imagePath,
    required this.width,
    required this.height,
    this.showReflection = true,
  });

  @override
  Widget build(BuildContext context) {
    final double reflectionHeight = showReflection ? height * 0.20 : 0.0;
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    return SizedBox(
      width: width,
      height: height + reflectionHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ── Mirror reflection ──────────────────────────────────────────
          if (showReflection)
            Positioned(
              top: height - 2,
              child: Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.diagonal3Values(1.0, -1.0, 1.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstIn,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: width,
                      height: height * 0.30,
                      child: hasImage
                          ? Image.asset(
                              imagePath!,
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                              errorBuilder: (_, _, _) =>
                                  Container(color: const Color(0xFF1a1a2e)),
                            )
                          : Container(color: const Color(0xFF1a1a2e)),
                    ),
                  ),
                ),
              ),
            ),

          // ── Main course cover ────────────────────────────────────────────
          Positioned(
            top: 0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  // Primary color glow
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                  // Deep shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(4, 8),
                  ),
                  // Soft ambient
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(-2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Course image
                    hasImage
                        ? Image.asset(
                            imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _CoverFallback(),
                          )
                        : _CoverFallback(),

                    // Light shimmer highlight
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(-1.0, -1.0),
                            end: const Alignment(1.0, 1.0),
                            colors: [
                              Colors.white.withValues(alpha: 0.12),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.04),
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Top edge highlight
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cover Fallback ───────────────────────────────────────────────────────────
class _CoverFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1e1e3a), Color(0xFF2a1a4e), Color(0xFF0f2040)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 48,
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}

// ── Course Hero Meta ─────────────────────────────────────────────────────────
class _CourseHeroMeta extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final bool isMobile;

  const _CourseHeroMeta({required this.courseData, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge
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
        const SizedBox(height: 12),
        // Title
        Text(
          courseData['title'] ?? '',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 22 : 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        // Duration and Lectures Wrap
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            if (courseData['duration'] != null &&
                (courseData['duration'] as String).isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    courseData['duration'],
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            if (courseData['lectures'] != null &&
                (courseData['lectures'] as String).isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_circle_outline_rounded,
                    color: AppColors.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    courseData['lectures'],
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

// ── Dot Grid Painter (subtle decorative background) ─────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const dotRadius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
