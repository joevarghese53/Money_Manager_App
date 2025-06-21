import 'package:hive_flutter/adapters.dart';
part 'categorymodel.g.dart';

@HiveType(typeId: 2)
enum Categorytype {
  @HiveField(0)
  income,

  @HiveField(1)
  expense
}

@HiveType(typeId: 1)
class Categorymodel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final Categorytype type;

  @HiveField(3)
  final bool isdeleted;

  Categorymodel(
      {required this.id,
      required this.name,
      required this.type,
      this.isdeleted = false});

  @override
  String toString() {
    return '$name $type';
  }
}
