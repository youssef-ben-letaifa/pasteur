import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/registration_screen.dart';
import '../screens/onboarding/two_fa_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/health/health_dashboard.dart';
import '../screens/doctors/doctor_list_screen.dart';
import '../screens/doctors/doctor_detail_screen.dart';
import '../models/doctor_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String registration = '/registration';
  static const String twoFA = '/two-fa';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String health = '/health';
  static const String doctors = '/doctors';
  static const String doctorDetail = '/doctor-detail';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    registration: (context) => const RegistrationScreen(),
    twoFA: (context) => const TwoFAScreen(),
    login: (context) => const LoginScreen(),
    profile: (context) => const ProfileScreen(),
    chat: (context) => const ChatScreen(),
    health: (context) => const HealthDashboard(),
    doctors: (context) => const DoctorListScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case doctorDetail:
        final doctor = settings.arguments as DoctorModel;
        return MaterialPageRoute(
          builder: (context) => DoctorDetailScreen(doctor: doctor),
        );
      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}
