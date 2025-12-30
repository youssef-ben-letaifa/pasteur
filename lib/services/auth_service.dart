import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../config/constants.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Hash password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate random 6-digit  2FA code
  String generate2FACode() {
    final random = Random();
    final code = random.nextInt(900000) + 100000; // 6-digit code
    return code.toString();
  }

  // Register new user
  Future<UserModel> register({
    required String name,
    required String username,
    required String password,
    String? email,
  }) async {
    try {
      // Check if username already exists
      try {
        final existingUser = _databaseService.getUserByUsername(username);
        if (existingUser != null) {
          throw Exception('Username already exists');
        }
      } catch (e) {
        // User not found, proceed with registration
      }

      // Validate password length
      if (password.length < AppConstants.minPasswordLength) {
        throw Exception(
          'Password must be at least ${AppConstants.minPasswordLength} characters',
        );
      }

      if (password.length > AppConstants.maxPasswordLength) {
        throw Exception(
          'Password must not exceed ${AppConstants.maxPasswordLength} characters',
        );
      }

      // Validate username length
      if (username.length < AppConstants.minUsernameLength) {
        throw Exception(
          'Username must be at least ${AppConstants.minUsernameLength} characters',
        );
      }

      // Create new user
      final now = DateTime.now();
      final userId = '${DateTime.now().millisecondsSinceEpoch}_$username';

      final user = UserModel(
        id: userId,
        name: name,
        username: username,
        passwordHash: _hashPassword(password),
        email: email,
        is2FAEnabled: false,
        createdAt: now,
        updatedAt: now,
      );

      await _databaseService.saveUser(user);
      await _setCurrentUser(userId);

      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Login user
  Future<UserModel> login({
    required String username,
    required String password,
    String? twoFACode,
  }) async {
    try {
      final user = _databaseService.getUserByUsername(username);

      if (user == null) {
        throw Exception('Invalid username or password');
      }

      // Verify password
      final hashedPassword = _hashPassword(password);
      if (user.passwordHash != hashedPassword) {
        throw Exception('Invalid username or password');
      }

      // Check 2FA if enabled
      if (user.is2FAEnabled) {
        if (twoFACode == null) {
          throw Exception('2FA code required');
        }

        if (user.twoFACode != twoFACode) {
          throw Exception('Invalid 2FA code');
        }
      }

      await _setCurrentUser(user.id);
      await _setLoggedIn(true);

      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Enable 2FA
  Future<String> enable2FA(String userId, String email) async {
    try {
      final user = _databaseService.getUser(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final code = generate2FACode();
      user.is2FAEnabled = true;
      user.twoFACode = code;
      user.email = email;
      user.updatedAt = DateTime.now();

      await _databaseService.saveUser(user);

      return code;
    } catch (e) {
      throw Exception('Failed to enable 2FA: ${e.toString()}');
    }
  }

  // Disable 2FA
  Future<void> disable2FA(String userId) async {
    try {
      final user = _databaseService.getUser(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      user.is2FAEnabled = false;
      user.twoFACode = null;
      user.updatedAt = DateTime.now();

      await _databaseService.saveUser(user);
    } catch (e) {
      throw Exception('Failed to disable 2FA: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    await _setLoggedIn(false);
    await _setCurrentUser('');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  // Get current user ID
  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.currentUserIdKey);
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final userId = await getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      return null;
    }
    return _databaseService.getUser(userId);
  }

  // Check if first launch
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isFirstLaunchKey) ?? true;
  }

  // Set first launch
  Future<void> setFirstLaunch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isFirstLaunchKey, value);
  }

  // Private helper methods
  Future<void> _setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isLoggedInKey, value);
  }

  Future<void> _setCurrentUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.currentUserIdKey, userId);
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    user.updatedAt = DateTime.now();
    await _databaseService.saveUser(user);
  }

  // Change password
  Future<void> changePassword(String userId, String newPassword) async {
    final user = _databaseService.getUser(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    if (newPassword.length < AppConstants.minPasswordLength) {
      throw Exception(
        'Password must be at least ${AppConstants.minPasswordLength} characters',
      );
    }

    user.passwordHash = _hashPassword(newPassword);
    user.updatedAt = DateTime.now();

    await _databaseService.saveUser(user);
  }
}
