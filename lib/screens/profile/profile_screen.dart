import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  File? _profileImage;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber ?? '';
        _cityController.text = user.city ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && _user != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _user!.profilePicturePath = pickedFile.path;
      });
      await _authService.updateUserProfile(_user!);
    }
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;

    _user!.name = _nameController.text;
    _user!.email = _emailController.text;
    _user!.phoneNumber = _phoneController.text;
    _user!.city = _cityController.text;

    await _authService.updateUserProfile(_user!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = [
      _buildProfileTab(),
      _buildChatPlaceholder(),
      _buildHealthPlaceholder(),
      _buildDoctorsPlaceholder(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasteur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Doctors',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Picture
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.lightBlue,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : _user?.profilePicturePath != null
                      ? FileImage(File(_user!.profilePicturePath!))
                      : null,
                  child:
                      _profileImage == null && _user?.profilePicturePath == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            _user?.name ?? 'User',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            '@${_user?.username}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 32),

          // Profile Form
          CustomTextField(
            controller: _nameController,
            label: 'Full Name',
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: _emailController,
            label: 'Email',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: _phoneController,
            label: 'Phone Number',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: _cityController,
            label: 'City',
            prefixIcon: Icons.location_city,
          ),
          const SizedBox(height: 24),

          CustomButton(
            text: 'Save Changes',
            onPressed: _saveProfile,
            icon: Icons.save,
          ),
        ],
      ),
    );
  }

  Widget _buildChatPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            'AI Medical Assistant',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Chat with our AI to discuss your symptoms and get health guidance',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            },
            child: const Text('Start Conversation'),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_outline,
            size: 80,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            'Health Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Track your vital signs, medications, and health metrics',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.health);
            },
            child: const Text('View Health Data'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_hospital_outlined,
            size: 80,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            'Find Doctors',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Discover qualified doctors in Tunisia based on your needs',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.doctors);
            },
            child: const Text('Browse Doctors'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
