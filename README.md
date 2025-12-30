<div align="center">

# 🩺 Pasteur

### Intelligent Medical Assistant for Tunisia

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Gemini AI](https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

**Pasteur** is an AI-powered mobile health assistant designed specifically for the Tunisian healthcare context. Built with Flutter, it empowers users to take control of their health through intelligent insights, vital tracking, and seamless medical appointment management.

[Features](#-features) • [Tech Stack](#️-tech-stack) • [Getting Started](#-getting-started) • [Screenshots](#-screenshots) • [Contributing](#-contributing)

<img src="https://user-images.githubusercontent.com/74038190/212284100-561aa473-3905-4a80-b561-0d28506553ee.gif" width="100%">

</div>

---

## 🌟 Features

### 🤖 AI-Powered Health Assistant
- **Gemini AI Integration**: Get instant, intelligent answers to your health questions
- **Personalized Health Insights**: AI-driven recommendations based on your health data
- **24/7 Medical Guidance**: Available anytime to help you understand symptoms and conditions

### 🔐 Secure Authentication & Privacy
- **User Registration & Login**: Quick and easy account setup
- **Two-Factor Authentication (2FA)**: Enhanced security for your sensitive health data
- **Local Data Encryption**: Your medical information stays private and secure

### 📊 Comprehensive Health Tracking
- **Vital Signs Monitoring**: Track heart rate, blood pressure, temperature, and more
- **Interactive Charts**: Visualize health trends over time with beautiful, easy-to-read graphs
- **Health Metrics Dashboard**: Get a complete overview of your wellness at a glance
- **Historical Data**: Access and analyze your health history

### 👨‍⚕️ Doctor Directory & Appointments
- **Comprehensive Doctor Database**: Browse verified medical professionals across Tunisia
- **Detailed Doctor Profiles**: View specializations, qualifications, and patient reviews
- **Smart Search & Filters**: Find the right doctor for your needs quickly
- **Integration with med.tn**: Real-time data from Tunisia's leading medical directory
- **Contact Information**: Direct access to phone numbers and clinic addresses

### 📂 Personal Medical Profile
- **Medical History Management**: Keep track of past diagnoses and treatments
- **Medication Tracker**: Never miss a dose with smart reminders
- **Lifestyle Tracking**: Monitor diet, exercise, and wellness habits
- **Emergency Information**: Quick access to critical health data when needed

### 📍 Location-Based Services
- **OpenStreetMap Integration**: Find nearby hospitals, clinics, and pharmacies
- **Navigation Support**: Get directions to medical facilities
- **Emergency Services Locator**: Quickly find the nearest emergency care

---

## 🛠️ Tech Stack

<div align="center">

### Core Technologies

<p>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" alt="Flutter" width="50" height="50"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" alt="Dart" width="50" height="50"/>
  <img src="https://www.vectorlogo.zone/logos/google/google-icon.svg" alt="Google AI" width="50" height="50"/>
</p>

</div>

| Category | Technologies |
|----------|-------------|
| **Framework** | Flutter (Dart) |
| **State Management** | Provider |
| **Local Database** | Hive, Shared Preferences |
| **Networking** | HTTP Package |
| **AI Integration** | Google Generative AI (Gemini) |
| **Data Visualization** | fl_chart |
| **Maps & Location** | flutter_map, latlong2, OpenStreetMap |
| **UI Components** | flutter_svg, google_fonts |
| **Security** | Two-Factor Authentication, Local Encryption |

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- IDE: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- [Git](https://git-scm.com/)
- **Gemini API Key** ([Get it here](https://ai.google.dev/))

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/youssef-ben-letaifa/Pasteur.git
   cd Pasteur
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   
   Create a `.env` file in the root directory (if not exists):
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. **Run the app**
   ```bash
   # For Android
   flutter run
   
   # For iOS
   flutter run -d ios
   
   # For Web
   flutter run -d chrome
   ```

5. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

---

## 📁 Project Structure

```
lib/
├── config/              # App-wide configuration
│   ├── theme.dart       # App themes and styling
│   └── constants.dart   # Global constants
├── models/              # Data models
│   ├── user.dart        # User model
│   ├── doctor.dart      # Doctor model
│   ├── vitals.dart      # Health vitals model
│   └── appointment.dart # Appointment model
├── screens/             # UI Screens
│   ├── auth/            # Authentication screens
│   ├── home/            # Home dashboard
│   ├── health/          # Health tracking screens
│   ├── doctors/         # Doctor directory & details
│   └── profile/         # User profile management
├── services/            # Business logic & API calls
│   ├── auth_service.dart      # Authentication logic
│   ├── doctor_service.dart    # Doctor data handling
│   ├── health_service.dart    # Health tracking logic
│   └── ai_service.dart        # Gemini AI integration
├── widgets/             # Reusable UI components
│   ├── custom_button.dart
│   ├── health_card.dart
│   └── chart_widget.dart
└── main.dart            # Application entry point
```

---

## 📱 Screenshots

<div align="center">

| Home Dashboard | Health Tracking | AI Assistant |
|:--------------:|:---------------:|:------------:|
| ![Home](assets/screenshots/home.png) | ![Health](assets/screenshots/health.png) | ![AI](assets/screenshots/ai.png) |

| Doctor Directory | Appointment | Profile |
|:----------------:|:-----------:|:-------:|
| ![Doctors](assets/screenshots/doctors.png) | ![Appointment](assets/screenshots/appointment.png) | ![Profile](assets/screenshots/profile.png) |

</div>

> **Note**: Add actual screenshots to the `assets/screenshots/` directory

---

## 🎯 Roadmap

- [x] AI Health Assistant Integration
- [x] Vital Signs Tracking
- [x] Doctor Directory
- [x] Two-Factor Authentication
- [ ] Appointment Booking System
- [ ] Telemedicine Video Calls
- [ ] Prescription Management
- [ ] Integration with Tunisian Health Insurance
- [ ] Multi-language Support (Arabic, French, English)
- [ ] Wearable Device Integration
- [ ] Medicine Reminder Notifications

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

1. **Fork the Project**
   ```bash
   git fork https://github.com/youssef-ben-letaifa/Pasteur.git
   ```

2. **Create your Feature Branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. **Commit your Changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```

4. **Push to the Branch**
   ```bash
   git push origin feature/AmazingFeature
   ```

5. **Open a Pull Request**

### Development Guidelines

- Follow [Flutter best practices](https://docs.flutter.dev/development/best-practices)
- Write clear commit messages
- Add tests for new features
- Update documentation as needed
- Ensure code is formatted (`flutter format .`)

---

## 🐛 Known Issues & Limitations

- med.tn parsing may occasionally fail due to website structure changes
- Offline mode has limited functionality
- iOS build requires Apple Developer account for deployment

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Youssef BEN LETAIFA**

- GitHub: [@youssef-ben-letaifa](https://github.com/youssef-ben-letaifa)
- LinkedIn: [Youssef Ben Letaifa](https://www.linkedin.com/in/youssefbenletaifa/)
- Portfolio: [youssef-ben-letaifa.github.io](https://youssef-ben-letaifa.github.io/ben.letaifa.youssef/)

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) for the amazing framework
- [Google Gemini AI](https://ai.google.dev/) for AI capabilities
- [OpenStreetMap](https://www.openstreetmap.org/) for mapping services
- [med.tn](https://www.med.tn/) for medical directory data
- All contributors and supporters of this project

---

<div align="center">

### 💙 If you find this project helpful, please give it a ⭐!

**Built with ❤️ for the Tunisian Healthcare Community**

[![GitHub stars](https://img.shields.io/github/stars/youssef-ben-letaifa/Pasteur?style=social)](https://github.com/youssef-ben-letaifa/Pasteur/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/youssef-ben-letaifa/Pasteur?style=social)](https://github.com/youssef-ben-letaifa/Pasteur/network/members)

</div>
