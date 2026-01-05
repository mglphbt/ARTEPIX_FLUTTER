import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../core/theme/colors.dart';
import '../products/product_list_screen.dart';

/// Home Dashboard - Premium Dark Theme with Floating Navbar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isSearchExpanded = false;
  bool _isMegaMenuOpen = false;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  late AnimationController _searchAnimController;
  late AnimationController _menuAnimController;
  late Animation<double> _searchWidthAnimation;
  late Animation<double> _menuScaleAnimation;
  int _currentNavIndex = 0;

  final List<Map<String, dynamic>> _createItems = [
    {
      'title': 'Hardbox',
      'subtitle': 'Premium Rigid',
      'icon': Icons.inventory_2,
      'color': const Color(0xFF3B82F6)
    },
    {
      'title': 'Softbox',
      'subtitle': 'Flexible Carton',
      'icon': Icons.card_giftcard,
      'color': const Color(0xFF8B5CF6)
    },
    {
      'title': 'Corrugated',
      'subtitle': 'Shipping Safe',
      'icon': Icons.local_shipping,
      'color': const Color(0xFFF97316)
    },
    {
      'title': 'Jasa Desain',
      'subtitle': 'Hire an Expert',
      'icon': Icons.palette,
      'color': AppColors.primary,
      'isPrimary': true
    },
  ];

  final List<Map<String, dynamic>> _inspirations = [
    {
      'image': 'assets/images/inspiration_cosmetic.png',
      'title': 'Skincare Minimalis'
    },
    {
      'image': 'assets/images/inspiration_perfume.png',
      'title': 'Parfum Mewah',
      'hasHeart': true
    },
    {
      'image': 'assets/images/inspiration_coffee.png',
      'title': 'Kopi Ramah Lingkungan'
    },
    {'image': 'assets/images/eco_mailer_box.png', 'title': 'Geometri Abstrak'},
  ];

  final List<Map<String, dynamic>> _megaMenuItems = [
    {
      'icon': Icons.inventory_2_rounded,
      'title': 'Produk',
      'subtitle': 'Katalog Kemasan',
      'route': '/products',
    },
    {'icon': Icons.folder_open, 'title': 'Proyek', 'subtitle': 'Kelola Proyek'},
    {'icon': Icons.person, 'title': 'Profil', 'subtitle': 'Akun Anda'},
    {
      'icon': Icons.view_in_ar,
      'title': 'Expert Mode',
      'subtitle': 'Manual Design'
    },
    {'icon': Icons.settings, 'title': 'Pengaturan', 'subtitle': 'Preferensi'},
  ];

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _menuAnimController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _searchWidthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _searchAnimController, curve: Curves.easeOutCubic),
    );
    _menuScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _menuAnimController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _searchAnimController.dispose();
    _menuAnimController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;

      // Close Mega Menu if open
      if (_isSearchExpanded && _isMegaMenuOpen) {
        _isMegaMenuOpen = false;
        _menuAnimController.reverse();
      }

      if (_isSearchExpanded) {
        _searchAnimController.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _searchFocusNode.requestFocus();
        });
      } else {
        _searchAnimController.reverse();
        _searchFocusNode.unfocus();
      }
    });
  }

  void _toggleMegaMenu() {
    setState(() {
      _isMegaMenuOpen = !_isMegaMenuOpen;
      if (_isMegaMenuOpen) {
        _menuAnimController.forward();
      } else {
        _menuAnimController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF101F22),
      body: Stack(
        children: [
          // Ambient Background Glows
          _buildAmbientGlows(),

          // Main Content
          // Main Content with IndexedStack for Navigation
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentNavIndex,
              children: [
                // 0: Home Dashboard
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(),

                        const SizedBox(height: 28),

                        // Start Creating Section
                        _buildStartCreatingSection(),

                        const SizedBox(height: 28),

                        // Inspiration Section
                        _buildInspirationSection(),
                      ],
                    ),
                  ),
                ),
                // 1: Product List (Embedded)
                const Padding(
                    padding: EdgeInsets.only(bottom: 100), // Space for navbar
                    child: ProductListScreen()),
                // 2: Scan/Center Placeholder
                const Center(
                    child: Text('Scan/AR Mode',
                        style: TextStyle(color: Colors.white))),
                // 3: Layers/Projects Placeholder
                const Center(
                    child: Text('Projects',
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          ),

          // Mega Menu Overlay (Animated Visibility)
          AnimatedBuilder(
            animation: _menuAnimController,
            builder: (context, child) {
              if (_menuAnimController.isDismissed) {
                return const SizedBox.shrink();
              }
              return _buildMegaMenuOverlay();
            },
          ),

          // Floating Nav Bar
          _buildFloatingNavBar(),
        ],
      ),
    );
  }

  Widget _buildAmbientGlows() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purple.withOpacity(0.1),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101F22).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            children: [
              // Profile
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=33'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF101F22), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6), fontSize: 12),
                    ),
                    const Text(
                      'Creator',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Notification
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Stack(
                  children: [
                    const Center(
                        child: Icon(Icons.notifications_outlined,
                            color: Colors.white, size: 22)),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF18282C).withOpacity(0.8),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.search, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search packaging or ask AI...',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartCreatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Start Creating',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text('View All',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: _createItems.length,
            itemBuilder: (context, index) =>
                _buildCreateCard(_createItems[index]),
          ),
        ),
        const SizedBox(height: 12),
        // Quick Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildQuickChip(Icons.print, 'Print on Demand'),
              const SizedBox(width: 8),
              _buildQuickChip(Icons.eco, 'Eco Friendly'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateCard(Map<String, dynamic> item) {
    final bool isPrimary = item['isPrimary'] == true;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isPrimary
            ? LinearGradient(colors: [
                AppColors.primary.withOpacity(0.3),
                Colors.transparent
              ])
            : LinearGradient(colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02)
              ]),
        border: Border.all(
            color: isPrimary
                ? AppColors.primary.withOpacity(0.3)
                : Colors.white.withOpacity(0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              // Soft blur glow - only shading, not solid
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        (item['color'] as Color).withOpacity(0.25),
                        (item['color'] as Color).withOpacity(0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isPrimary
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: isPrimary
                            ? [
                                BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 15)
                              ]
                            : null,
                      ),
                      child: Icon(item['icon'],
                          color: isPrimary ? Colors.black : Colors.white,
                          size: 20),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(item['subtitle'],
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInspirationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Inspiration',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: _inspirations.length,
            itemBuilder: (context, index) =>
                _buildInspirationCard(_inspirations[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildInspirationCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(item['image']),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Stack(
        children: [
          // Fallback color
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1A2E32),
            ),
          ),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              item['image'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1A2E32),
                child: Center(
                    child: Icon(Icons.image,
                        color: Colors.white.withOpacity(0.2), size: 32)),
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7)
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Heart icon
          if (item['hasHeart'] == true)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.favorite, color: Colors.white, size: 14),
              ),
            ),
          // Title
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              item['title'],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMegaMenuOverlay() {
    return GestureDetector(
      onTap: _toggleMegaMenu,
      child: AnimatedBuilder(
        animation: _menuAnimController,
        builder: (context, child) {
          return Container(
            color: Colors.black.withOpacity(0.4 * _menuAnimController.value),
            child: child,
          );
        },
        child: Stack(
          children: [
            Positioned(
              bottom: 100,
              right: 16,
              child: AnimatedBuilder(
                animation: _menuAnimController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _menuScaleAnimation.value,
                    alignment: Alignment.bottomRight,
                    child: Opacity(
                      opacity: _menuAnimController.value,
                      child: child,
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      width: 260,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        // Frosted glass effect
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.04),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _megaMenuItems
                                .asMap()
                                .entries
                                .map((entry) => _buildMegaMenuItem(
                                    entry.value, entry.key == 0))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMegaMenuItem(Map<String, dynamic> item, bool isFirst) {
    return GestureDetector(
      onTap: () {
        _toggleMegaMenu();
        if (item.containsKey('route')) {
          context.push(item['route']);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: isFirst ? 0 : 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            // Icon container with subtle glow
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(item['icon'],
                  color: Colors.white.withOpacity(0.9), size: 18),
            ),
            const SizedBox(width: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['title'] as String,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['subtitle'] as String,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Colors.white.withOpacity(0.3), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _searchAnimController,
        builder: (context, child) {
          final expanded = _searchWidthAnimation.value;

          // Custom Liquid Animation Layout
          return Container(
            height: 80, // Allow space for shadows
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LEFT COMPONENT: Nav Pill -> Home Button
                // Animates width and content
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn, // Liquid feel
                  width: _isSearchExpanded
                      ? 64
                      : 220, // Shrink to circle or full nav text
                  height: 56,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(_isSearchExpanded ? 32 : 28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF2A2D30).withOpacity(0.70),
                              const Color(0xFF1A1C1E).withOpacity(0.80),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              _isSearchExpanded ? 32 : 28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                              spreadRadius: -2,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, -2),
                              spreadRadius: -1,
                            ),
                          ],
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1), width: 1),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isSearchExpanded
                              ? GestureDetector(
                                  onTap: () {
                                    // Shrink search back
                                    _toggleSearch();
                                  },
                                  child: Center(
                                    key: const ValueKey('home_icon'),
                                    child: Icon(Icons.home_rounded,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 24),
                                  ),
                                )
                              : Row(
                                  key: const ValueKey('nav_items'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildNavItem(0, Icons.home_rounded,
                                        _currentNavIndex == 0),
                                    const SizedBox(width: 8),
                                    _buildNavItem(1, Icons.inventory_2_rounded,
                                        _currentNavIndex == 1), // Products
                                    const SizedBox(width: 8),
                                    _buildNavItem(2, Icons.center_focus_strong,
                                        _currentNavIndex == 2), // Scan/Center
                                    const SizedBox(width: 8),
                                    _buildNavItem(3, Icons.layers_rounded,
                                        _currentNavIndex == 3), // Layers
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // RIGHT COMPONENT: Search Circle -> Search Bar
                // Animates width and content
                Expanded(
                  flex: _isSearchExpanded ? 1 : 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastLinearToSlowEaseIn, // Liquid stretch
                    width: _isSearchExpanded
                        ? MediaQuery.of(context).size.width - 120 // Fixed usage
                        : 56, // Expand to fill or circle
                    height: 56,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(_isSearchExpanded ? 28 : 28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF2A2D30).withOpacity(0.70),
                                const Color(0xFF1A1C1E).withOpacity(0.80),
                              ],
                            ),
                            shape: _isSearchExpanded
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            borderRadius: _isSearchExpanded
                                ? BorderRadius.circular(28)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: -2,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, -2),
                                spreadRadius: -1,
                              ),
                            ],
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1), width: 1),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isSearchExpanded
                                ? Row(
                                    key: const ValueKey('search_bar_content'),
                                    children: [
                                      const SizedBox(width: 16),
                                      const Icon(Icons.search,
                                          color: Colors.white, size: 22),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          focusNode: _searchFocusNode,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                          decoration: InputDecoration(
                                            hintText: 'Cari workspace',
                                            hintStyle: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.4)),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _toggleSearch,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close,
                                              color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: _toggleSearch,
                                    behavior: HitTestBehavior.opaque,
                                    child: Center(
                                      key: const ValueKey('search_icon'),
                                      child: Icon(Icons.search,
                                          color: Colors.white.withOpacity(0.85),
                                          size: 22),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, bool isActive,
      {bool isCenter = false, bool isMegaMenu = false}) {
    // Full pill shape: borderRadius = height / 2
    const double itemHeight = 40;
    const double itemWidthActive = 48;
    const double itemWidthInactive = 40;

    return GestureDetector(
      onTap: () {
        if (isMegaMenu) {
          _toggleMegaMenu();
        } else {
          if (_isMegaMenuOpen) {
            _toggleMegaMenu();
          }
          setState(() => _currentNavIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // Slower for liquid feel
        curve: Curves.fastLinearToSlowEaseIn, // Liquid curve
        width: isActive ? itemWidthActive : itemWidthInactive,
        height: itemHeight,
        decoration: BoxDecoration(
          // Full pill shape
          borderRadius: BorderRadius.circular(itemHeight / 2),
          // Frosted glass active indicator
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          border: isActive
              ? Border.all(color: Colors.white.withOpacity(0.1), width: 0.5)
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            size: 22,
          ),
        ),
      ),
    );
  }
}
