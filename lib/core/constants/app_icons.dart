import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
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
