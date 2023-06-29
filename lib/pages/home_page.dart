import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoai_flutter/models/hives/task.dart';

import '../widgets/custom_standby_widget/page.dart';
import '/components/list_item_widget.dart';
import 'package:todoai_flutter/providers/task_provider.dart';
import 'package:todoai_flutter/widgets/add_popup/add_button.dart';
import '/widgets/navigation_drawer_profile.dart';
import '../providers/card_profile_provider.dart';
import '../providers/pages/message_page_provider.dart';
import '/components/calendar.dart';
import '../modules/circle_progress/circle_progress.dart';

import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class HomePage extends StatefulWidget {
  final bool isMe;
  const HomePage({super.key, required this.isMe});

  @override
  State<HomePage> createState() => _HomePageState();
}

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  factory CurrentUser() => _instance;
  CurrentUser._internal();

  late String current_user_id;
}

class _HomePageState extends State<HomePage> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  late String current_user_id;
  final CurrentUser _currentUser = CurrentUser();

  var isConnected = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  checkInternet(String userId) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      await syncTaskServer();
    }
    taskProvider
        .getTaskServer(userId)
        .whenComplete(() => taskProvider.getAllTaskLocal());
    setState(() {});
  }

  startStreaming(String userId) {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      await checkInternet(userId);
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
              _currentUser.current_user_id,
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

  Future<void> listenerEvent(void Function(CallEvent) callback) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        switch (event!.event) {
          case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
            break;
          case Event.ACTION_CALL_INCOMING:
            break;
          case Event.ACTION_CALL_START:
            break;
          case Event.ACTION_CALL_ACCEPT:
            final _player = AudioPlayer();
            _player.setAudioSource(AudioSource.asset('assets/audios/wakeup.mp3',
                tag: const MediaItem(id: 'id', title: 'title')));
            _player.play();
            break;
          case Event.ACTION_CALL_DECLINE:
            break;
          case Event.ACTION_CALL_ENDED:
            break;
          case Event.ACTION_CALL_TIMEOUT:
            break;
          case Event.ACTION_CALL_CALLBACK:
            break;
          case Event.ACTION_CALL_TOGGLE_HOLD:
            break;
          case Event.ACTION_CALL_TOGGLE_MUTE:
            break;
          case Event.ACTION_CALL_TOGGLE_DMTF:
            break;
          case Event.ACTION_CALL_TOGGLE_GROUP:
            break;
          case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
            break;
        }
        callback(event);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void onEvent(CallEvent event) {
    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    // Gọi requestFocus() khi widget được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _currentUser.current_user_id =
          Provider.of<MessagePageProvider>(context, listen: false)
              .current_user_id;
      Provider.of<CardProfileProvider>(context, listen: false)
          .fetchCurrentUser(_currentUser.current_user_id);
      Provider.of<TaskProvider>(context, listen: false).getAllTaskLocal();
      startStreaming(_currentUser.current_user_id);
      
      //Homewidget
      Provider.of<TaskProvider>(context, listen: false).homeWidget();
    });
    listenerEvent(onEvent);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final userCurrent = Provider.of<CardProfileProvider>(context).user;
    print(userCurrent?.name);
    final String dateFormat =
        DateFormat('dd/MM/yyyy').format(_selectedDateTime);

    final String dateNowFormat =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        return const PageClock();
      } else {
        return Scaffold(
          key: _key,
          drawer: NavigationDrawerProfile(isMe: widget.isMe, user: userCurrent),
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
                            children: [
                              const Text(
                                'Xin chào 👋',
                                style: TextStyle(
                                    fontFamily: 'TodoAi-Book', fontSize: 15),
                              ),
                              Text(
                                '${userCurrent?.name}',
                                style: const TextStyle(
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
                              Builder(builder: (context) {
                                return GestureDetector(
                                  onTap: () => _key.currentState!.openDrawer(),
                                  child: const Positioned(
                                    right: 0,
                                    height: 45,
                                    bottom: 8,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage('assets/icons/avatar.png'),
                                    ),
                                  ),
                                );
                              }),
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
                                        Image.asset(
                                            'assets/icons/iconVector.png'),
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
                  SizedBox(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
                                setState(() {});
                              });
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  CircleProgress(tasks: taskData.tasks),
                  SizedBox(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: taskData.tasks.length,
                      itemBuilder: (context, index) {
                        Task task = taskData.tasks[index];
                        if (task.isComplete == true &&
                            task.date == dateFormat) {
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
                                setState(() {});
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
          floatingActionButton: DraggableFAB(),
        );
      }
    });
  }
}

class DraggableFAB extends StatefulWidget {
  @override
  _DraggableFABState createState() => _DraggableFABState();
}

class _DraggableFABState extends State<DraggableFAB> {
  double xPosition = 30;
  double yPosition = 30;
  late double screenHeight;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  Future<void> _savePosition(double x, double y) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('xPosition', x);
    await prefs.setDouble('yPosition', y);
  }

  Future<void> _loadPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      xPosition = prefs.getDouble('xPosition') ?? screenWidth - 65;
      yPosition = prefs.getDouble('yPosition') ?? screenHeight - 143;
      //Chỉnh kích thước ban đầu
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        AnimatedPositioned(
          left: xPosition,
          top: yPosition,
          duration: const Duration(milliseconds: 150), // Thời gian chuyển động
          child: GestureDetector(
            child: const AddButton(),
            onPanUpdate: (tapInfo) {
              setState(() {
                xPosition += tapInfo.delta.dx;
                yPosition += tapInfo.delta.dy;
              });
            },
            onPanEnd: (tapInfo) {
              double newXPosition =
                  xPosition < screenWidth / 2 ? 15 : screenWidth - 65;
              //Nếu xPosition (vị trí hiện tại của widget) nhỏ hơn giữa màn hình
              //tức là widget nằm bên trái giữa màn hình, thì newXPosition được đặt là 15.
              //Ngược lại, thì newXPosition được đặt là screenWidth - 66.
              //##Ở đây, 56 là chiều rộng của FloatingActionButton
              double newYPosition = yPosition;

              if (yPosition < 0) {
                newYPosition = 0;
              } else if (yPosition > screenHeight - 112) {
                newYPosition = screenHeight - 152;
              }

              setState(() {
                xPosition = newXPosition;
                yPosition = newYPosition;
              });
              _savePosition(xPosition, yPosition);
            },
          ),
        ),
      ],
    );
  }
}
