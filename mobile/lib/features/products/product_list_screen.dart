import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/glass_container.dart';

/// ProductListScreen - Product catalog with filtering
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Hardbox',
    'Softbox',
    'Corrugated',
    'POD',
    'Jasa Desain',
  ];

  final List<_Product> _products = [
    _Product(
      id: '1',
      name: 'Hardbox Magnet Premium',
      category: 'Hardbox',
      basePrice: 15000,
      imageGradient: [const Color(0xFF6B4CE6), const Color(0xFF9B6DFF)],
      rating: 4.9,
      sold: 1234,
    ),
    _Product(
      id: '2',
      name: 'Standing Pouch Kraft',
      category: 'Softbox',
      basePrice: 3500,
      imageGradient: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
      rating: 4.8,
      sold: 2567,
    ),
    _Product(
      id: '3',
      name: 'Mailer Box Corrugated',
      category: 'Corrugated',
      basePrice: 8000,
      imageGradient: [const Color(0xFFFBBF24), const Color(0xFFF59E0B)],
      rating: 4.7,
      sold: 890,
    ),
    _Product(
      id: '4',
      name: 'Paper Bag Premium',
      category: 'Softbox',
      basePrice: 5000,
      imageGradient: [const Color(0xFFFF6B6B), const Color(0xFFFFB88C)],
      rating: 4.8,
      sold: 1567,
    ),
    _Product(
      id: '5',
      name: 'Tuck End Box',
      category: 'Hardbox',
      basePrice: 12000,
      imageGradient: [const Color(0xFF667eea), const Color(0xFF764ba2)],
      rating: 4.6,
      sold: 456,
    ),
    _Product(
      id: '6',
      name: 'Custom Sticker Roll',
      category: 'POD',
      basePrice: 500,
      imageGradient: [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      rating: 4.9,
      sold: 5678,
    ),
  ];

  List<_Product> get _filteredProducts {
    if (_selectedCategory == 'Semua') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Katalog Produk',
                  style: AppTypography.h2(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Row(
                  children: [
                    GlassContainer(
                      radius: 14,
                      blur: 10,
                      padding: const EdgeInsets.all(10),
                      onTap: () {
                        // TODO: Search
                      },
                      child: Icon(
                        Iconsax.search_normal,
                        size: 20,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GlassContainer(
                      radius: 14,
                      blur: 10,
                      padding: const EdgeInsets.all(10),
                      onTap: () {
                        // TODO: Filter
                      },
                      child: Icon(
                        Iconsax.filter,
                        size: 20,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
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
                    child: Text(
                      category,
                      style: AppTypography.label(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return _ProductCard(
                  product: _filteredProducts[index],
                  onTap: () {
                    context.go('/products/${_filteredProducts[index].id}');
                  },
                );
              },
            ),
          ),

          // Bottom padding for navbar
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final _Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
        child: GlassContainer(
          radius: 20,
          blur: 12,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Placeholder
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.product.imageGradient,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Iconsax.box_1,
                        size: 48,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    // Wishlist button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Iconsax.heart,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Product Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.product.imageGradient.first
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.product.category,
                          style: AppTypography.caption(
                            color: widget.product.imageGradient.first,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Product name
                      Text(
                        widget.product.name,
                        style: AppTypography.label(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // Price and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${widget.product.basePrice.toStringAsFixed(0)}',
                            style: AppTypography.priceSmall(),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.product.rating.toString(),
                                style: AppTypography.caption(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Product {
  final String id;
  final String name;
  final String category;
  final double basePrice;
  final List<Color> imageGradient;
  final double rating;
  final int sold;

  const _Product({
    required this.id,
    required this.name,
    required this.category,
    required this.basePrice,
    required this.imageGradient,
    required this.rating,
    required this.sold,
  });
}
