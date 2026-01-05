import 'package:flutter/material.dart';

/// ARTEPIX Color Palette
/// Linear-inspired Dark Theme with Liquid Glass
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY COLORS - Purple Accent (like Linear)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color primaryStart = Color(0xFFD2F801); // Lime Green / Volt
  static const Color primaryEnd = Color(0xFFA6D600);
  static const Color primary = Color(0xFFD2F801);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryStart, primaryEnd],
  );

  // Secondary Color - Cyan/Teal for accents
  static const Color secondary = Color(0xFF22D3EE); // Bright Cyan

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCENT COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color accentStart = Color(0xFF3B82F6);
  static const Color accentEnd = Color(0xFF60A5FA);
  static const Color accent = Color(0xFF3B82F6);

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentStart, accentEnd],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF166534);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFF92400E);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFF991B1B);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF1E40AF);

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK MODE COLORS (Linear Style - Pure Black)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF0A0A0A);
  static const Color darkSurfaceElevated = Color(0xFF141414);
  static const Color darkSurfaceHover = Color(0xFF1A1A1A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextTertiary = Color(0xFF6B7280);
  static const Color darkDivider = Color(0xFF1F1F1F);
  static const Color darkBorder = Color(0xFF2A2A2A);

  // Dark Mode Background (solid black like Linear)
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000),
      Color(0xFF000000),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT MODE COLORS (for compatibility)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF9FAFB);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightDivider = Color(0xFFE5E7EB);

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF9FAFB),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LIQUID GLASS COLORS (for navbar and containers)
  // ═══════════════════════════════════════════════════════════════════════════

  // Liquid Glass - Dark Mode (Linear style)
  static const Color liquidGlassDark = Color(0xFF1A1A1A);
  static const Color liquidGlassDarkBorder = Color(0xFF2A2A2A);
  static const Color liquidGlassHighlight = Color(0xFF3A3A3A);

  // Light Mode Glass
  static Color glassLight = Colors.white.withOpacity(0.8);
  static Color glassLightBorder = Colors.white.withOpacity(0.5);
  static Color glassLightShadow = Colors.black.withOpacity(0.05);

  // Dark Mode Glass
  static Color glassDark = const Color(0xFF1A1A1A).withOpacity(0.9);
  static Color glassDarkBorder = const Color(0xFF2A2A2A);
  static Color glassDarkShadow = Colors.black.withOpacity(0.5);

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY COLORS (for product categories)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color categoryHardbox = Color(0xFF8B5CF6);
  static const Color categorySoftbox = Color(0xFFF472B6);
  static const Color categoryCorrugated = Color(0xFFF59E0B);
  static const Color categoryPOD = Color(0xFF22C55E);
  static const Color categoryDesign = Color(0xFF3B82F6);
}
