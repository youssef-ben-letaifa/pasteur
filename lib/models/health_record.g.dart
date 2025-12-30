// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthRecordAdapter extends TypeAdapter<HealthRecord> {
  @override
  final int typeId = 1;

  @override
  HealthRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecord(
      id: fields[0] as String,
      userId: fields[1] as String,
      recordDate: fields[2] as DateTime,
      type: fields[3] as HealthRecordType,
      data: (fields[4] as Map).cast<String, dynamic>(),
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.recordDate)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthRecordTypeAdapter extends TypeAdapter<HealthRecordType> {
  @override
  final int typeId = 2;

  @override
  HealthRecordType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthRecordType.vitalSigns;
      case 1:
        return HealthRecordType.glucose;
      case 2:
        return HealthRecordType.medication;
      case 3:
        return HealthRecordType.symptom;
      case 4:
        return HealthRecordType.diet;
      case 5:
        return HealthRecordType.activity;
      case 6:
        return HealthRecordType.sleep;
      case 7:
        return HealthRecordType.other;
      default:
        return HealthRecordType.vitalSigns;
    }
  }

  @override
  void write(BinaryWriter writer, HealthRecordType obj) {
    switch (obj) {
      case HealthRecordType.vitalSigns:
        writer.writeByte(0);
        break;
      case HealthRecordType.glucose:
        writer.writeByte(1);
        break;
      case HealthRecordType.medication:
        writer.writeByte(2);
        break;
      case HealthRecordType.symptom:
        writer.writeByte(3);
        break;
      case HealthRecordType.diet:
        writer.writeByte(4);
        break;
      case HealthRecordType.activity:
        writer.writeByte(5);
        break;
      case HealthRecordType.sleep:
        writer.writeByte(6);
        break;
      case HealthRecordType.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
