import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todoai_flutter/models/date_model.dart' as date_util;
import 'package:todoai_flutter/models/hives/task.dart';
import 'package:todoai_flutter/modules/circle_progress/circular_percent_indicator.dart';

class CircleProgress extends StatefulWidget {
  final List<Task> tasks;
  const CircleProgress({super.key, required this.tasks});

  @override
  State<CircleProgress> createState() => _CircleProgressState();
}

persenDay(List<Task> list, String date) {
  double countComplete = 0;
  double countTask = 0;
  double none = 1;

  for (int i = 0; i < list.length; i++) {
    if (list[i].date == date) {
      countTask++;
    }
  }
  if (countTask == 0) {
    return none;
  }
  for (int i = 0; i < list.length; i++) {
    if (list[i].isComplete == true && list[i].date == date) {
      countComplete++;
    }
  }
  return countComplete / countTask;
}

persenWeek(List<Task> list, List<DateTime> currentWeek) {
  double countComplete = 0;
  double countTask = 0;
  double none = 1;

  for (int i = 0; i < currentWeek.length; i++) {
    String dateFormat = DateFormat('dd/MM/yyyy').format(currentWeek[i]);

    for (int j = 0; j < list.length; j++) {
      if (list[j].date == dateFormat) {
        countTask++;
      }
    }
  }
  if (countTask == 0) {
    return none;
  }
  for (int i = 0; i < currentWeek.length; i++) {
    String dateFormat = DateFormat('dd/MM/yyyy').format(currentWeek[i]);

    for (int j = 0; j < list.length; j++) {
      if (list[j].date == dateFormat && list[j].isComplete == true) {
        countComplete++;
      }
    }
  }
  return countComplete / countTask;
}

persenMonth(List<Task> list, List<DateTime> currentMonth) {
  double countComplete = 0;
  double countTask = 0;
  double none = 1;

  for (int i = 0; i < currentMonth.length; i++) {
    String date =
        '${currentMonth[i].day}/${DateTime.now().month}/${DateTime.now().year}';
    String dateFormat = DateFormat('dd/MM/yyyy')
        .format(DateFormat('dd/MM/yyyy').parse(date))
        .toString();
    for (int j = 0; j < list.length; j++) {
      if (list[j].date == dateFormat) {
        countTask++;
      }
    }
  }
  if (countTask == 0) {
    return none;
  }
  for (int i = 0; i < currentMonth.length; i++) {
    String date =
        '${currentMonth[i].day}/${DateTime.now().month}/${DateTime.now().year}';
    String dateFormat = DateFormat('dd/MM/yyyy')
        .format(DateFormat('dd/MM/yyyy').parse(date))
        .toString();
    for (int j = 0; j < list.length; j++) {
      if (list[j].date == dateFormat && list[j].isComplete == true) {
        countComplete++;
      }
    }
  }
  return countComplete / countTask;
}

class _CircleProgressState extends State<CircleProgress> {
  DateTime currentDateTime = DateTime.now();
  List<DateTime> currentMonthList = List.empty();
  void initState() {
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();

    super.initState();
  }

  List<DateTime> currentWeekDays() {
    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;
    List<DateTime> days = [];

    for (int i = 1; i <= 7; i++) {
      DateTime day = now.add(Duration(days: i - currentDayOfWeek));
      days.add(day);
    }

    return days;
  }

  final String dateNowFormat = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.transparent,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          const Text('Đã hoàn thành'),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircularPercentIndicator(
                radius: 28,
                percent: persenDay(widget.tasks, dateNowFormat),
                progressColor: Color.fromARGB(255, 125, 171, 88),
                backgroundColor: Colors.lightGreen.shade100,
                circularStrokeCap: CircularStrokeCap.round,
                center: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${(persenDay(widget.tasks, dateNowFormat) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 125, 171, 88),
                      ),
                    ),
                    const Text(
                      'Ngày',
                      style: TextStyle(
                          fontSize: 8,
                          color: Color.fromARGB(255, 125, 171, 88)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CircularPercentIndicator(
                radius: 28,
                percent: persenWeek(widget.tasks, currentWeekDays()),
                progressColor: Colors.deepPurple,
                backgroundColor: Colors.deepPurple.shade100,
                circularStrokeCap: CircularStrokeCap.round,
                center: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${(persenWeek(widget.tasks, currentWeekDays()) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const Text(
                      'Tuần',
                      style: TextStyle(fontSize: 8, color: Colors.deepPurple),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CircularPercentIndicator(
                radius: 28,
                percent: persenMonth(widget.tasks, currentMonthList),
                progressColor: Colors.red,
                backgroundColor: Colors.red.shade100,
                circularStrokeCap: CircularStrokeCap.round,
                center: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${(persenMonth(widget.tasks, currentMonthList) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      'Tháng',
                      style: TextStyle(fontSize: 8, color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
