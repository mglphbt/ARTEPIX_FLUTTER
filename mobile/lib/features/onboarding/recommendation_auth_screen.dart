import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import '../../core/theme/colors.dart';
import '../../core/services/onboarding_service.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../auth/bloc/auth_bloc.dart';
import 'models/onboarding_data.dart';

/// Combined Recommendation + Auth Screen
/// Auto-responsive - no scrolling, fits any screen
class RecommendationAuthScreen extends StatefulWidget {
  final Map<int, String>? onboardingAnswers;

  const RecommendationAuthScreen({super.key, this.onboardingAnswers});

  @override
  State<RecommendationAuthScreen> createState() =>
      _RecommendationAuthScreenState();
}

class _RecommendationAuthScreenState extends State<RecommendationAuthScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.72);
  int _currentPage = 0;
  late final OnboardingService _onboardingService;
  bool _isSavingProfile = false;

  @override
  void initState() {
    super.initState();
    final storageService = StorageService();
    _onboardingService = OnboardingService(
      ApiService(storageService),
      storageService,
    );
  }

  final List<Map<String, dynamic>> _recommendations = [
    {
      'name': 'Eco Mailer Box',
      'spec': '10x8x4 • Recycled Cardboard',
      'image': 'assets/images/eco_mailer_box.png',
      'isBestMatch': true,
    },
    {
      'name': 'Organic Pouch',
      'spec': '6x9 • Biodegradable',
      'image': 'assets/images/organic_pouch.png',
      'isBestMatch': false,
    },
    {
      'name': 'Minimalist Shipper',
      'spec': '12x12x12 • Kraft Corrugated',
      'image': 'assets/images/minimalist_shipper.png',
      'isBestMatch': false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final availableHeight = size.height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      body: SafeArea(
        child: Column(
          children: [
            // Header - 8% height
            SizedBox(
              height: availableHeight * 0.08,
              child: _buildHeader(),
            ),

            // Headline - 10% height
            SizedBox(
              height: availableHeight * 0.10,
              child: _buildHeadline(),
            ),

            // Carousel - 48% height (increased)
            SizedBox(
              height: availableHeight * 0.48,
              child: _buildCarousel(),
            ),

            // Auth Section - 34% height (no padding, directly connected)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                  top: 0, // No top padding
                ),
                child: _buildAuthSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.go('/onboarding'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child:
                  const Icon(Icons.arrow_back, color: Colors.white70, size: 18),
            ),
          ),
          const Spacer(),
          // AI Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF13C8EC).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: const Color(0xFF13C8EC).withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 12, color: Color(0xFF13C8EC)),
                SizedBox(width: 5),
                Text(
                  'ANALISIS AI SELESAI',
                  style: TextStyle(
                    color: Color(0xFF13C8EC),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildHeadline() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [
              const TextSpan(text: 'Rekomendasi '),
              TextSpan(
                text: 'Matches',
                style: TextStyle(
                  color: const Color(0xFF13C8EC),
                  shadows: [
                    Shadow(
                        color: const Color(0xFF13C8EC).withOpacity(0.4),
                        blurRadius: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style:
                TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5)),
            children: const [
              TextSpan(text: 'Berdasarkan vibe brand Anda: '),
              TextSpan(
                  text: 'Minimalis + Organik',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (i) => setState(() => _currentPage = i),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final item = _recommendations[index];
        final isActive = index == _currentPage;

        return AnimatedOpacity(
          opacity: isActive ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 250),
          child: AnimatedScale(
            scale: isActive ? 1.0 : 0.88,
            duration: const Duration(milliseconds: 250),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: const Color(0xFF1A2E32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1A2E32),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined,
                                  size: 40,
                                  color: Colors.white.withOpacity(0.15)),
                              const SizedBox(height: 6),
                              Text(item['name'],
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.2),
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.85)
                          ],
                          stops: const [0.0, 0.35, 1.0],
                        ),
                      ),
                    ),
                    // Best Match
                    if (item['isBestMatch'] == true)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'BEST MATCH',
                            style: TextStyle(
                                color: Color(0xFF13C8EC),
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8),
                          ),
                        ),
                      ),
                    // Bottom Info
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(item['spec'],
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Glass Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.03),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Jangan sampai progresmu hilang.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                'Buat akun untuk kustomisasi dan pesan.',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
              const SizedBox(height: 20),

              // Apple Button - White
              _AuthButton(
                label: 'Lanjutkan dengan Apple',
                icon: Icons.apple,
                bgColor: Colors.white,
                textColor: Colors.black,
                onTap: () => context.go('/home'),
              ),
              const SizedBox(height: 10),

              // Google Button - Dark with colored icon
              _AuthButton(
                label: 'Lanjutkan dengan Google',
                isGoogle: true,
                bgColor: const Color(0xFF1A2E32), // Dark
                textColor: Colors.white,
                onTap: () => context.go('/home'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Login link with bold lime green "Log in"
        GestureDetector(
          onTap: () => context.go('/home'),
          child: RichText(
            text: TextSpan(
              style:
                  TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
              children: [
                const TextSpan(text: 'Sudah punya akun? '),
                TextSpan(
                  text: 'Masuk',
                  style: TextStyle(
                    color: AppColors.primary, // Lime green
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool isGoogle;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const _AuthButton({
    required this.label,
    this.icon,
    this.isGoogle = false,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<_AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.bgColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Icon(widget.icon, size: 20, color: widget.textColor),
              if (widget.isGoogle) _buildGoogleIcon(),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    // Use PNG image for Google logo
    return Image.asset(
      'assets/images/google_icon.png',
      width: 20,
      height: 20,
      errorBuilder: (_, __, ___) => const SizedBox(
        width: 20,
        height: 20,
        child: Center(
          child: Text('G',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Blue arc (top-right)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.4
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      -0.8,
      1.6,
      false,
      bluePaint,
    );

    // Green arc (bottom-right)
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.4
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      0.8,
      1.0,
      false,
      greenPaint,
    );

    // Yellow arc (bottom-left)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.4
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      1.8,
      1.0,
      false,
      yellowPaint,
    );

    // Red arc (top-left)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.4
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      2.8,
      0.9,
      false,
      redPaint,
    );

    // Horizontal bar (blue continuation)
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(size.width, center.dy),
      bluePaint..strokeWidth = radius * 0.35,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
