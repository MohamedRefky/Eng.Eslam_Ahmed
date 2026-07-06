import '../data/office_data.dart';

class AppConstants {
  static Map<String, dynamic> get _info =>
      OfficeData.data['personalInfo'] ?? {};

  static String get devName => _info['name'] ?? 'Eslam Ahmed';
  static String get devShortName {
    final name = devName;
    if (name.contains('للخدمات')) {
      return name.split('للخدمات').first.trim();
    }
    if (name.contains('الخدمات')) {
      return name.split('الخدمات').first.trim();
    }
    if (name.contains('Office')) {
      return name.split('Office').first.trim();
    }
    // Fallback if the string doesn't contain the expected split keywords
    final words = name.split(' ');
    if (words.length > 4) {
      return words.take(4).join(' ').trim();
    }
    return name;
  }
  static String get devTitle => _info['title'] ?? 'Civil Engineer | Structural Design Engineer';
  static String get devDescription =>
      _info['description'] ??
      'SCE Certified Civil Engineer with 5+ years of experience in structural design, site supervision, and technical office engineering.';

  static List<String> get devHighlights =>
      List<String>.from(_info['highlights'] ?? []);

  static String get devImagePath =>
      _info['image'] ?? 'assets/image/profile/Eslam_Ahmed.jpg';
  static String get devCvPath =>
      _info['cv'] ??
      'assets/pdf/cv.pdf';

  // Social Links
  static String get githubUrl =>
      _info['github'] ?? '';
  static String get linkedinUrl =>
      _info['linkedin'] ?? '';
  static String get email =>
      'mailto:${_info['email'] ?? 'eslamahmed157179@gmail.com'}';
  static String get whatsappNumber =>
      _info['whatsappNumber'] ?? '+201061617649';
  static String get whatsappUrl =>
      'https://wa.me/${whatsappNumber.replaceAll('+', '')}';
  static String get phoneCallUrl => 'tel:${_info['phone'] ?? '+201061617649'}';
}
