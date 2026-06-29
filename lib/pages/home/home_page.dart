import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../core/constants/app_constants.dart';
import '../../core/data/office_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../main.dart';
import '../../sections/books_section.dart';
import '../../sections/contact_section.dart';
import '../../sections/courses_section.dart';
import '../../sections/hero_section.dart';
import '../../sections/projects_section.dart';
import '../../sections/services_section.dart';
import '../../sections/testimonials_section.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/animations/animated_gradient_background.dart';
import '../../widgets/buttons/language_switch_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final lang = Localizations.localeOf(context).languageCode;
    await OfficeData.load(lang);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Section Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _coursesKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _booksKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isMobileOrTablet = isMobile || isTablet;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobileOrTablet
          ? AppDrawer(
              onSectionSelect: (section) {
                switch (section) {
                  case 'services':
                    _scrollToSection(_servicesKey);
                    break;
                  case 'courses':
                    _scrollToSection(_coursesKey);
                    break;
                  case 'projects':
                    _scrollToSection(_projectsKey);
                    break;
                  case 'files':
                    _scrollToSection(_booksKey);
                    break;
                  case 'reviews':
                    _scrollToSection(_testimonialsKey);
                    break;
                  case 'contact':
                    _scrollToSection(_contactKey);
                    break;
                }
              },
            )
          : null,
      body: AnimatedGradientBackground(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Theme.of(
                context,
              ).scaffoldBackgroundColor.withValues(alpha: 0.8),
              elevation: 0,
              title: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment:
                      Localizations.localeOf(context).languageCode == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    AppConstants.devName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: LanguageSwitchButton(
                      currentLocale: Localizations.localeOf(context),
                      onLocaleChanged: (newLocale) {
                        appLocale.value = newLocale;
                      },
                    ),
                  ),
                ),
                if (!isMobileOrTablet) ...[
                  _NavBarItem(
                    title: AppLocalizations.of(context)!.translate('services'),
                    onPressed: () => _scrollToSection(_servicesKey),
                  ),
                  _NavBarItem(
                    title: AppLocalizations.of(context)!.translate('courses'),
                    onPressed: () => _scrollToSection(_coursesKey),
                  ),
                  _NavBarItem(
                    title: AppLocalizations.of(context)!.translate('projects'),
                    onPressed: () => _scrollToSection(_projectsKey),
                  ),
                  _NavBarItem(
                    title: AppLocalizations.of(context)!.translate('files'),
                    onPressed: () => _scrollToSection(_booksKey),
                  ),
                  _NavBarItem(
                    title: AppLocalizations.of(context)!.translate('reviews'),
                    onPressed: () => _scrollToSection(_testimonialsKey),
                  ),
                  _NavBarItem(
                    title: AppLocalizations.of(context)!.translate('contact'),
                    onPressed: () => _scrollToSection(_contactKey),
                  ),
                ],
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  HeroSection(
                    onViewProjects: () => _scrollToSection(_projectsKey),
                    onContactMe: () => _scrollToSection(_contactKey),
                    onViewServices: () => _scrollToSection(_servicesKey),
                  ),
                  ServicesSection(key: _servicesKey),
                  CoursesSection(key: _coursesKey),
                  ProjectsSection(key: _projectsKey),
                  BooksSection(key: _booksKey),
                  TestimonialsSection(key: _testimonialsKey),
                  ContactSection(key: _contactKey),
                ],
              ),
            ),
          ],
        ),
      ),
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
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      child: Text(title),
    );
  }
}
