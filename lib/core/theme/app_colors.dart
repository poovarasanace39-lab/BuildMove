import 'package:flutter/material.dart';

/// Palette for BuildMove: Industrial Construction & Logistics theme
/// High-contrast, safety-oriented, professional slate & amber aesthetic.
/// Supports both Figma Light and Dark themes.
class AppColors {
  AppColors._();

  // Primary: Heavy Machinery Amber / Construction Orange (Figma Burnt Orange #CC4900)
  static const Color primary = Color(0xFFCC4900); // Figma Primary CTA Burnt Orange
  static const Color primaryDark = Color(0xFFB33E00);
  static const Color primaryLight = Color(0xFFE2611E);
  static const Color primaryContainer = Color(0xFFFFEDE4);
  static const Color primaryContainerDark = Color(0xFF3B1C08);

  // Primary BuildMove Accent (Figma #A33800)
  static const Color primaryAccent = Color(0xFFA33800);
  static const Color brandOrange = Color(0xFFCC4900);

  // Secondary: Industrial Steel & Deep Charcoal
  static const Color secondary = Color(0xFF1E293B); // Slate 800
  static const Color secondaryLight = Color(0xFF334155); // Slate 700
  static const Color slateDark = Color(0xFF0F172A); // Slate 900
  static const Color slateMuted = Color(0xFF64748B); // Slate 500

  // Secondary Blue Accent (Figma #0051D5)
  static const Color secondaryBlue = Color(0xFF0051D5);
  static const Color blueAccent = Color(0xFF0051D5);
  static const Color blueContainer = Color(0xFFEBF2FD);

  // Accent / Safety Highlighter
  static const Color accent = Color(0xFFFBBF24); // Safety Yellow
  static const Color accentSubtle = Color(0xFFFEF3C7);

  // Light Mode Background & Surfaces (Figma #F7FAFE & #F1F4F8)
  static const Color background = Color(0xFFF7FAFE); // Figma light blue-gray background
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F4F8); // Figma light card / surface fill
  static const Color surfaceCard = Colors.white;

  // Dark Mode Background & Surfaces (Figma Dark Theme)
  static const Color darkBackground = Color(0xFF0B0F19); // Ultra deep navy/charcoal
  static const Color darkSurface = Color(0xFF131B2A); // Elevated dark surface
  static const Color darkSurfaceCard = Color(0xFF131B2A); // Dark card
  static const Color darkSurfaceVariant = Color(0xFF1A2438); // Input/field fill
  static const Color darkBorder = Color(0xFF263347); // High-contrast border

  // Semantic Status Colors
  static const Color success = Color(0xFF16A34A); // Green 600
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark = Color(0xFF14532D);
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF78350F);
  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFF7F1D1D);
  static const Color info = Color(0xFF0051D5); // Figma Blue Accent
  static const Color infoLight = Color(0xFFEBF2FD);
  static const Color infoDark = Color(0xFF003B9D);

  // Text Colors (Light mode - Figma #181C1F Dark Charcoal & #585F6D)
  static const Color textPrimary = Color(0xFF181C1F);
  static const Color textSecondary = Color(0xFF585F6D); // Figma #585F6D
  static const Color textTertiary = Color(0xFF718096);
  static const Color textWhite = Colors.white;

  // Text Colors (Dark mode)
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // Divider and Border (Figma #E0E3E7, #EBEEF2, #E5E8EC)
  static const Color border = Color(0xFFE0E3E7);
  static const Color borderSubtle = Color(0xFFEBEEF2);
  static const Color divider = Color(0xFFE5E8EC);

  // Specific Role Indicators
  static const Color customerRole = Color(0xFF0051D5); // Figma Blue Accent
  static const Color driverRole = Color(0xFFCC4900); // Logistics Orange
  static const Color adminRole = Color(0xFF7C3AED); // Operations Purple
}
