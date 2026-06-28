import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/data/portfolio_data.dart';
import '../widgets/animations/animated_gradient_background.dart';
import '../sections/hero_section.dart';
import '../sections/services_section.dart';
import '../sections/courses_section.dart';
import '../sections/projects_section.dart';
import '../sections/books_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/contact_section.dart';

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
    _loadData();
  }

  Future<void> _loadData() async {
    await PortfolioData.load();
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
          ? Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppConstants.devName,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                  _DrawerItem(
                    title: 'Services',
                    icon: Icons.design_services_outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      _scrollToSection(_servicesKey);
                    },
                  ),
                  _DrawerItem(
                    title: 'Courses',
                    icon: Icons.school_outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      _scrollToSection(_coursesKey);
                    },
                  ),
                  _DrawerItem(
                    title: 'Projects',
                    icon: Icons.rocket_launch_outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      _scrollToSection(_projectsKey);
                    },
                  ),
                  _DrawerItem(
                    title: 'Files',
                    icon: Icons.folder_open_outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      _scrollToSection(_booksKey);
                    },
                  ),
                  _DrawerItem(
                    title: 'Customer Reviews',
                    icon: Icons.reviews_outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      _scrollToSection(_testimonialsKey);
                    },
                  ),
                  _DrawerItem(
                    title: 'Contact',
                    icon: Icons.mail_outline,
                    onPressed: () {
                      Navigator.pop(context);
                      _scrollToSection(_contactKey);
                    },
                  ),
                ],
              ),
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppConstants.devName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              actions: isMobileOrTablet
                  ? null
                  : [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _NavBarItem(
                                title: 'Services',
                                onPressed: () => _scrollToSection(_servicesKey),
                              ),
                              _NavBarItem(
                                title: 'Courses',
                                onPressed: () => _scrollToSection(_coursesKey),
                              ),
                              _NavBarItem(
                                title: 'Projects',
                                onPressed: () => _scrollToSection(_projectsKey),
                              ),
                              _NavBarItem(
                                title: 'Files',
                                onPressed: () => _scrollToSection(_booksKey),
                              ),
                              _NavBarItem(
                                title: 'Customer Reviews',
                                onPressed: () => _scrollToSection(_testimonialsKey),
                              ),
                              _NavBarItem(
                                title: 'Contact',
                                onPressed: () => _scrollToSection(_contactKey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
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

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      onTap: onPressed,
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
