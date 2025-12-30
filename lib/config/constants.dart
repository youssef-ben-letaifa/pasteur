class AppConstants {
  // API Configuration
  static const String geminiApiKey = ' XXXXXXXXXXXXXXXX USE YOUR API KEY ';
  static const String geminiModelEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  // Med.tn Website
  static const String medTnUrl = 'https://www.med.tn/';

  // App Settings
  static const int splashDuration = 4; // seconds
  static const String appName = 'Pasteur';

  // Database Keys
  static const String userBoxName = 'user_box';
  static const String healthBoxName = 'health_box';
  static const String chatBoxName = 'chat_box';

  // Preferences Keys
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String isLoggedInKey = 'is_logged_in';
  static const String currentUserIdKey = 'current_user_id';

  // Email Configuration (for 2FA)
  static const String smtpHost = 'smtp.gmail.com';
  static const int smtpPort = 587;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
}
