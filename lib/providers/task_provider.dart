import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoai_flutter/config/config.dart';
import 'package:todoai_flutter/models/task.dart';

class TaskProvider extends ChangeNotifier {
  static const String _boxName = "taskBox";

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  var isConnected = false;

  getAllTask() async {
    var box = await Hive.openBox<Task>(_boxName);

    _tasks = box.values.toList();

    notifyListeners();
  }

  Future<void> getTaskServer() async {
    await checkInterner();
    if (isConnected == true) {
      await Future.delayed(const Duration(seconds: 2));
      var box = await Hive.openBox<Task>(_boxName);
      await box.clear();

      var result =
          await Dio().get("$baseUrl/auth/getUser/6433cf38a042d150f0966572");
      Map<String, dynamic> data = result.data as Map<String, dynamic>;

      var taskServer = data["message"]["tasks"];

      for (int i = 0; i < taskServer.length; i++) {
        addTask(Task.toTask(taskServer[i] as Map<String, dynamic>));
      }
    }

    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    var box = await Hive.openBox<Task>(_boxName);
    await box.add(task);
    notifyListeners();
  }

  Future<void> deleteTask(int index) async {
    var box = await Hive.openBox<Task>(_boxName);
    box.deleteAt(index);

    notifyListeners();
  }

  Future<void> updateTask(Task task, int index) async {
    var box = await Hive.openBox<Task>(_boxName);
    box.putAt(index, task);
    notifyListeners();
  }

  Future<void> addTaskServer(String title, String date, String describe,
      String time, int color, String userId, int lenght) async {
    await checkInterner();
    if (isConnected == true) {
      var response = await Dio().post("$baseUrl/task/addTask", data: {
        "title": title,
        "date": date,
        "user": userId,
        "color": color.toString(),
        "describe": describe,
        "time": time,
      });
      if (response.statusCode == 200) {}
    } else {
      print('false');
    }
    notifyListeners();
  }

  Future<void> deleteTaskServer(Task task, int index) async {
    await checkInterner();
    if (isConnected == true) {
      if (task.id == null) {
        deleteTask(index);
      } else {
        var response =
            await Dio().delete("$baseUrl/task/deleteTask/${task.id}");
        if (response.statusCode == 200) {
          await deleteTask(index);
          getAllTask();
          print('delete succes local and server');
        }
      }
    }
    notifyListeners();
  }

  Future<void> updateTaskServer(Task task, int index) async {
    await checkInterner();
    if (isConnected == true) {
      try {
        var response =
            await Dio().put("$baseUrl/task/updateTask/${task.id}", data: {
          "title": task.title,
          "date": task.date,
          "color": task.color,
          "describe": task.describe,
          "time": task.time,
        });
        print(response.statusCode);
        if (response.statusCode == 200) {
          await updateTask(
              Task(
                  date: task.date,
                  title: task.title,
                  isComplete: task.isComplete,
                  describe: task.describe,
                  time: task.time,
                  color: task.color,
                  isAdd: task.isAdd,
                  isUpdate: false,
                  isDelete: task.isDelete),
              index);
          getAllTask();
          print('update succes local and server');
        }
      } catch (e) {
        deleteTask(index);
      }
    }
    notifyListeners();
  }

  checkInterner() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isConnected = false;
    }
    notifyListeners();
  }
}
