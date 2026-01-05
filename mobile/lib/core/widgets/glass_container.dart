import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/glassmorphism.dart';

/// GlassContainer - A container with glassmorphism effect
/// Core component of the Liquid Glass Design System
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final bool withGradientBorder;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.radius = GlassmorphismStyle.radiusLarge,
    this.blur = GlassmorphismStyle.blurMedium,
    this.opacity = 0.25,
    this.borderOpacity = 0.4,
    this.withGradientBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: withGradientBorder
          ? GlassmorphismStyle.glassWithGradientBorder(
              radius: radius,
              isDark: isDark,
            )
          : (isDark
              ? GlassmorphismStyle.glassDecorationDark(
                  radius: radius,
                  opacity: opacity,
                  borderOpacity: borderOpacity,
                )
              : GlassmorphismStyle.glassDecorationLight(
                  radius: radius,
                  opacity: opacity,
                  borderOpacity: borderOpacity,
                )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}

/// Small variant of GlassContainer for chips and badges
class GlassChip extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isSelected;

  const GlassChip({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: GlassmorphismStyle.radiusMedium,
      blur: GlassmorphismStyle.blurLight,
      opacity: isSelected ? 0.35 : 0.2,
      withGradientBorder: isSelected,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      onTap: onTap,
      child: child,
    );
  }
}
