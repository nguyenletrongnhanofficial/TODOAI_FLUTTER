import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 2)
class Task {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String describe;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final int color;

  @HiveField(6)
  bool isComplete = false;

  @HiveField(7)
  bool isAdd = false;

  @HiveField(8)
  bool isUpdate = false;

  @HiveField(9)
  bool isDelete = false;

  Task(
      {this.id,
      required this.date,
      required this.title,
      required this.isComplete,
      required this.describe,
      required this.time,
      required this.color,
      required this.isAdd,
      required this.isUpdate,
      required this.isDelete});

  static toTask(Map<String, dynamic> data) {
    return Task(
        id: data["_id"] ?? "",
        date: data["date"] ?? "",
        title: data["title"] ?? "",
        isComplete: data["isComplete"] ?? "",
        describe: data["describe"] ?? "",
        time: data["time"] ?? "",
        color: data["color"] != null ? int.parse(data["color"]) : 0,
        isAdd: false,
        isDelete: false,
        isUpdate: false);
  }
}
