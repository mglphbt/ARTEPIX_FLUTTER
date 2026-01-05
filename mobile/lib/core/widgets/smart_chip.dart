import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/glassmorphism.dart';
import 'glass_container.dart';

/// SmartChip - For AI onboarding flow, quick selection without typing
class SmartChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const SmartChip({
    super.key,
    required this.label,
    this.icon,
    this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SmartChip> createState() => _SmartChipState();
}

class _SmartChipState extends State<SmartChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? AppColors.primaryGradient
                : LinearGradient(
                    colors: isDark
                        ? [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ]
                        : [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.4),
                          ],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : (isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.5)),
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isSelected)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              if (widget.emoji != null) ...[
                Text(
                  widget.emoji!,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
              ],
              if (widget.icon != null && !widget.isSelected) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTypography.label(
                  color: widget.isSelected
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SmartChipGroup - Grid of smart chips for multiple selection
class SmartChipGroup extends StatelessWidget {
  final List<ChipOption> options;
  final Set<String> selectedValues;
  final ValueChanged<String> onSelected;
  final bool allowMultiple;

  const SmartChipGroup({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onSelected,
    this.allowMultiple = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        return SmartChip(
          label: option.label,
          emoji: option.emoji,
          icon: option.icon,
          isSelected: selectedValues.contains(option.value),
          onTap: () => onSelected(option.value),
        );
      }).toList(),
    );
  }
}

class ChipOption {
  final String value;
  final String label;
  final String? emoji;
  final IconData? icon;

  const ChipOption({
    required this.value,
    required this.label,
    this.emoji,
    this.icon,
  });
}
