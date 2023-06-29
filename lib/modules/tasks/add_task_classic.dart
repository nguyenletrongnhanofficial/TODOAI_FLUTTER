import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoai_flutter/config/config.dart';
import 'package:todoai_flutter/models/hives/task.dart';

import 'package:todoai_flutter/providers/task_provider.dart';

import '../../providers/pages/message_page_provider.dart';

class AddTaskClassic extends StatefulWidget {
  const AddTaskClassic({super.key});

  @override
  State<AddTaskClassic> createState() => _AddTaskClassicState();
}

int selectColor = 0;

class _AddTaskClassicState extends State<AddTaskClassic> {
  int selectColor = 0;

  DateTime currentDateTime = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();
  TextEditingController describeEditingController = TextEditingController();

  @override
  void initState() {
    dateEditingController.text =
        DateFormat('dd/MM/yyyy').format(currentDateTime);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> postTaskLocal(TaskProvider taskProvider) async {
    try {
      String date = DateFormat('dd/MM/yyyy')
          .format(DateFormat('dd/MM/yyyy').parse(dateEditingController.text));
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(date);
      
      taskProvider
          .addTaskLocal(Task(
              date: date,
              title: titleEditingController.text,
              isComplete: false,
              describe: describeEditingController.text.isEmpty
                  ? "Không có mô tả"
                  : describeEditingController.text,
              time: timeEditingController.text.isEmpty
                  ? ""
                  : timeEditingController.text,
              color: selectColor,
              isAdd: true,
              isUpdate: false,
              isDelete: false))
          .whenComplete(() {
        taskProvider.getAllTaskLocal();
        if (timeEditingController.text.isNotEmpty) {
          List<String> timeComponents = timeEditingController.text.split(':');
          int hour = int.parse(timeComponents[0]);
          int minute = int.parse(timeComponents[1]);
          taskProvider.registerTask(
              titleEditingController.text, dateTime.month, dateTime.day, hour, minute);
        }
        taskProvider.homeWidget();
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> postTaskServer(TaskProvider taskProvider, int lenght) async {
    String date = DateFormat('dd/MM/yyyy')
        .format(DateFormat('dd/MM/yyyy').parse(dateEditingController.text));
    String userId = Provider.of<MessagePageProvider>(context, listen: false)
              .current_user_id;
    await taskProvider.checkInterner();
    var isConnected = taskProvider.isConnected;
    if (isConnected == true) {
      var response = await Dio().post("$baseUrl/task/addTask", data: {
        "title": titleEditingController.text,
        "date": date,
        "user": userId,
        "color": selectColor,
        "describe": describeEditingController.text.isEmpty
            ? "Không có mô tả"
            : describeEditingController.text,
        "time": timeEditingController.text.isEmpty
            ? ""
            : timeEditingController.text,
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data as Map<String, dynamic>;
        var taskId = data["message"];

        taskProvider
            .updateTaskLocal(
                Task(
                    id: taskId,
                    date: date,
                    title: titleEditingController.text,
                    isComplete: false,
                    describe: describeEditingController.text.isEmpty
                        ? "Không có mô tả"
                        : describeEditingController.text,
                    time: timeEditingController.text.isEmpty
                        ? ""
                        : timeEditingController.text,
                    color: selectColor,
                    isAdd: false,
                    isUpdate: false,
                    isDelete: false),
                lenght)
            .whenComplete(() => taskProvider.getAllTaskLocal());
      }
    } else {
      print('false');
    }
  }

  void _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      locale: const Locale('vi', 'VN'),
    );
    if (selectedDate != null && selectedDate != currentDateTime) {
      setState(() {
        currentDateTime = selectedDate;
      });
      dateEditingController.text =
          DateFormat('dd/MM/yyyy').format(currentDateTime);
    }
  }

  void _showTimePicker() async {
    final selectedTime =
        await showTimePicker(context: context, initialTime: currentTime);
    if (selectedTime != null && selectedTime != currentTime) {
      setState(() {
        currentTime = selectedTime;
      });
      timeEditingController.text = '${currentTime.hour}:${currentTime.minute}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 500,
        width: size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D0140),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text(
                        'Thêm công việc',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'TodoAi-Medium'),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'Công việc',
                        style: TextStyle(
                            fontSize: 16, fontFamily: "TodoAi-Medium"),
                      ),
                    ),
                    TextFormField(
                      controller: titleEditingController,
                      style: const TextStyle(
                          fontSize: 16, fontFamily: "TodoAi-Book"),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintText: "Thêm công việc...",
                        hintStyle:
                            TextStyle(fontSize: 16, fontFamily: "TodoAi-Book"),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      maxLines: null,
                      cursorColor: Colors.black,
                      cursorHeight: 20,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: Text(
                                  'Thời gian',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "TodoAi-Medium"),
                                ),
                              ),
                              TextFormField(
                                controller: timeEditingController,
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: "TodoAi-Book"),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    hintText: "hh:mm",
                                    hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "TodoAi-Book"),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    prefixIcon: IconButton(
                                        onPressed: _showTimePicker,
                                        icon: const Icon(Icons.access_time))),
                                maxLines: null,
                                cursorColor: Colors.black,
                                cursorHeight: 20,
                              ),
                            ],
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox.shrink()),
                        Flexible(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: Text(
                                  'Ngày',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "TodoAi-Medium"),
                                ),
                              ),
                              TextFormField(
                                controller: dateEditingController,
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: "TodoAi-Book"),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    prefixIcon: IconButton(
                                        onPressed: _showDatePicker,
                                        icon: const Icon(
                                            Icons.calendar_month_rounded))),
                                maxLines: null,
                                cursorColor: Colors.black,
                                cursorHeight: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'Màu sắc',
                        style: TextStyle(
                            fontSize: 16, fontFamily: "TodoAi-Medium"),
                      ),
                    ),
                    Stack(children: [
                      Container(
                        height: 40,
                        width: 230,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 228, 228, 228),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 3,
                        child: Wrap(
                          children: List<Widget>.generate(7, (int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectColor = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: index == 0
                                      ? Colors.red
                                      : index == 1
                                          ? Colors.yellow
                                          : index == 2
                                              ? Colors.green
                                              : index == 3
                                                  ? Colors.blue
                                                  : index == 4
                                                      ? Colors.pinkAccent
                                                      : index == 5
                                                          ? Colors.deepPurple
                                                          : Colors.black,
                                  child: selectColor == index
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 12,
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ]),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'Mô tả',
                        style: TextStyle(
                            fontSize: 16, fontFamily: "TodoAi-Medium"),
                      ),
                    ),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                            color: const Color(0xFFDEE3F2),
                            width: 1,
                          )),
                      child: TextFormField(
                        controller: describeEditingController,
                        style: const TextStyle(
                            fontSize: 16, fontFamily: "TodoAi-Book"),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          hintText: "Thêm mô tả...",
                          hintStyle: TextStyle(
                              fontSize: 16, fontFamily: "TodoAi-Book"),
                        ),
                        maxLines: null,
                        cursorColor: Colors.black,
                        cursorHeight: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<TaskProvider>(
                      builder: (context, taskData, child) => ElevatedButton(
                          onPressed: () async {
                            await postTaskLocal(taskProvider);
                            postTaskServer(taskProvider, taskData.tasks.length);
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(200, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text('Tạo công việc')
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
