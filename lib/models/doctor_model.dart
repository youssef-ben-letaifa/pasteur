class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String? subSpecialty;
  final String address;
  final String city;
  final String? phone;
  final String? email;
  final String? website;
  final double? latitude;
  final double? longitude;
  final String? description;
  final List<String>? languages;
  final String? workingHours;
  final double? rating;
  final int? yearsOfExperience;
  final String? education;
  final bool? acceptsInsurance;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.subSpecialty,
    required this.address,
    required this.city,
    this.phone,
    this.email,
    this.website,
    this.latitude,
    this.longitude,
    this.description,
    this.languages,
    this.workingHours,
    this.rating,
    this.yearsOfExperience,
    this.education,
    this.acceptsInsurance,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'subSpecialty': subSpecialty,
      'address': address,
      'city': city,
      'phone': phone,
      'email': email,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'languages': languages,
      'workingHours': workingHours,
      'rating': rating,
      'yearsOfExperience': yearsOfExperience,
      'education': education,
      'acceptsInsurance': acceptsInsurance,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      subSpecialty: json['subSpecialty'],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      description: json['description'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      workingHours: json['workingHours'],
      rating: json['rating']?.toDouble(),
      yearsOfExperience: json['yearsOfExperience']?.toInt(),
      education: json['education'],
      acceptsInsurance: json['acceptsInsurance'],
    );
  }

  // Get full address string
  String get fullAddress => '$address, $city';

  // Get display name with specialty
  String get displayName => '$name - $specialty';
}
