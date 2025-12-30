import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String username;

  @HiveField(3)
  String passwordHash;

  @HiveField(4)
  String? profilePicturePath;

  @HiveField(5)
  String? email;

  @HiveField(6)
  bool is2FAEnabled;

  @HiveField(7)
  String? twoFACode;

  @HiveField(8)
  DateTime? dateOfBirth;

  @HiveField(9)
  String? gender;

  @HiveField(10)
  String? bloodType;

  @HiveField(11)
  double? height; // in cm

  @HiveField(12)
  double? weight; // in kg

  @HiveField(13)
  List<String>? allergies;

  @HiveField(14)
  List<String>? chronicConditions;

  @HiveField(15)
  List<String>? currentMedications;

  @HiveField(16)
  String? emergencyContact;

  @HiveField(17)
  String? emergencyContactPhone;

  @HiveField(18)
  DateTime createdAt;

  @HiveField(19)
  DateTime updatedAt;

  @HiveField(20)
  String? address;

  @HiveField(21)
  String? city;

  @HiveField(22)
  String? phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.passwordHash,
    this.profilePicturePath,
    this.email,
    this.is2FAEnabled = false,
    this.twoFACode,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.height,
    this.weight,
    this.allergies,
    this.chronicConditions,
    this.currentMedications,
    this.emergencyContact,
    this.emergencyContactPhone,
    required this.createdAt,
    required this.updatedAt,
    this.address,
    this.city,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'profilePicturePath': profilePicturePath,
      'is2FAEnabled': is2FAEnabled,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'bloodType': bloodType,
      'height': height,
      'weight': weight,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'currentMedications': currentMedications,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
      'address': address,
      'city': city,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      passwordHash: json['passwordHash'] ?? '',
      email: json['email'],
      profilePicturePath: json['profilePicturePath'],
      is2FAEnabled: json['is2FAEnabled'] ?? false,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      bloodType: json['bloodType'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      chronicConditions: json['chronicConditions'] != null
          ? List<String>.from(json['chronicConditions'])
          : null,
      currentMedications: json['currentMedications'] != null
          ? List<String>.from(json['currentMedications'])
          : null,
      emergencyContact: json['emergencyContact'],
      emergencyContactPhone: json['emergencyContactPhone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      address: json['address'],
      city: json['city'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
