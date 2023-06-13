import 'package:hive/hive.dart';

part 'count_app.g.dart';

@HiveType(typeId: 1)
class CountApp extends HiveObject {
  @HiveField(0)
  int? countShowcase;
  @HiveField(1)
  bool? countOnboarding;

  CountApp({this.countShowcase, this.countOnboarding});
}
