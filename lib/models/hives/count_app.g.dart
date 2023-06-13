// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_app.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountAppAdapter extends TypeAdapter<CountApp> {
  @override
  final int typeId = 1;

  @override
  CountApp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountApp(
      countShowcase: fields[0] as int?,
      countOnboarding: fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CountApp obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.countShowcase)
      ..writeByte(1)
      ..write(obj.countOnboarding);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountAppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
