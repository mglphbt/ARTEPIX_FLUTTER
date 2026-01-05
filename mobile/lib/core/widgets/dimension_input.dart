import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/glassmorphism.dart';
import 'dart:ui';

/// DimensionInput - For entering P x L x T (Panjang x Lebar x Tinggi)
class DimensionInput extends StatefulWidget {
  final double? initialLength;
  final double? initialWidth;
  final double? initialHeight;
  final String unit;
  final ValueChanged<DimensionValue> onChanged;
  final double minValue;
  final double maxValue;

  const DimensionInput({
    super.key,
    this.initialLength,
    this.initialWidth,
    this.initialHeight,
    this.unit = 'mm',
    required this.onChanged,
    this.minValue = 10,
    this.maxValue = 1000,
  });

  @override
  State<DimensionInput> createState() => _DimensionInputState();
}

class _DimensionInputState extends State<DimensionInput> {
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _lengthController = TextEditingController(
      text: widget.initialLength?.toString() ?? '',
    );
    _widthController = TextEditingController(
      text: widget.initialWidth?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: widget.initialHeight?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    final length = double.tryParse(_lengthController.text);
    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);

    widget.onChanged(DimensionValue(
      length: length,
      width: width,
      height: height,
      unit: widget.unit,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(GlassmorphismStyle.radiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: isDark
              ? GlassmorphismStyle.glassDecorationDark()
              : GlassmorphismStyle.glassDecorationLight(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.straighten_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dimensi Kemasan',
                    style: AppTypography.label(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DimensionField(
                      controller: _lengthController,
                      label: 'Panjang',
                      unit: widget.unit,
                      onChanged: (_) => _notifyChange(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '×',
                      style: AppTypography.h3(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _DimensionField(
                      controller: _widthController,
                      label: 'Lebar',
                      unit: widget.unit,
                      onChanged: (_) => _notifyChange(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '×',
                      style: AppTypography.h3(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _DimensionField(
                      controller: _heightController,
                      label: 'Tinggi',
                      unit: widget.unit,
                      onChanged: (_) => _notifyChange(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DimensionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final ValueChanged<String> onChanged;

  const _DimensionField({
    required this.controller,
    required this.label,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.8),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            textAlign: TextAlign.center,
            style: AppTypography.h3(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              border: InputBorder.none,
              hintText: '0',
              hintStyle: AppTypography.h3(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
              suffixText: unit,
              suffixStyle: AppTypography.caption(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.caption(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

/// Value holder for dimensions
class DimensionValue {
  final double? length;
  final double? width;
  final double? height;
  final String unit;

  const DimensionValue({
    this.length,
    this.width,
    this.height,
    this.unit = 'mm',
  });

  bool get isComplete => length != null && width != null && height != null;

  /// Calculate flat size for box (bentangan)
  /// Formula: (2P + 2L + Glue) x (T + Flaps)
  double? get flatWidth {
    if (!isComplete) return null;
    const glueWidth = 15.0; // mm
    return (2 * length!) + (2 * width!) + glueWidth;
  }

  double? get flatHeight {
    if (!isComplete) return null;
    const flapHeight = 15.0; // mm (top + bottom flaps)
    return height! + (2 * flapHeight);
  }

  @override
  String toString() {
    return '${length ?? '-'} × ${width ?? '-'} × ${height ?? '-'} $unit';
  }
}
