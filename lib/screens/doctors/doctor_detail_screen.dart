import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/doctor_model.dart';

class DoctorDetailScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  Future<void> _makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightBlue.withValues(alpha: 0.2),
                    AppTheme.primaryBlue.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryBlue,
                    child: Text(
                      doctor.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    doctor.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      doctor.specialty,
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (doctor.rating != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < doctor.rating!.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: AppTheme.warningColor,
                            size: 20,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          doctor.rating!.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Information Sections
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Information
                  _buildSectionTitle(context, 'Contact Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, [
                    if (doctor.phone != null)
                      _buildInfoRow(
                        Icons.phone,
                        'Phone',
                        doctor.phone!,
                        onTap: () => _makePhoneCall(doctor.phone!),
                      ),
                    if (doctor.email != null)
                      _buildInfoRow(
                        Icons.email,
                        'Email',
                        doctor.email!,
                        onTap: () => _sendEmail(doctor.email!),
                      ),
                    _buildInfoRow(
                      Icons.location_on,
                      'Address',
                      doctor.fullAddress,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Professional Information
                  if (doctor.yearsOfExperience != null ||
                      doctor.education != null ||
                      doctor.languages != null) ...[
                    _buildSectionTitle(context, 'Professional Information'),
                    const SizedBox(height: 12),
                    _buildInfoCard(context, [
                      if (doctor.yearsOfExperience != null)
                        _buildInfoRow(
                          Icons.work,
                          'Experience',
                          '${doctor.yearsOfExperience} years',
                        ),
                      if (doctor.education != null)
                        _buildInfoRow(
                          Icons.school,
                          'Education',
                          doctor.education!,
                        ),
                      if (doctor.languages != null)
                        _buildInfoRow(
                          Icons.language,
                          'Languages',
                          doctor.languages!.join(', '),
                        ),
                      if (doctor.workingHours != null)
                        _buildInfoRow(
                          Icons.access_time,
                          'Working Hours',
                          doctor.workingHours!,
                        ),
                    ]),
                    const SizedBox(height: 24),
                  ],

                  // Map Button
                  if (doctor.latitude != null && doctor.longitude != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _openMaps(doctor.latitude!, doctor.longitude!),
                        icon: const Icon(Icons.map),
                        label: const Text('Open in Maps'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
