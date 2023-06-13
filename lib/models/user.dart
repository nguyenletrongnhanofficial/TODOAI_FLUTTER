import 'package:hive_flutter/hive_flutter.dart';
part 'user.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(0, defaultValue: "none")
  final String id;

  @HiveField(1, defaultValue: "Homie")
  final String name;

  User(this.id, this.name);
}
