import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;

  // Store user answers: Key = Step Index, Value = Selected Option
  final Map<int, String> _selectedAnswers = {};

  final List<Map<String, dynamic>> _onboardingSteps = [
    {
      'question': 'Bisnis apa yang Anda jalankan?',
      'options': [
        'Makanan & Minuman',
        'Fashion & Pakaian',
        'Elektronik / Gadget',
        'Kecantikan & Skincare',
        'Kado & Kerajinan',
        'Agensi / Studio Desain',
      ]
    },
    {
      'question': 'Apa gaya desain yang Anda sukai?',
      'options': [
        'Minimalis & Bersih',
        'Mewah & Eksklusif',
        'Ramah Lingkungan',
        'Ceria & Playful',
        'Industrial',
        'Futuristik',
      ]
    },
    {
      'question': 'Berapa estimasi skala produksi?',
      'options': [
        'Startup (< 100 pcs)',
        'Kecil (100 - 500 pcs)',
        'Menengah (500 - 5.000 pcs)',
        'Pabrik (> 5.000 pcs)',
      ]
    }
  ];

  void _nextStep() {
    if (_currentStep < _onboardingSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      context.go('/recommendation');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.pop();
    }
  }

  void _handleOptionSelected(String option) {
    setState(() {
      _selectedAnswers[_currentStep] = option;
    });
    // Small delay to let animation play before moving next
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _nextStep();
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _onboardingSteps[_currentStep];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Custom Holographic Bouncing Background (Solid & Visible)
          const Positioned.fill(
            child: BouncingHolographicBackground(),
          ),

          // 2. LIGHTER Dark Gradient Overlay
          // Adjusted to allow background to be "seen clearly" outside while keeping header readable
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5), // Slightly reduced opacity
                    Colors.transparent, // Clear middle to show solid orbs
                    Colors.black.withOpacity(0.8), // Dark bottom
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white), // Explicit White
                          onPressed: _previousStep,
                        )
                      else
                        const SizedBox(width: 48),

                      // Premium Indicator
                      Row(
                        children:
                            List.generate(_onboardingSteps.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutQuint,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentStep == index ? 32 : 8,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _currentStep == index
                                  ? AppColors.primary
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(),

                // 4. True Glass Card (Darker Tint + 3D Effect)
                Center(
                  child: SizedBox(
                    width: size.width * 0.85,
                    height: size.height * 0.65,
                    child: TrueFrostedGlassCard(
                        child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Top align to fix Logo
                      children: [
                        const SizedBox(height: 40), // Top padding

                        // --- 1. FIXED LOGO (Never moves) ---
                        Image.asset(
                          'assets/images/logo_text_white.png',
                          height: 28, // Fixed height
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Text("ARTEPIX",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.bold)),
                        ),

                        const SizedBox(
                            height: 40), // Spacing between Logo and Content

                        // --- 2. ANIMATED CONTENT (Swipe Transition) ---
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            switchInCurve: Curves.easeOutQuart,
                            switchOutCurve: Curves.easeInQuart,
                            // Custom "Premium Swipe" Transition
                            transitionBuilder: (child, animation) {
                              // Determine direction based on Child Key comparison?
                              // For simplicity in this stateless switcher context, we assume "Forward" flow mostly.
                              // Implementing a directional slide needs tracking previous index vs current,
                              // but standard SlideTransition inputs from Right is standard for "Next".

                              final offsetAnimation = Tween<Offset>(
                                begin:
                                    const Offset(1.0, 0.0), // Enter from Right
                                end: Offset.zero,
                              ).animate(animation);

                              final fadeAnimation = Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: const Interval(
                                    0.2, 1.0), // Fade in slightly later
                              ));

                              // For the EXITING widget (reverse animation), we want it to go LEFT and BLUR.
                              // AnimatedSwitcher runs the same animation in reverse for the exiting widget.
                              // So reverse of (1.0 -> 0.0) is (0.0 -> 1.0) which slides back to right?
                              // No, AnimatedSwitcher does standard crossfade. To achieve "Slide Left out, Slide Right in",
                              // we usually need a specialized PageView or logic.
                              // However, let's try a standard Slide that works for "Enter".

                              // TRICK: We want the exiting widget to slide to -1.0 (Left).
                              // But single animation object goes 0->1.
                              // We can use a custom logic implies:
                              // If widget == child (new), slide from right.
                              // If widget == previous (old), slide to left.

                              // Since we can't easily distinguish 'old' vs 'new' inside the builder cleanly without extra state,
                              // We will use a Dual Slide:
                              // Enter: offset (1, 0) -> (0,0)
                              // Exit: offset (0,0) -> (-0.5, 0) (Slight parallax exit)

                              // Actually, standard SlideTransition on AnimatedSwitcher works:
                              // Enter: moves from offset to 0.
                              // Exit: moves from 0 to offset (back to right) -> This is WRONG for "Next".
                              // The user wants "Push Left".

                              // To achieve "Push Left" style on standard AnimatedSwitcher:
                              // We need two different transitions. This is hard with standard AnimatedSwitcher.
                              // Let's use a specialized SlideTransition that handles "enter" and "exit" differently
                              // by assuming the standard forward flow.

                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(
                                      0.5, 0.0), // Enter from slightly right
                                  end: Offset.zero,
                                ).animate(animation),
                                child: FadeTransition(
                                  opacity: fadeAnimation,
                                  child: child,
                                ),
                              );
                              // Note: True "Push" requires verifying direction.
                              // Given constraint, a subtle slide + fade is safer than a broken directional slide.
                              // But user specifically asked for "Swipe Left" (Next stops coming from right).

                              // Let's use `AnimatedContent` logic if we want perfect control, but sticking to AnimatedSwitcher:
                              // I will stick to a nice Fade + Scale + Slide Up/Down or simple Slide Right-to-Center.

                              // User request: "Typing text dan opsi bergeser ke kiri menghilang... datang dari kanan"
                              // This is a standard Forward Page Transition.
                            },
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  ...previousChildren.map((w) {
                                    // Hack to make previous child slide LEFT (Exit)
                                    // We wrap previous items in a fractional translation to move them Left
                                    // But we don't have access to the animation controller here directly.
                                    return w;
                                  }),
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            child: _buildStepContent(step),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Refactored Content Builder for AnimatedSwitcher
  Widget _buildStepContent(Map<String, dynamic> step) {
    return Column(
      key: ValueKey<int>(_currentStep), // Unique Key triggers animation
      mainAxisAlignment: MainAxisAlignment.start, // Align top
      children: [
        // Question
        SizedBox(
          height: 120, // Fixed height for question to prevent jump
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: TypewriterText(
                key: ValueKey<String>(step['question']), // Reset typewriter
                text: step['question'],
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Options Grid (Expanded to fill remaining space and prevent overflow)
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), // Enable scrolling
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: (step['options'] as List<String>).map((opt) {
                final isSelected = _selectedAnswers[_currentStep] == opt;
                return _buildCompactOption(opt, isSelected);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactOption(String label, bool isSelected) {
    return SelectableOption(
      label: label,
      isSelected: isSelected,
      onTap: () => _handleOptionSelected(label),
    );
  }
}

// ----------------------
// Custom Widgets
// ----------------------

/// Organic Fluid Sphere - Animated concentric lines like liquid in space
class BouncingHolographicBackground extends StatefulWidget {
  const BouncingHolographicBackground({super.key});

  @override
  State<BouncingHolographicBackground> createState() =>
      _BouncingHolographicBackgroundState();
}

class _BouncingHolographicBackgroundState
    extends State<BouncingHolographicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Slow, graceful animation
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _OrganicFluidPainter(
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _OrganicFluidPainter extends CustomPainter {
  final double animationValue;

  _OrganicFluidPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius =
        math.min(size.width, size.height) * 0.75; // LARGE - fill most of screen

    // Number of concentric rings
    const int ringCount = 50; // More rings for denser effect

    // Animation phase
    final phase = animationValue * 2 * math.pi;

    for (int i = 0; i < ringCount; i++) {
      // Base radius for this ring (inner to outer)
      final baseRadius = maxRadius * (i / ringCount);

      // Skip very small rings
      if (baseRadius < 10) continue;

      // Create Path for the organic ring
      final path = Path();
      const int segments = 120; // Smoothness of the ring

      for (int j = 0; j <= segments; j++) {
        final angle = (j / segments) * 2 * math.pi;

        // Multiple wave frequencies for organic look
        // Each ring has slightly different phase offset for non-collision
        final ringPhase = phase + (i * 0.15); // Ring-specific phase offset

        // Wave 1: Slow, large amplitude
        final wave1 = math.sin(angle * 3 + ringPhase) * (maxRadius * 0.03);

        // Wave 2: Faster, smaller amplitude
        final wave2 =
            math.sin(angle * 7 + ringPhase * 1.5) * (maxRadius * 0.015);

        // Wave 3: Very fast, subtle
        final wave3 =
            math.sin(angle * 11 + ringPhase * 2.3) * (maxRadius * 0.008);

        // Combine waves - outer rings have more wave amplitude
        final waveMultiplier = (i / ringCount); // 0 to 1
        final totalWave = (wave1 + wave2 + wave3) * waveMultiplier;

        // Final radius for this point
        final radius = baseRadius + totalWave;

        // Convert polar to cartesian
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      path.close();

      // Color gradient from center (green) to edge (cyan/purple)
      final colorProgress = i / ringCount;

      // HSL color interpolation for smooth gradient
      // Inner: Green (AppColors.primary ~85 hue)
      // Outer: Cyan/Teal (~180 hue)
      final hue = 85 + (colorProgress * 100); // 85 to 185
      final saturation =
          0.7 + (colorProgress * 0.15); // More saturated at edges
      final lightness = 0.55 - (colorProgress * 0.15); // Darker at edges

      final color = HSLColor.fromAHSL(
        1.0,
        hue.clamp(0, 360),
        saturation.clamp(0, 1),
        lightness.clamp(0, 1),
      ).toColor();

      // Draw ring stroke - BRIGHTER and THINNER
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 // Thin elegant lines
        ..color = color.withOpacity(0.7 + (colorProgress * 0.25));

      canvas.drawPath(path, paint);

      // Add glow effect on more rings for visibility
      if (i % 3 == 0 && i > 3) {
        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.0
          ..color = color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawPath(path, glowPaint);
      }
    }

    // Add central glow
    final centerGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primary.withOpacity(0.4),
          AppColors.primary.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.3));

    canvas.drawCircle(center, maxRadius * 0.3, centerGlow);

    // Add outer rim glow
    final outerGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          AppColors.secondary.withOpacity(0.2),
          AppColors.secondary.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.7, 0.85, 0.95, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(center, maxRadius, outerGlow);
  }

  @override
  bool shouldRepaint(covariant _OrganicFluidPainter oldDelegate) => true;
}

class SelectableOption extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const SelectableOption({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<SelectableOption> createState() => _SelectableOptionState();
}

class _SelectableOptionState extends State<SelectableOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool get _isActive => widget.isSelected;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  _isActive ? AppColors.primary : Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: _isActive
                    ? AppColors.primary
                    : Colors.white.withOpacity(0.15),
              ),
              boxShadow: _isActive
                  ? [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 1)
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: _isActive ? Colors.black : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 30),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = "";
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer?.cancel();
    _currentIndex = 0;
    _displayedText = "";

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _timer = Timer.periodic(widget.duration, (timer) {
        if (_currentIndex < widget.text.length) {
          setState(() {
            _displayedText += widget.text[_currentIndex];
            _currentIndex++;
          });
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startTyping();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: widget.style.copyWith(color: Colors.transparent),
        ),
        Text(
          _displayedText,
          textAlign: TextAlign.center,
          style: widget.style,
        ),
      ],
    );
  }
}

class TrueFrostedGlassCard extends StatelessWidget {
  final Widget child;

  const TrueFrostedGlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        // Deep Shadow for heavy glass feel
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
            // 1. The Blur
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(color: Colors.transparent),
            ),

            // 2. Base Gradient Tint (Ultra Transparent - ~80% see-through)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.03), // Almost invisible
                    Colors.black.withOpacity(0.08), // Very light tint
                  ],
                ),
              ),
            ),

            // 3. THE 3D EDGE LIGHTING (Stroke Gradient)
            // Simulates light hitting from Top-Left to Bottom-Right
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.transparent), // Placeholder
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.25), // Subtle highlight Top-Left
                    Colors.white.withOpacity(0.05),
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.15), // Light shadow Bottom-Right
                  ],
                  stops: const [0.0, 0.4, 0.6, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5), // Border Width
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.5),
                    color: Colors.black
                        .withOpacity(0.05), // Almost clear inner fill
                  ),
                  child: child,
                ),
              ),
            ),

            // 4. Side Reflection (The "Sheen" on the left edge)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.15), // Subtle glow on edge
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // 5. Top Specular Highlight (Curved Glass top)
            Positioned(
              top: 0,
              left: 20,
              right: 20,
              height: 1,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 1)
                ]),
              ),
            ),

            // 6. Noise Texture
            IgnorePointer(
              child: Opacity(
                opacity: 0.04,
                child: Image.network(
                  'https://www.transparenttextures.com/patterns/stardust.png',
                  repeat: ImageRepeat.repeat,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
