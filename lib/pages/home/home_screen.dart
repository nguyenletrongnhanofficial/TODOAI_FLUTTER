import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoai_flutter/models/hives/task.dart';
import 'package:todoai_flutter/modules/tasks/add_task.dart';

import 'package:todoai_flutter/pages/home/components/list_item_widget.dart';
import 'package:todoai_flutter/providers/task_provider.dart';


import 'components/calendar.dart';
import '../../modules/circle_progress/circle_progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConnectivityResult result;
  late StreamSubscription subscription;

  var isConnected = false;

  checkInternet() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      await syncTaskServer();
    }
    taskProvider
        .getTaskServer()
        .whenComplete(() => taskProvider.getAllTaskLocal());
    setState(() {});
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      await checkInternet();
    });
  }

  Future<void> syncTaskServer() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      for (int i = 0; i < taskProvider.tasks.length; i++) {
        if (taskProvider.tasks[i].isDelete == true) {
          taskProvider.deleteTaskServer(taskProvider.tasks[i], i);
        } else if (taskProvider.tasks[i].isAdd == true) {
          taskProvider.addTaskServer(
              taskProvider.tasks[i].title,
              taskProvider.tasks[i].date,
              taskProvider.tasks[i].describe,
              taskProvider.tasks[i].time,
              taskProvider.tasks[i].color,
              "6433cf38a042d150f0966572",
              i);
        } else if (taskProvider.tasks[i].isUpdate == true) {
          taskProvider.updateTaskServer(taskProvider.tasks[i], i);
        }
      }
    });
  }

  DateTime _selectedDateTime = DateTime.now();
  void _handleDateTimeChanged(DateTime newDateTime) {
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  countTaskDontComplete(List<Task> list, String date) {
    int countTask = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].isComplete == false && list[i].date == date) {
        countTask++;
      }
    }
    return countTask;
  }

  @override
  void initState() {
    super.initState();
    // Gọi requestFocus() khi widget được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).getAllTaskLocal();
      startStreaming();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final String dateFormat =
        DateFormat('dd/MM/yyyy').format(_selectedDateTime);

    final String dateNowFormat =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<TaskProvider>(
          builder: (context, taskData, child) => Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20, left: 70),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Xin chào 👋',
                            style: TextStyle(
                                fontFamily: 'TodoAi-Book', fontSize: 15),
                          ),
                          Text(
                            'HOMIE',
                            style: TextStyle(
                                fontFamily: 'TodoAi-Bold', fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 65,
                      width: 60,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const Positioned(
                            right: 0,
                            height: 45,
                            bottom: 8,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/icons/avatar.png'),
                            ),
                          ),
                          Positioned(
                              bottom: 7,
                              left: 0,
                              child: Container(
                                height: 18,
                                width: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    color: Colors.green),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Image.asset('assets/icons/iconVector.png'),
                                    const SizedBox(width: 2),
                                    const Text(
                                      '9',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'TodoAi-Bold',
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
              CalendarMonth(onDateTimeChanged: _handleDateTimeChanged),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 25,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset('assets/icons/loudspeaker_icon.png'),
                    Text(
                        'Bạn có ${countTaskDontComplete(taskData.tasks, dateNowFormat)} công việc cần làm trong hôm nay')
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: 330,
                  child: ListView.builder(
                    itemCount: taskData.tasks.length,
                    itemBuilder: (context, index) {
                      Task task = taskData.tasks[index];
                      if (task.isComplete == false &&
                          task.date == dateFormat &&
                          task.isDelete == false) {
                        return ListItemWidget(
                            index: index,
                            task: task,
                            onClicked: () async {
                              await taskProvider
                                  .updateTaskLocal(
                                      Task(
                                          id: task.id,
                                          date: task.date,
                                          title: task.title,
                                          isComplete: true,
                                          describe: task.describe,
                                          time: task.time,
                                          color: task.color,
                                          isAdd: task.isAdd,
                                          isUpdate: true,
                                          isDelete: task.isDelete),
                                      index)
                                  .whenComplete(
                                      () => taskProvider.getAllTaskLocal());
                              taskProvider.updateTaskServer(
                                  Task(
                                      id: task.id,
                                      date: task.date,
                                      title: task.title,
                                      isComplete: true,
                                      describe: task.describe,
                                      time: task.time,
                                      color: task.color,
                                      isAdd: task.isAdd,
                                      isUpdate: true,
                                      isDelete: task.isDelete),
                                  index);
                                  setState(() {
                                    
                                  });
                            });
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
              CircleProgress(tasks: taskData.tasks),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: taskData.tasks.length,
                  itemBuilder: (context, index) {
                    Task task = taskData.tasks[index];
                    if (task.isComplete == true && task.date == dateFormat) {
                      return ListItemWidget(
                          index: index,
                          task: task,
                          onClicked: () async {
                            await taskProvider
                                .updateTaskLocal(
                                    Task(
                                        id: task.id,
                                        date: task.date,
                                        title: task.title,
                                        isComplete: false,
                                        describe: task.describe,
                                        time: task.time,
                                        color: task.color,
                                        isAdd: task.isAdd,
                                        isUpdate: true,
                                        isDelete: task.isDelete),
                                    index)
                                .whenComplete(
                                    () => taskProvider.getAllTaskLocal());
                            taskProvider.updateTaskServer(
                                Task(
                                    id: task.id,
                                    date: task.date,
                                    title: task.title,
                                    isComplete: false,
                                    describe: task.describe,
                                    time: task.time,
                                    color: task.color,
                                    isAdd: task.isAdd,
                                    isUpdate: true,
                                    isDelete: task.isDelete),
                                index);
                                setState(() {
                                  
                                });
                          });
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return const AddTask();
              });
        },
        child: Image.asset('assets/icons/Add_icon.png'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
