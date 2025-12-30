import '../models/doctor_model.dart';

class DoctorService {
  static final DoctorService _instance = DoctorService._internal();
  factory DoctorService() => _instance;
  DoctorService._internal();

  // Search doctors from med.tn based on specialty and location
  Future<List<DoctorModel>> searchDoctors({
    String? specialty,
    String? city,
    String? keyword,
  }) async {
    try {
      // For now, we'll return sample doctors
      // In production, this would scrape or use an API from med.tn
      return _getSampleDoctors(specialty: specialty, city: city);
    } catch (e) {
      throw Exception('Failed to search doctors: ${e.toString()}');
    }
  }

  // Get doctor recommendations based on Gemini analysis
  Future<List<DoctorModel>> getRecommendedDoctors({
    required List<String> specialties,
    String? userCity,
  }) async {
    try {
      final List<DoctorModel> allRecommendations = [];

      for (final specialty in specialties) {
        final doctors = await searchDoctors(
          specialty: specialty,
          city: userCity,
        );
        allRecommendations.addAll(doctors);
      }

      return allRecommendations;
    } catch (e) {
      throw Exception('Failed to get recommended doctors: ${e.toString()}');
    }
  }

  // Sample doctors data (replace with actual scraping or API call)
  List<DoctorModel> _getSampleDoctors({String? specialty, String? city}) {
    // This is sample data. In production, you would:
    // 1. Scrape med.tn website (with permission)
    // 2. Use their API if available
    // 3. Maintain your own database of Tunisian doctors

    final sampleDoctors = [
      // Cardiologists
      DoctorModel(
        id: 'dr001',
        name: 'Dr. Ahmed Ben Salem',
        specialty: 'Cardiology',
        address: '15 Avenue Habib Bourguiba',
        city: 'Tunis',
        phone: '+216 71 123 456',
        email: 'ahmed.bensalem@example.tn',
        latitude: 36.8065,
        longitude: 10.1815,
        description:
            'Experienced cardiologist specializing in heart disease prevention and treatment.',
        languages: ['Arabic', 'French', 'English'],
        workingHours: 'Mon-Fri: 9:00-17:00, Sat: 9:00-13:00',
        rating: 4.7,
        yearsOfExperience: 15,
        acceptsInsurance: true,
      ),

      // General Practitioners
      DoctorModel(
        id: 'dr002',
        name: 'Dr. Samia Trabelsi',
        specialty: 'General Practice',
        address: '28 Rue de la Liberté',
        city: 'Tunis',
        phone: '+216 71 234 567',
        email: 'samia.trabelsi@example.tn',
        latitude: 36.8008,
        longitude: 10.1869,
        description:
            'General practitioner with expertise in family medicine and preventive care.',
        languages: ['Arabic', 'French'],
        workingHours: 'Mon-Sat: 8:00-19:00',
        rating: 4.5,
        yearsOfExperience: 10,
        acceptsInsurance: true,
      ),

      // Dermatologists
      DoctorModel(
        id: 'dr003',
        name: 'Dr. Karim Mansour',
        specialty: 'Dermatology',
        address: '42 Avenue Mohamed V',
        city: 'Sfax',
        phone: '+216 74 345 678',
        email: 'karim.mansour@example.tn',
        latitude: 34.7406,
        longitude: 10.7603,
        description:
            'Dermatologist specializing in skin conditions and cosmetic dermatology.',
        languages: ['Arabic', 'French', 'English'],
        workingHours: 'Mon-Fri: 10:00-18:00',
        rating: 4.8,
        yearsOfExperience: 12,
        acceptsInsurance: false,
      ),

      // Pediatricians
      DoctorModel(
        id: 'dr004',
        name: 'Dr. Leila Hamdi',
        specialty: 'Pediatrics',
        address: '67 Rue de France',
        city: 'Tunis',
        phone: '+216 71 456 789',
        email: 'leila.hamdi@example.tn',
        latitude: 36.8129,
        longitude: 10.1658,
        description:
            'Pediatrician specialized in child healthcare and development.',
        languages: ['Arabic', 'French'],
        workingHours: 'Mon-Fri: 9:00-16:00, Sat: 9:00-12:00',
        rating: 4.9,
        yearsOfExperience: 18,
        acceptsInsurance: true,
      ),

      // Neurologists
      DoctorModel(
        id: 'dr005',
        name: 'Dr. Mohamed Gharbi',
        specialty: 'Neurology',
        address: '12 Boulevard 7 Novembre',
        city: 'Sousse',
        phone: '+216 73 567 890',
        email: 'mohamed.gharbi@example.tn',
        latitude: 35.8256,
        longitude: 10.6369,
        description:
            'Neurologist with expertise in brain and nervous system disorders.',
        languages: ['Arabic', 'French', 'English'],
        workingHours: 'Mon-Thu: 10:00-17:00, Sat: 10:00-14:00',
        rating: 4.6,
        yearsOfExperience: 20,
        acceptsInsurance: true,
      ),

      // Orthopedists
      DoctorModel(
        id: 'dr006',
        name: 'Dr. Yassine Bouazizi',
        specialty: 'Orthopedics',
        address: '89 Avenue de la République',
        city: 'Tunis',
        phone: '+216 71 678 901',
        email: 'yassine.bouazizi@example.tn',
        latitude: 36.8190,
        longitude: 10.1658,
        description:
            'Orthopedic surgeon specializing in bone and joint treatments.',
        languages: ['Arabic', 'French'],
        workingHours: 'Mon-Fri: 8:00-16:00',
        rating: 4.7,
        yearsOfExperience: 14,
        acceptsInsurance: true,
      ),

      // Gastroenterologists
      DoctorModel(
        id: 'dr007',
        name: 'Dr. Nadia Jlassi',
        specialty: 'Gastroenterology',
        address: '34 Rue Charles de Gaulle',
        city: 'Tunis',
        phone: '+216 71 789 012',
        email: 'nadia.jlassi@example.tn',
        latitude: 36.8025,
        longitude: 10.1797,
        description:
            'Gastroenterologist specialized in digestive system disorders.',
        languages: ['Arabic', 'French', 'English'],
        workingHours: 'Tue-Sat: 9:00-17:00',
        rating: 4.5,
        yearsOfExperience: 11,
        acceptsInsurance: true,
      ),
    ];

    // Filter by specialty and city if provided
    var filtered = sampleDoctors;

    if (specialty != null && specialty.isNotEmpty) {
      filtered = filtered
          .where(
            (doctor) => doctor.specialty.toLowerCase().contains(
              specialty.toLowerCase(),
            ),
          )
          .toList();
    }

    if (city != null && city.isNotEmpty) {
      filtered = filtered
          .where(
            (doctor) => doctor.city.toLowerCase().contains(city.toLowerCase()),
          )
          .toList();
    }

    return filtered;
  }

  // Get doctor by ID
  DoctorModel? getDoctorById(String id) {
    final doctors = _getSampleDoctors();
    try {
      return doctors.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all available specialties
  List<String> getAllSpecialties() {
    return [
      'General Practice',
      'Cardiology',
      'Dermatology',
      'Pediatrics',
      'Neurology',
      'Orthopedics',
      'Gastroenterology',
      'Gynecology',
      'Ophthalmology',
      'Psychiatry',
      'Endocrinology',
      'Pulmonology',
      'Urology',
      'ENT (Otolaryngology)',
      'Rheumatology',
    ];
  }

  // Get all cities with doctors
  List<String> getAllCities() {
    return [
      'Tunis',
      'Sfax',
      'Sousse',
      'Kairouan',
      'Bizerte',
      'Gabès',
      'Ariana',
      'Gafsa',
      'Monastir',
      'Ben Arous',
    ];
  }
}
