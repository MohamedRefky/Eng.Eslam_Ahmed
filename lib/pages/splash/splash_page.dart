import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_constants.dart';
import '../../core/data/office_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/splash_service.dart';
import '../home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final lang = 'ar'; // Default language, will reload in HomePage if different

    // Load data in parallel with splash display
    await OfficeData.load(lang);

    // Very brief pause so the animation feels intentional (not a flicker)
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    // Hide the web splash overlay (index.html)
    SplashService.hide();

    // Navigate to home with a smooth fade
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This Flutter splash mirrors the web splash so the transition is seamless.
    // On web: the HTML splash covers this, so the user only sees one splash.
    // On mobile (if ever used): this provides a native splash experience.
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image with animated glow ring
            Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset(
                      'assets/image/profile/Eslam_Ahmed.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .animate()
                .scale(
                  duration: 700.ms,
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 600.ms),

            const SizedBox(height: 28),

            // Name
            Text(
                  AppConstants.devName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                  ),
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.4, end: 0),

            const SizedBox(height: 8),

            // Tagline
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.accent,
                ],
              ).createShader(bounds),
              child: const Text(
                'STRUCTURAL DESIGN ENGINEER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.4, end: 0),

            const SizedBox(height: 36),

            // Loading bar
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 2,
                ),
              ),
            ).animate(delay: 600.ms).fadeIn().scaleX(begin: 0, end: 1),
          ],
        ),
      ),
    );
  }
}
