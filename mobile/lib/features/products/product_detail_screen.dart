import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/glassmorphism.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/dimension_input.dart';

/// ProductDetailScreen - Product customization with real-time pricing
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  // Dimension values
  DimensionValue _dimensions = const DimensionValue();

  // Material selection
  String _selectedMaterial = 'Ivory 300';

  // Finishing selections
  Set<String> _selectedFinishing = {'Doff'};

  // Quantity
  int _quantity = 100;

  // Calculated price
  double get _unitPrice {
    if (!_dimensions.isComplete) return 0;

    // Base price calculation (simplified for demo)
    double baseMaterialCost = _selectedMaterial == 'Ivory 300' ? 5000 : 3000;
    double finishingCost = _selectedFinishing.length * 500;
    double areaCost = (_dimensions.length! * _dimensions.width! / 10000) * 100;

    // Fixed costs distributed
    double fixedCosts = 500000 / _quantity; // Pisau pond, plat CTP

    return baseMaterialCost / 10 + finishingCost + areaCost + fixedCosts;
  }

  double get _totalPrice => _unitPrice * _quantity;

  final List<_MaterialOption> _materials = const [
    _MaterialOption(
      name: 'Ivory 300',
      description: 'Premium, halus, cocok untuk luxury box',
      priceLabel: '+Rp 5.000/plano',
    ),
    _MaterialOption(
      name: 'Duplex 350',
      description: 'Ekonomis, kuat, cocok untuk shipping box',
      priceLabel: '+Rp 3.000/plano',
    ),
    _MaterialOption(
      name: 'Kraft 280',
      description: 'Tampilan alami, ramah lingkungan',
      priceLabel: '+Rp 4.000/plano',
    ),
  ];

  final List<_FinishingOption> _finishings = const [
    _FinishingOption(name: 'Doff', icon: Iconsax.blur),
    _FinishingOption(name: 'Glossy', icon: Iconsax.sun_1),
    _FinishingOption(name: 'Hotprint Gold', icon: Iconsax.star),
    _FinishingOption(name: 'Emboss', icon: Iconsax.d_cube_scan),
    _FinishingOption(name: 'Spot UV', icon: Iconsax.drop),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GlassContainer(
          radius: 14,
          blur: 10,
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.all(8),
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          GlassContainer(
            radius: 14,
            blur: 10,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            onTap: () {
              // TODO: Add to wishlist
            },
            child: Icon(
              Iconsax.heart,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBackgroundGradient
              : AppColors.lightBackgroundGradient,
        ),
        child: Column(
          children: [
            // 3D Preview Area
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryStart.withOpacity(0.8),
                    AppColors.primaryEnd.withOpacity(0.6),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: Icon(
                      Iconsax.box_1,
                      size: 200,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  // 3D Model placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Icon(
                          Iconsax.d_cube_scan,
                          size: 80,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '3D Preview',
                          style: AppTypography.label(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Putar untuk melihat dari berbagai sisi',
                          style: AppTypography.caption(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dimension display
                  if (_dimensions.isComplete)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: GlassContainer(
                        radius: 12,
                        blur: 10,
                        opacity: 0.3,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          _dimensions.toString(),
                          style: AppTypography.labelSmall(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Configuration
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      'Hardbox Magnet Premium',
                      style: AppTypography.h2(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Custom ukuran sesuai kebutuhan Anda',
                      style: AppTypography.body(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dimension Input
                    DimensionInput(
                      onChanged: (value) {
                        setState(() {
                          _dimensions = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Material Selection
                    Text(
                      'Pilih Material',
                      style: AppTypography.h4(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._materials.map((material) => _MaterialCard(
                          material: material,
                          isSelected: _selectedMaterial == material.name,
                          onTap: () {
                            setState(() {
                              _selectedMaterial = material.name;
                            });
                          },
                        )),
                    const SizedBox(height: 24),

                    // Finishing Selection
                    Text(
                      'Finishing (Pilih satu atau lebih)',
                      style: AppTypography.h4(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _finishings.map((finishing) {
                        final isSelected =
                            _selectedFinishing.contains(finishing.name);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFinishing.remove(finishing.name);
                              } else {
                                _selectedFinishing.add(finishing.name);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient:
                                  isSelected ? AppColors.primaryGradient : null,
                              color: isSelected
                                  ? null
                                  : (isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: isDark
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.white.withOpacity(0.5),
                                    ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  finishing.icon,
                                  size: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  finishing.name,
                                  style: AppTypography.label(
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Quantity Selector
                    GlassContainer(
                      radius: 20,
                      blur: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah',
                                style: AppTypography.label(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Minimum order 100 pcs',
                                style: AppTypography.caption(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _quantity > 100
                                      ? () => setState(() => _quantity -= 100)
                                      : null,
                                  icon: Icon(
                                    Icons.remove,
                                    color: _quantity > 100
                                        ? AppColors.primary
                                        : AppColors.lightTextTertiary,
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  alignment: Alignment.center,
                                  child: Text(
                                    _quantity.toString(),
                                    style: AppTypography.h4(
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      setState(() => _quantity += 100),
                                  icon: const Icon(
                                    Icons.add,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 120), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Price Bar
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.transparent,
                        AppColors.darkSurface.withOpacity(0.9),
                      ]
                    : [
                        Colors.transparent,
                        Colors.white.withOpacity(0.95),
                      ],
              ),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
              ),
            ),
            child: Row(
              children: [
                // Price Info
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Harga',
                        style: AppTypography.caption(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_dimensions.isComplete)
                        Text(
                          'Rp ${_totalPrice.toStringAsFixed(0)}',
                          style: AppTypography.priceLarge(),
                        )
                      else
                        Text(
                          'Masukkan dimensi',
                          style: AppTypography.body(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                        ),
                      if (_dimensions.isComplete)
                        Text(
                          '@ Rp ${_unitPrice.toStringAsFixed(0)}/pcs',
                          style: AppTypography.caption(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                // Order Button
                SizedBox(
                  width: 160,
                  child: GlassButton(
                    text: 'Pesan Sekarang',
                    onPressed: _dimensions.isComplete
                        ? () {
                            // TODO: Navigate to checkout
                          }
                        : () {},
                    icon: Iconsax.shopping_cart,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final _MaterialOption material;
  final bool isSelected;
  final VoidCallback onTap;

  const _MaterialCard({
    required this.material,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.primary.withOpacity(0.05),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.5)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? AppColors.primaryGradient : null,
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                        width: 2,
                      ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.name,
                    style: AppTypography.label(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    material.description,
                    style: AppTypography.caption(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              material.priceLabel,
              style: AppTypography.labelSmall(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialOption {
  final String name;
  final String description;
  final String priceLabel;

  const _MaterialOption({
    required this.name,
    required this.description,
    required this.priceLabel,
  });
}

class _FinishingOption {
  final String name;
  final IconData icon;

  const _FinishingOption({required this.name, required this.icon});
}
