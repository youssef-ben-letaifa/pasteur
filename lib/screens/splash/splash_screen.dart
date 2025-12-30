import 'package:flutter/material.dart';
import 'dart:async';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    // Navigate after splash duration
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(Duration(seconds: AppConstants.splashDuration));

    if (!mounted) return;

    final authService = AuthService();
    final isFirstLaunch = await authService.isFirstLaunch();
    final isLoggedIn = await authService.isLoggedIn();

    if (isFirstLaunch) {
      // First time launching, go to registration
      await authService.setFirstLaunch(false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.registration);
      }
    } else if (isLoggedIn) {
      // Already logged in, go to profile/home
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
      }
    } else {
      // Not logged in, go to login screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightBlue.withValues(alpha: 0.1),
              AppTheme.primaryBlue.withValues(alpha: 0.2),
              AppTheme.lightBlue.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Medical Emoji
                  const Text('🩺', style: TextStyle(fontSize: 120)),
                  const SizedBox(height: 32),

                  // Welcome Message
                  Text(
                    'Welcome to Pasteur',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'Your AI Medical Assistant',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.darkBlue.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Loading indicator
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
