// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcationmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionmodelAdapter extends TypeAdapter<Transactionmodel> {
  @override
  final int typeId = 3;

  @override
  Transactionmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transactionmodel(
      purpose: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as DateTime,
      type: fields[3] as Categorytype,
      category: fields[4] as Categorymodel,
    )..id = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Transactionmodel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.purpose)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
