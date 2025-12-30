import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class TwoFAScreen extends StatefulWidget {
  const TwoFAScreen({super.key});

  @override
  State<TwoFAScreen> createState() => _TwoFAScreenState();
}

class _TwoFAScreenState extends State<TwoFAScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isSkipping = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _setup2FA() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not found');
      }

      final code = await _authService.enable2FA(
        userId,
        _emailController.text.trim(),
      );

      if (!mounted) return;

      // Show success message with code
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('2FA Enabled'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your 2FA code is:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  code,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please save this code. You\'ll need it when logging in.',
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.profile);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _skip() async {
    setState(() => _isSkipping = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two-Factor Authentication')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Icon
              const Center(
                child: Icon(
                  Icons.security,
                  size: 80,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Secure Your Account',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(color: AppTheme.primaryBlue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'Add an extra layer of security to your account with two-factor authentication.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email Field
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'your.email@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),

              // Enable 2FA Button
              CustomButton(
                text: 'Enable 2FA',
                onPressed: _setup2FA,
                isLoading: _isLoading,
                icon: Icons.shield,
              ),
              const SizedBox(height: 16),

              // Skip Button
              CustomButton(
                text: 'Skip for Now',
                onPressed: _skip,
                isLoading: _isSkipping,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
