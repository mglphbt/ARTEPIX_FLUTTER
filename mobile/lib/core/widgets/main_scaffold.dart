import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import 'glass_navbar.dart';

/// MainScaffold - Shell for main app screens with liquid glass navigation
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  int _getCurrentIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/products')) return 1;
    if (location.startsWith('/feed')) return 2;
    if (location.startsWith('/projects')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/products');
        break;
      case 2:
        context.go('/feed');
        break;
      case 3:
        context.go('/projects');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _getCurrentIndex(location);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkBackground,
        ),
        child: child,
      ),
      bottomNavigationBar: LiquidGlassNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}
