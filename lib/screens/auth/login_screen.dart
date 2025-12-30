import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _twoFAController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _show2FAField = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _twoFAController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        twoFACode: _show2FAField ? _twoFAController.text.trim() : null,
      );

      if (!mounted) return;

      // Navigate to profile/home
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    } catch (e) {
      if (!mounted) return;

      // Check if error is about needing 2FA
      if (e.toString().contains('2FA code required')) {
        setState(() => _show2FAField = true);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e
                .toString()
                .replaceAll('Exception: ', '')
                .replaceAll('Login failed: ', ''),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo/Icon
                const Center(child: Text('🩺', style: TextStyle(fontSize: 80))),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'Login to continue to Pasteur',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Username Field
                CustomTextField(
                  controller: _usernameController,
                  label: 'Username',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                // 2FA Field (conditional)
                if (_show2FAField) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _twoFAController,
                    label: '2FA Code',
                    hint: 'Enter your 6-digit code',
                    prefixIcon: Icons.security,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your 2FA code';
                      }
                      if (value.length != 6) {
                        return '2FA code must be 6 digits';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 32),

                // Login Button
                CustomButton(
                  text: 'Login',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.registration,
                        );
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
