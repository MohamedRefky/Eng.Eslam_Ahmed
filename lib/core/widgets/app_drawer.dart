import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../utils/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  final Function(String section)? onSectionSelect;

  const AppDrawer({super.key, this.onSectionSelect});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = isMobile
        ? (screenWidth * 0.038).clamp(12.0, 15.0)
        : 18.0;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
            child: Center(
              child: Text(
                AppConstants.devName,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      height: 1.3,
                    ),
              ),
            ),
          ),
          _DrawerItem(
            title: AppLocalizations.of(context)!.translate('services'),
            icon: Icons.design_services_outlined,
            onPressed: () => _handlePress(context, 'services'),
          ),
          _DrawerItem(
            title: AppLocalizations.of(context)!.translate('courses'),
            icon: Icons.school_outlined,
            onPressed: () => _handlePress(context, 'courses'),
          ),
          _DrawerItem(
            title: AppLocalizations.of(context)!.translate('projects'),
            icon: Icons.rocket_launch_outlined,
            onPressed: () => _handlePress(context, 'projects'),
          ),
          _DrawerItem(
            title: AppLocalizations.of(context)!.translate('files'),
            icon: Icons.folder_open_outlined,
            onPressed: () => _handlePress(context, 'files'),
          ),
          _DrawerItem(
            title: AppLocalizations.of(context)!.translate('reviews'),
            icon: Icons.reviews_outlined,
            onPressed: () => _handlePress(context, 'reviews'),
          ),
          _DrawerItem(
            title: AppLocalizations.of(context)!.translate('contact'),
            icon: Icons.mail_outline,
            onPressed: () => _handlePress(context, 'contact'),
          ),
        ],
      ),
    );
  }

  void _handlePress(BuildContext context, String section) {
    Navigator.pop(context); // Close the drawer
    if (onSectionSelect != null) {
      onSectionSelect!(section);
    } else {
      // If we are not on home page, pop back to home page
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
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
