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
    // 1. Load Data
    await OfficeData.load();

    // 2. Wait a bit for the animation (500ms is enough for a snappy feel)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // 3. Hide Web Splash if exists
    SplashService.hide();

    // 4. Navigate to Home
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Matches your web splash
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image with Glow
            Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.asset(
                      'assets/image/profile/Eslam_Ahmed.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .animate()
                .scale(duration: 600.ms, curve: Curves.bounceOut)
                .fadeIn(),

            const SizedBox(height: 32),

            // Name Text
            Text(
                  AppConstants.devName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.5, end: 0),

            const SizedBox(height: 16),

            // Loading Bar
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 2,
                ),
              ),
            ).animate(delay: 400.ms).fadeIn().scaleX(begin: 0, end: 1),
          ],
        ),
      ),
    );
  }
}
