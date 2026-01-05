import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';

/// SplashScreen - Linear Style Welcome with Liquid Particles
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _blobController;
  late AnimationController _fadeController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Background Blob Animation
    _blobController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    // UI Fade In Animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _blobController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Brand Color (Lime/Volt)
    final brandColor = AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.black, // Pure black for Linear feel
      body: Stack(
        children: [
          // 1. Background: Liquid Particle Blur
          _buildAnimatedBackground(brandColor),

          // 2. Content: Logo & Text (Centered)
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glassy Logo Container (Subtle)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.white.withOpacity(0.03),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: brandColor.withOpacity(0.1),
                            blurRadius: 40,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image.asset(
                              'assets/images/artepix_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Welcome Text
                    const Text(
                      'Selamat datang di',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Artepix',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Action: "Get started" Button
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildGetStartedButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(Color brandColor) {
    return AnimatedBuilder(
      animation: _blobController,
      builder: (context, child) {
        final t = _blobController.value;

        return Stack(
          children: [
            // Blob 1: Lime Green (Top Left movement)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2 +
                  math.sin(t * 2 * math.pi) * 60,
              left: MediaQuery.of(context).size.width * 0.2 +
                  math.cos(t * 2 * math.pi) * 40,
              child: _buildBlurBlob(
                size: 300,
                color: brandColor.withOpacity(0.15),
                blur: 120,
              ),
            ),

            // Blob 2: Cyan/Blue Mix (Bottom Right movement)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2 +
                  math.cos(t * 2 * math.pi) * 50,
              right: MediaQuery.of(context).size.width * 0.1 +
                  math.sin(t * 2 * math.pi) * 30,
              child: _buildBlurBlob(
                size: 350,
                color: Colors.blue.withOpacity(0.1),
                blur: 140,
              ),
            ),

            // Blob 3: White Highlight (Center pulsing)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 +
                  math.sin(t * 4 * math.pi) * 20,
              left: MediaQuery.of(context).size.width * 0.5 - 100,
              child: _buildBlurBlob(
                size: 200,
                color: Colors.white.withOpacity(0.02),
                blur: 80,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlurBlob({
    required double size,
    required Color color,
    required double blur,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blur,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/onboarding'), // Navigate to Onboarding
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF2A2A2A), // Dark gray button like Linear
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mulai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
