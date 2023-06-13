import 'package:hive/hive.dart';

part 'userid.g.dart';

@HiveType(typeId: 0)
class UserId extends HiveObject {
  @HiveField(0)
  String? userid;

  @HiveField(1)
  String? name;

  UserId({this.userid, this.name});
}
