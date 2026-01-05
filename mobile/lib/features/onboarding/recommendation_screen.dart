import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../core/theme/colors.dart';

/// RecommendationScreen - AI-generated product recommendations
/// Uses the same visual language as OnboardingScreen for consistency
class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late AnimationController _loadingController;
  late AnimationController _revealController;

  bool _isLoading = true;
  final List<_Orb> _orbs = [];
  final math.Random _random = math.Random();

  // Mock recommendations (will be replaced by AI later)
  final List<Map<String, dynamic>> _recommendations = [
    {
      'name': 'Hardbox Premium',
      'desc': 'Cocok untuk produk mewah & elektronik',
      'icon': Icons.inventory_2_rounded,
      'match': 95,
    },
    {
      'name': 'Standing Pouch',
      'desc': 'Populer untuk makanan & minuman',
      'icon': Icons.emoji_food_beverage_rounded,
      'match': 88,
    },
    {
      'name': 'Softbox Eco',
      'desc': 'Ramah lingkungan & hemat biaya',
      'icon': Icons.eco_rounded,
      'match': 82,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Bubble animation
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Loading dots animation
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Reveal animation for cards
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeBubbles(MediaQuery.of(context).size);
      }
    });

    // Simulate AI loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _revealController.forward();
      }
    });
  }

  void _initializeBubbles(Size size) {
    _orbs.clear();
    final colors = [AppColors.primary, AppColors.primary, AppColors.secondary];

    for (int i = 0; i < 3; i++) {
      _orbs.add(_Orb(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 1.2,
          (_random.nextDouble() - 0.5) * 1.2,
        ),
        radius: 180 + _random.nextDouble() * 150,
        baseColor: colors[i % colors.length],
        colorPhase: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _loadingController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Soap Bubble Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SoapBubblePainter(
                    orbs: _orbs,
                    animationValue: _bubbleController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),

          // 2. Dark Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.go('/onboarding'),
                      ),
                      const Spacer(),
                      // AI Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Teknologi AI',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(),

                // Glass Card
                Center(
                  child: SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.7,
                    child: _GlassCard(
                      child: _isLoading
                          ? _buildLoadingState()
                          : _buildRecommendations(),
                    ),
                  ),
                ),

                const Spacer(),

                // CTA Button
                if (!_isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: GestureDetector(
                      onTap: () => context.go('/auth'),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Lanjutkan',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated AI Icon
        AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Transform.scale(
              scale:
                  1.0 + math.sin(_loadingController.value * math.pi * 2) * 0.1,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Loading Text
        const Text(
          'AI sedang menganalisis\npreferensi Anda...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),

        // Animated Dots
        AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final delay = index * 0.2;
                final opacity = (math.sin(
                            (_loadingController.value - delay) * math.pi * 2) +
                        1) /
                    2;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppColors.primary.withOpacity(opacity.clamp(0.3, 1.0)),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return AnimatedBuilder(
      animation: _revealController,
      builder: (context, child) {
        return Column(
          children: [
            const SizedBox(height: 24),

            // Title
            Opacity(
              opacity: _revealController.value,
              child: const Text(
                'Rekomendasi untuk Anda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: _revealController.value,
              child: Text(
                'Berdasarkan jawaban Anda',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Recommendation Cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  final delay = index * 0.15;
                  final itemAnimation = Curves.easeOutBack.transform(
                    ((_revealController.value - delay) / (1 - delay))
                        .clamp(0.0, 1.0),
                  );

                  return Transform.translate(
                    offset: Offset(0, (1 - itemAnimation) * 50),
                    child: Opacity(
                      opacity: itemAnimation,
                      child: _RecommendationCard(
                        data: _recommendations[index],
                        rank: index + 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int rank;

  const _RecommendationCard({required this.data, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  rank == 1 ? AppColors.primary : Colors.white.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rank == 1 ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data['icon'] as IconData,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['desc'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Match Percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${data['match']}%',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reuse glass card styling
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(0, 20),
            blurRadius: 40,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(color: Colors.transparent),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.03),
                    Colors.black.withOpacity(0.08),
                  ],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

// Reuse orb and painter from onboarding
class _Orb {
  Offset position;
  Offset velocity;
  double radius;
  Color baseColor;
  double colorPhase;

  _Orb({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.baseColor,
    required this.colorPhase,
  });
}

class _SoapBubblePainter extends CustomPainter {
  final List<_Orb> orbs;
  final double animationValue;

  _SoapBubblePainter({required this.orbs, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || orbs.isEmpty) return;

    for (var orb in orbs) {
      orb.position += orb.velocity;
      if (orb.position.dx - orb.radius < 0 ||
          orb.position.dx + orb.radius > size.width) {
        orb.velocity = Offset(-orb.velocity.dx, orb.velocity.dy);
      }
      if (orb.position.dy - orb.radius < 0 ||
          orb.position.dy + orb.radius > size.height) {
        orb.velocity = Offset(orb.velocity.dx, -orb.velocity.dy);
      }

      final phase = (animationValue * 2 * math.pi) + orb.colorPhase;
      final hue1 = (math.sin(phase) * 30 + 85).clamp(60, 120);
      final hue2 = (math.sin(phase + math.pi / 3) * 60 + 180);
      final hue3 = (math.sin(phase + 2 * math.pi / 3) * 40 + 280);

      final color1 =
          HSLColor.fromAHSL(1.0, hue1.toDouble(), 0.85, 0.55).toColor();
      final color2 =
          HSLColor.fromAHSL(1.0, hue2.toDouble(), 0.80, 0.50).toColor();
      final color3 =
          HSLColor.fromAHSL(1.0, hue3.toDouble(), 0.70, 0.45).toColor();

      final gradient = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        focal: const Alignment(-0.5, -0.5),
        focalRadius: 0.1,
        colors: [
          Colors.white.withOpacity(0.4),
          color1.withOpacity(0.85),
          color2.withOpacity(0.7),
          color3.withOpacity(0.6),
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
            Rect.fromCircle(center: orb.position, radius: orb.radius))
        ..blendMode = BlendMode.screen;

      canvas.drawCircle(orb.position, orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SoapBubblePainter oldDelegate) => true;
}
