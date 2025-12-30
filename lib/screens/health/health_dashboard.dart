import 'package:flutter/material.dart';
import '../../config/theme.dart';

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Overview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Vital Signs Card
            _buildCard(
              context,
              title: 'Vital Signs',
              icon: Icons.favorite,
              color: AppTheme.healthGood,
              children: [
                _buildMetricRow('Heart Rate', '72 bpm', Icons.favorite),
                _buildMetricRow('Blood Pressure', '120/80 mmHg', Icons.opacity),
                _buildMetricRow('Temperature', '36.6°C', Icons.thermostat),
              ],
            ),
            const SizedBox(height: 16),

            // Medications Card
            _buildCard(
              context,
              title: 'Medications',
              icon: Icons.medication,
              color: AppTheme.primaryBlue,
              children: [
                _buildMedicationRow('Aspirin', '100mg', 'Once daily'),
                _buildMedicationRow('Vitamin D', '1000 IU', 'Daily'),
              ],
            ),
            const SizedBox(height: 16),

            // Upcoming Appointments
            _buildCard(
              context,
              title: 'Reminders',
              icon: Icons.notifications,
              color: AppTheme.warningColor,
              children: [
                _buildReminderRow('Take Aspirin', '09:00 AM'),
                _buildReminderRow('Vitamin D', '08:00 PM'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new health record
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add health record feature coming soon'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMedicationRow(String name, String dosage, String frequency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.medication, size: 20, color: AppTheme.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '$dosage - $frequency',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.alarm, size: 20, color: AppTheme.warningColor),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(time, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
