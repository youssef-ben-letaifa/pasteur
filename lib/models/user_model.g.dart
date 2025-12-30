// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      username: fields[2] as String,
      passwordHash: fields[3] as String,
      profilePicturePath: fields[4] as String?,
      email: fields[5] as String?,
      is2FAEnabled: fields[6] as bool,
      twoFACode: fields[7] as String?,
      dateOfBirth: fields[8] as DateTime?,
      gender: fields[9] as String?,
      bloodType: fields[10] as String?,
      height: fields[11] as double?,
      weight: fields[12] as double?,
      allergies: (fields[13] as List?)?.cast<String>(),
      chronicConditions: (fields[14] as List?)?.cast<String>(),
      currentMedications: (fields[15] as List?)?.cast<String>(),
      emergencyContact: fields[16] as String?,
      emergencyContactPhone: fields[17] as String?,
      createdAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime,
      address: fields[20] as String?,
      city: fields[21] as String?,
      phoneNumber: fields[22] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.passwordHash)
      ..writeByte(4)
      ..write(obj.profilePicturePath)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.is2FAEnabled)
      ..writeByte(7)
      ..write(obj.twoFACode)
      ..writeByte(8)
      ..write(obj.dateOfBirth)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.bloodType)
      ..writeByte(11)
      ..write(obj.height)
      ..writeByte(12)
      ..write(obj.weight)
      ..writeByte(13)
      ..write(obj.allergies)
      ..writeByte(14)
      ..write(obj.chronicConditions)
      ..writeByte(15)
      ..write(obj.currentMedications)
      ..writeByte(16)
      ..write(obj.emergencyContact)
      ..writeByte(17)
      ..write(obj.emergencyContactPhone)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt)
      ..writeByte(20)
      ..write(obj.address)
      ..writeByte(21)
      ..write(obj.city)
      ..writeByte(22)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
