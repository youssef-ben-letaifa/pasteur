import 'package:hive/hive.dart';

part 'health_record.g.dart';

@HiveType(typeId: 1)
class HealthRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  DateTime recordDate;

  @HiveField(3)
  HealthRecordType type;

  @HiveField(4)
  Map<String, dynamic> data;

  @HiveField(5)
  String? notes;

  HealthRecord({
    required this.id,
    required this.userId,
    required this.recordDate,
    required this.type,
    required this.data,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'recordDate': recordDate.toIso8601String(),
      'type': type.toString(),
      'data': data,
      'notes': notes,
    };
  }
}

@HiveType(typeId: 2)
enum HealthRecordType {
  @HiveField(0)
  vitalSigns, // heart rate, BP, temperature, oxygen saturation

  @HiveField(1)
  glucose, // blood glucose levels

  @HiveField(2)
  medication, // medication tracking

  @HiveField(3)
  symptom, // symptom logging

  @HiveField(4)
  diet, // food and nutrition

  @HiveField(5)
  activity, // physical activity/exercise

  @HiveField(6)
  sleep, // sleep tracking

  @HiveField(7)
  other, // other health data
}

// Specific models for different health records

class VitalSigns {
  final double? heartRate; // bpm
  final double? systolicBP; // mmHg
  final double? diastolicBP; // mmHg
  final double? temperature; // Celsius
  final double? oxygenSaturation; // percentage
  final double? respiratoryRate; // breaths per minute

  VitalSigns({
    this.heartRate,
    this.systolicBP,
    this.diastolicBP,
    this.temperature,
    this.oxygenSaturation,
    this.respiratoryRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'heartRate': heartRate,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'temperature': temperature,
      'oxygenSaturation': oxygenSaturation,
      'respiratoryRate': respiratoryRate,
    };
  }

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      heartRate: json['heartRate']?.toDouble(),
      systolicBP: json['systolicBP']?.toDouble(),
      diastolicBP: json['diastolicBP']?.toDouble(),
      temperature: json['temperature']?.toDouble(),
      oxygenSaturation: json['oxygenSaturation']?.toDouble(),
      respiratoryRate: json['respiratoryRate']?.toDouble(),
    );
  }
}

class MedicationRecord {
  final String medicationName;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final bool taken;
  final DateTime? takenAt;
  final String? prescribedBy;

  MedicationRecord({
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.taken = false,
    this.takenAt,
    this.prescribedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'taken': taken,
      'takenAt': takenAt?.toIso8601String(),
      'prescribedBy': prescribedBy,
    };
  }

  factory MedicationRecord.fromJson(Map<String, dynamic> json) {
    return MedicationRecord(
      medicationName: json['medicationName'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      taken: json['taken'] ?? false,
      takenAt: json['takenAt'] != null ? DateTime.parse(json['takenAt']) : null,
      prescribedBy: json['prescribedBy'],
    );
  }
}

class SymptomLog {
  final String symptom;
  final String severity; // mild, moderate, severe
  final String? description;
  final List<String>? triggers;
  final String? location; // body location if applicable

  SymptomLog({
    required this.symptom,
    required this.severity,
    this.description,
    this.triggers,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'symptom': symptom,
      'severity': severity,
      'description': description,
      'triggers': triggers,
      'location': location,
    };
  }

  factory SymptomLog.fromJson(Map<String, dynamic> json) {
    return SymptomLog(
      symptom: json['symptom'],
      severity: json['severity'],
      description: json['description'],
      triggers: json['triggers'] != null
          ? List<String>.from(json['triggers'])
          : null,
      location: json['location'],
    );
  }
}
