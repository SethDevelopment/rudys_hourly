// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckItemAdapter extends TypeAdapter<CheckItem> {
  @override
  final int typeId = 1;

  @override
  CheckItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckItem(
      product: fields[0] as Product,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CheckItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CheckEntryAdapter extends TypeAdapter<CheckEntry> {
  @override
  final int typeId = 2;

  @override
  CheckEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckEntry(
      timestamp: fields[0] as DateTime,
      items: (fields[1] as List).cast<CheckItem>(),
      note: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CheckEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
