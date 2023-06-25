import 'package:flutter/material.dart';
import 'package:todoai_flutter/models/date_model.dart' as date_util;

class CalendarMonth extends StatefulWidget {
  final ValueChanged<DateTime> onDateTimeChanged;
  const CalendarMonth({Key? key, required this.onDateTimeChanged}) : super(key: key);
  @override
  State<CalendarMonth> createState() => _CalendarMonthState();
}

class _CalendarMonthState extends State<CalendarMonth> {
  DateTime currentDateTime = DateTime.now();
  late ScrollController scrollController = ScrollController();
  List<DateTime> currentMonthList = List.empty();
 
  @override
  void initState() {
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController = ScrollController(initialScrollOffset: scroll());
    super.initState();
   
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date_util.DateUtils.months[currentDateTime.month - 1] +
                ', ' +
                currentDateTime.year.toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
              onPressed: _showDatePicker,
              icon: Image.asset('assets/icons/chevron_icon.png'))
        ],
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
              widget.onDateTimeChanged(currentDateTime);
            });
          },
          child: Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
              color: (currentMonthList[index].day != currentDateTime.day)
                  ? Colors.white.withOpacity(0.8)
                  : Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'TodoAi-Medium',
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? Colors.grey
                                : Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? Colors.grey
                                : Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget hrizontalCapsuleListView() {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

scroll() {
    double valueScroll = 0;
    switch (currentDateTime.day) {
      case 5:
        valueScroll = 15.0 * currentDateTime.day;
        break;
      case 6:
        valueScroll = 30.0 * currentDateTime.day;
        break;
      case 7:
        valueScroll = 35.0 * currentDateTime.day;
        break;
      case 8:
        valueScroll = 40.0 * currentDateTime.day;
        break;
      case 9:
        valueScroll = 45.0 * currentDateTime.day;
        break;
      case 10:
        valueScroll = 45.0 * currentDateTime.day;
        break;
      case 11:
        valueScroll = 47.0 * currentDateTime.day;
        break;
      case 12:
        valueScroll = 48.0 * currentDateTime.day;
        break;
      case 13:
        valueScroll = 50.0 * currentDateTime.day;
        break;
      case 14:
        valueScroll = 51.0 * currentDateTime.day;
        break;
      case 15:
        valueScroll = 52.0 * currentDateTime.day;
        break;
      case 16:
        valueScroll = 53.0 * currentDateTime.day;
        break;
      case 17:
        valueScroll = 54.0 * currentDateTime.day;
        break;
      case 18:
        valueScroll = 55.0 * currentDateTime.day;
        break;
      case 19:
        valueScroll = 56.0 * currentDateTime.day;
        break;
      case 20:
        valueScroll = 56.0 * currentDateTime.day;
        break;
      case 21:
        valueScroll = 57.0 * currentDateTime.day;
        break;
      case 22:
        valueScroll = 57.0 * currentDateTime.day;
        break;
      case 23:
        valueScroll = 58.0 * currentDateTime.day;
        break;
      case 24:
        valueScroll = 58.0 * currentDateTime.day;
        break;
      case 25:
        valueScroll = 59.0 * currentDateTime.day;
        break;
      case 26:
        valueScroll = 59.0 * currentDateTime.day;
        break;
      case 27:
        valueScroll = 59.0 * currentDateTime.day;
        break;
      case 28:
        valueScroll = 60.0 * currentDateTime.day;
        break;
      case 29:
        valueScroll = 60.0 * currentDateTime.day;
        break;
      case 30:
        valueScroll = 60.0 * currentDateTime.day;
        break;
      case 31:
        valueScroll = 60.0 * currentDateTime.day;
        break;
    }
    return valueScroll;
  }
  
  void _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      locale: const Locale('vi', 'VN'),
    );

    if (selectedDate != null && selectedDate != currentDateTime) {
      setState(() {
        currentDateTime = selectedDate;
        currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
        currentMonthList.sort((a, b) => a.day.compareTo(b.day));
        currentMonthList = currentMonthList.toSet().toList();      
        scrollController.animateTo(
          scroll(),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        widget.onDateTimeChanged(currentDateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(),
            hrizontalCapsuleListView(),
            
          ]),
    );
  }
}
