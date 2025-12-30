import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/doctor_service.dart';
import '../../models/doctor_model.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final _doctorService = DoctorService();
  List<DoctorModel> _doctors = [];
  List<DoctorModel> _filteredDoctors = [];
  bool _isLoading = false;

  String? _selectedSpecialty;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);

    _doctors = await _doctorService.searchDoctors();
    _filteredDoctors = _doctors;

    setState(() => _isLoading = false);
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        final matchesSpecialty =
            _selectedSpecialty == null ||
            doctor.specialty.contains(_selectedSpecialty!);
        final matchesCity =
            _selectedCity == null || doctor.city.contains(_selectedCity!);
        return matchesSpecialty && matchesCity;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Doctors')),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.backgroundColor,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedSpecialty,
                        decoration: const InputDecoration(
                          labelText: 'Specialty',
                          prefixIcon: Icon(Icons.medical_services),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Specialties'),
                          ),
                          ..._doctorService.getAllSpecialties().map((
                            specialty,
                          ) {
                            return DropdownMenuItem(
                              value: specialty,
                              child: Text(specialty),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedSpecialty = value);
                          _filterDoctors();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Cities'),
                          ),
                          ..._doctorService.getAllCities().map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedCity = value);
                          _filterDoctors();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Doctors List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDoctors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_hospital_outlined,
                          size: 80,
                          color: AppTheme.lightBlue,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No doctors found',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try adjusting your filters',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(_filteredDoctors[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.doctorDetail,
            arguments: doctor,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.lightBlue,
                    child: Text(
                      doctor.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.specialty,
                          style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (doctor.rating != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppTheme.warningColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            doctor.rating!.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      doctor.fullAddress,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              if (doctor.phone != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      doctor.phone!,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
