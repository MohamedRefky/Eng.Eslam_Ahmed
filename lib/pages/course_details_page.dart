import 'package:eslam_ahmed_portfolio/core/data/office_data.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/app_localizations.dart';
import '../widgets/app_drawer.dart';
import '../widgets/buttons/language_switch_button.dart';
import '../main.dart';

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

  String _t(BuildContext context, String key, String ar) {
    final lang = Localizations.localeOf(context).languageCode;
    final isCsi = _courseData?['id'] == 'csi_diploma';
    final isManual = _courseData?['id'] == 'manual_design';
    
    if (lang == 'ar') {
      if (key == 'drawings') {
        if (isCsi) return 'القطاعات التي سيتم تصميمها';
        if (isManual) return 'المحتوى التفصيلي لكورس التأسيس';
      }
      return ar;
    }
    switch (key) {
      case 'description':
        return 'About the Course';
      case 'target_audience':
        return 'Who Is This Course For?';
      case 'drawings':
        if (isCsi) return 'Sections to be Designed';
        if (isManual) return 'Detailed Curriculum';
        return 'Drawings You Will Learn';
      case 'projects':
        return 'Practical Projects';
      case 'faqs':
        return 'Frequently Asked Questions';
      case 'outcomes':
        return 'What You Will Achieve';
      case 'benefits':
        return 'What You Will Get';
      case 'content':
        return 'Course Content';
      case 'programs':
        return 'Software Covered';
      case 'checks':
        return 'CHECKS to Perform';
      case 'analysis_methods':
        return 'Seismic Analysis Methods';
      default:
        return ar;
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
                  (key) => _NavBarItem(
                    title: AppLocalizations.of(context)!.translate(key),
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image or gradient
                  imagePath != null && !imagePath.contains('placeholder')
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.secondary, AppColors.primary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF001A33),
                                AppColors.secondary,
                                AppColors.primary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.architecture_rounded,
                              size: 120,
                              color: Colors.white12,
                            ),
                          ),
                        ),
                  // Gradient overlay bottom → transparent (darkens for text legibility)
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
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
                    _GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(
                            label: _t(context, 'description', 'نبذة عن الكورس'),
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

                    // Target Audience
                    if (courseData['targetAudience'] != null) ...[
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'target_audience', 'لمن هذا الكورس'),
                              icon: Icons.people_alt_outlined,
                            ),
                            const SizedBox(height: 16),
                            _BulletList(
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
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'programs', 'البرامج المستخدمة في الدبلومة'),
                              icon: Icons.computer_rounded,
                            ),
                            const SizedBox(height: 16),
                            _ProgramsGrid(
                              items: List<String>.from(courseData['programs']),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Drawings — numbered grid
                    if (courseData['drawings'] != null) ...[
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'drawings', 'اللوحات التي سيتم رسمها'),
                              icon: Icons.straighten_rounded,
                            ),
                            const SizedBox(height: 16),
                            _DrawingsGrid(
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
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'checks', 'الـ CHECKS التي سنقوم بعملها'),
                              icon: Icons.done_all_rounded,
                            ),
                            const SizedBox(height: 16),
                            _ChecksGrid(
                              items: List<String>.from(courseData['checks']),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Projects
                    if (courseData['projects'] != null) ...[
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'projects', 'المشاريع والتطبيقات'),
                              icon: Icons.precision_manufacturing_rounded,
                            ),
                            const SizedBox(height: 16),
                            _BulletList(
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
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'analysis_methods', 'طرق تحليل المنشآت تحت تأثير الزلازل'),
                              icon: Icons.analytics_rounded,
                            ),
                            const SizedBox(height: 16),
                            _BulletList(
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
                                  _GlassCard(
                                    child: _OutcomesBenefits(
                                      label: _t(context, 'outcomes', 'كيف سيصبح مستواك'),
                                      items: List<String>.from(courseData['outcomes']),
                                      icon: Icons.trending_up_rounded,
                                      iconColor: AppColors.accent,
                                    ),
                                  ),
                                if (courseData['benefits'] != null) ...[
                                  const SizedBox(height: 24),
                                  _GlassCard(
                                    child: _OutcomesBenefits(
                                      label: _t(context, 'benefits', 'مميزات الاشتراك'),
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
                                    child: _GlassCard(
                                      child: _OutcomesBenefits(
                                        label: _t(context, 'outcomes', 'كيف سيصبح مستواك'),
                                        items: List<String>.from(courseData['outcomes']),
                                        icon: Icons.trending_up_rounded,
                                        iconColor: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                if (courseData['benefits'] != null) ...[
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: _GlassCard(
                                      child: _OutcomesBenefits(
                                        label: _t(context, 'benefits', 'مميزات الاشتراك'),
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
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'faqs', 'الأسئلة الشائعة'),
                              icon: Icons.quiz_outlined,
                            ),
                            const SizedBox(height: 12),
                            _FaqList(faqs: List<dynamic>.from(courseData['faqs'])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Course Content Table
                    if (courseData['content'] != null) ...[
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(
                              label: _t(context, 'content', 'محتوى الكورس'),
                              icon: Icons.playlist_play_rounded,
                            ),
                            const SizedBox(height: 16),
                            _ContentTable(
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
    );
  }
}

// ── Reusable Components ──────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final Color iconColor;

  const _BulletList({
    required this.items,
    this.icon = Icons.check_circle_rounded,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DrawingsGrid extends StatelessWidget {
  final List<String> items;
  final bool isMobile;
  const _DrawingsGrid({required this.items, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final bool useVerticalList = items.any((item) => item.length > 30);

    if (useVerticalList) {
      return Column(
        children: items.asMap().entries.map((entry) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.asMap().entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.value,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _OutcomesBenefits extends StatelessWidget {
  final String label;
  final List<String> items;
  final IconData icon;
  final Color iconColor;

  const _OutcomesBenefits({
    required this.label,
    required this.items,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: label, icon: icon),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          margin: const EdgeInsets.only(bottom: 10),
          color: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.textSecondary,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Text(
              faq['question'] ?? '',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
            children: [
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 12),
              Text(
                faq['answer'] ?? '',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.7,
                  fontSize: 14,
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      children: content.asMap().entries.map((entry) {
        final isEven = entry.key % 2 == 0;
        return Container(
          decoration: BoxDecoration(
            color: isEven
                ? AppColors.background
                : AppColors.primary.withValues(alpha: 0.04),
            borderRadius: entry.key == 0
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : entry.key == content.length - 1
                    ? const BorderRadius.vertical(bottom: Radius.circular(12))
                    : BorderRadius.zero,
            border: Border(
              bottom: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    entry.value['lecture'] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    entry.value['subject'] ?? '',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                Icon(
                  Icons.play_circle_outline_rounded,
                  color: AppColors.primary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _NavBarItem({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        overlayColor: AppColors.primary,
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }
}

class _ProgramsGrid extends StatelessWidget {
  final List<String> items;
  const _ProgramsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((program) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.code_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                program,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ChecksGrid extends StatelessWidget {
  final List<String> items;
  const _ChecksGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((check) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 16),
              const SizedBox(width: 8),
              Text(
                check,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

