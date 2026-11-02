import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  /// Retained constants to guarantee Flutter's release tree-shaker keeps all these brand & solid glyphs
  static const List<dynamic> retainedIcons = [
    FontAwesomeIcons.facebook,
    FontAwesomeIcons.instagram,
    FontAwesomeIcons.linkedin,
    FontAwesomeIcons.whatsapp,
    FontAwesomeIcons.github,
    FontAwesomeIcons.googleDrive,
    FontAwesomeIcons.phone,
    FontAwesomeIcons.paperPlane,
  ];

  static Widget getIconWidget(String name, {double size = 28, Color? color}) {
    final effectiveColor = color ?? const Color(0xFF00D2FF);
    switch (name) {
      case 'whatsapp':
        return FaIcon(FontAwesomeIcons.whatsapp, size: size, color: effectiveColor);
      case 'facebook':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            size: Size(size, size),
            painter: _FacebookPainter(effectiveColor),
          ),
        );
      case 'instagram':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            size: Size(size, size),
            painter: _InstagramPainter(effectiveColor),
          ),
        );
      case 'linkedin':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            size: Size(size, size),
            painter: _LinkedInPainter(effectiveColor),
          ),
        );
      case 'github':
        return FaIcon(FontAwesomeIcons.github, size: size, color: effectiveColor);
      case 'phone':
        return FaIcon(FontAwesomeIcons.phone, size: size, color: effectiveColor);
      case 'email':
        return Icon(Icons.mail_outline, size: size, color: effectiveColor);
      default:
        return Icon(getIcon(name), size: size, color: effectiveColor);
    }
  }

  static IconData getIcon(String name) {
    switch (name) {
      case 'briefcase':
        return Icons.work_outline;
      case 'certificate':
        return Icons.workspace_premium_outlined;
      case 'building':
        return Icons.business_outlined;
      case 'layerGroup':
        return Icons.layers_outlined;
      case 'hardHat':
        return Icons.engineering_outlined;
      case 'drafting':
        return Icons.architecture_outlined;
      case 'chalkboardTeacher':
        return Icons.school_outlined;
      case 'graduationCap':
        return Icons.school_outlined;
      case 'fileAlt':
        return Icons.description_outlined;
      case 'shield':
        return Icons.shield_outlined;
      case 'columns':
        return Icons.view_column_outlined;
      case 'code':
        return Icons.code_outlined;
      case 'fileExcel':
        return Icons.table_chart_outlined;
      case 'presentation':
        return Icons.slideshow_outlined;
      case 'fileWord':
        return Icons.article_outlined;
      case 'laptop':
        return Icons.laptop_outlined;
      case 'email':
        return Icons.mail_outline;
      case 'whatsapp':
        return FontAwesomeIcons.whatsapp.data;
      case 'facebook':
        return FontAwesomeIcons.facebook.data;
      case 'instagram':
        return FontAwesomeIcons.instagram.data;
      case 'mobileScreen':
        return Icons.smartphone_outlined;
      case 'clockRotateLeft':
        return Icons.history_outlined;
      case 'database':
        return Icons.storage_outlined;
      case 'mobileScreenButton':
        return Icons.smartphone_outlined;
      case 'server':
        return Icons.dns_outlined;
      case 'palette':
        return Icons.palette_outlined;
      case 'bolt':
        return Icons.flash_on_outlined;
      case 'flutter':
        return FontAwesomeIcons.flutter.data;
      case 'atom':
        return Icons.science_outlined;
      case 'link':
        return Icons.link_outlined;
      case 'github':
        return FontAwesomeIcons.github.data;
      case 'store':
        return Icons.store_outlined;
      case 'brain':
        return Icons.psychology_outlined;
      case 'checkDouble':
        return Icons.done_all_outlined;
      case 'gaugeHigh':
        return Icons.speed_outlined;
      case 'mobileButton':
        return Icons.phone_android_outlined;
      case 'laptopCode':
        return Icons.developer_mode_outlined;
      case 'linkedin':
        return FontAwesomeIcons.linkedin.data;
      default:
        return Icons.help_outline;
    }
  }
}

class _InstagramPainter extends CustomPainter {
  final Color color;
  _InstagramPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.085
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final pad = size.width * 0.08;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(pad, pad, size.width - 2 * pad, size.height - 2 * pad),
      Radius.circular(size.width * 0.26),
    );
    canvas.drawRRect(rrect, strokePaint);

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.22, strokePaint);

    final dotCenter = Offset(size.width * 0.72, size.height * 0.28);
    canvas.drawCircle(dotCenter, size.width * 0.05, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _InstagramPainter oldDelegate) => oldDelegate.color != color;
}

class _FacebookPainter extends CustomPainter {
  final Color color;
  _FacebookPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final path = Path();
    path.moveTo(18 * scale, 2 * scale);
    path.lineTo(14.5 * scale, 2 * scale);
    path.cubicTo(11.5 * scale, 2 * scale, 9.5 * scale, 4.0 * scale, 9.5 * scale, 7.5 * scale);
    path.lineTo(9.5 * scale, 10.0 * scale);
    path.lineTo(7.0 * scale, 10.0 * scale);
    path.lineTo(7.0 * scale, 14.0 * scale);
    path.lineTo(9.5 * scale, 14.0 * scale);
    path.lineTo(9.5 * scale, 22.0 * scale);
    path.lineTo(14.0 * scale, 22.0 * scale);
    path.lineTo(14.0 * scale, 14.0 * scale);
    path.lineTo(17.5 * scale, 14.0 * scale);
    path.lineTo(18.0 * scale, 10.0 * scale);
    path.lineTo(14.0 * scale, 10.0 * scale);
    path.lineTo(14.0 * scale, 7.8 * scale);
    path.cubicTo(14.0 * scale, 6.7 * scale, 14.4 * scale, 6.0 * scale, 15.6 * scale, 6.0 * scale);
    path.lineTo(18.0 * scale, 6.0 * scale);
    path.close();

    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _FacebookPainter oldDelegate) => oldDelegate.color != color;
}

class _LinkedInPainter extends CustomPainter {
  final Color color;
  _LinkedInPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 'i' dot
    canvas.drawCircle(Offset(4.8 * scale, 4.5 * scale), 1.8 * scale, fillPaint);

    // 'i' stem
    canvas.drawLine(Offset(4.8 * scale, 9.5 * scale), Offset(4.8 * scale, 20.5 * scale), strokePaint);

    // 'n' stem
    canvas.drawLine(Offset(10.5 * scale, 9.5 * scale), Offset(10.5 * scale, 20.5 * scale), strokePaint);

    // 'n' arch & right leg
    final arch = Path();
    arch.moveTo(10.5 * scale, 14.5 * scale);
    arch.cubicTo(11.0 * scale, 10.5 * scale, 13.5 * scale, 9.0 * scale, 16.5 * scale, 9.0 * scale);
    arch.cubicTo(19.5 * scale, 9.0 * scale, 20.5 * scale, 11.0 * scale, 20.5 * scale, 14.5 * scale);
    arch.lineTo(20.5 * scale, 20.5 * scale);
    canvas.drawPath(arch, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _LinkedInPainter oldDelegate) => oldDelegate.color != color;
}
