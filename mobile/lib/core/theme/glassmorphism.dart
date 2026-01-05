import 'dart:ui';
import 'package:flutter/material.dart';
import 'colors.dart';

/// ARTEPIX Glassmorphism System
/// Liquid Glass design components
class GlassmorphismStyle {
  GlassmorphismStyle._();

  // ═══════════════════════════════════════════════════════════════════════════
  // BLUR VALUES
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const double blurLight = 10.0;
  static const double blurMedium = 20.0;
  static const double blurHeavy = 30.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // GLASS DECORATION - LIGHT MODE
  // ═══════════════════════════════════════════════════════════════════════════

  static BoxDecoration glassDecorationLight({
    double radius = radiusLarge,
    double opacity = 0.25,
    double borderOpacity = 0.4,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.4),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withOpacity(borderOpacity),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 40,
          offset: const Offset(0, 20),
          spreadRadius: -5,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GLASS DECORATION - DARK MODE
  // ═══════════════════════════════════════════════════════════════════════════

  static BoxDecoration glassDecorationDark({
    double radius = radiusLarge,
    double opacity = 0.15,
    double borderOpacity = 0.1,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.3),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withOpacity(borderOpacity),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GLASS DECORATION WITH GRADIENT BORDER
  // ═══════════════════════════════════════════════════════════════════════════

  static BoxDecoration glassWithGradientBorder({
    double radius = radiusLarge,
    bool isDark = false,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(isDark ? 0.15 : 0.25),
          Colors.white.withOpacity(isDark ? 0.05 : 0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: GradientBorder.uniform(
        gradient: AppColors.primaryGradient,
        width: 2.0,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BLUR FILTER
  // ═══════════════════════════════════════════════════════════════════════════

  static ImageFilter blur({double sigma = blurMedium}) {
    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// GRADIENT BORDER HELPER
// ═══════════════════════════════════════════════════════════════════════════

class GradientBorder extends Border {
  final Gradient gradient;
  final double width;

  const GradientBorder._({
    required this.gradient,
    required this.width,
  }) : super();

  factory GradientBorder.uniform({
    required Gradient gradient,
    double width = 1.0,
  }) {
    return GradientBorder._(gradient: gradient, width: width);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    if (borderRadius != null) {
      final RRect rrect = borderRadius.toRRect(rect);
      canvas.drawRRect(rrect, paint);
    } else {
      canvas.drawRect(rect, paint);
    }
  }
}
