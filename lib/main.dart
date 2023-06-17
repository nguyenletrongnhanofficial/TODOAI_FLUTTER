import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:todoai_flutter/pages/login_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todoai_flutter/providers/card_profile_provider.dart';

//Region Provider
import '/providers/pages/message_page_provider.dart';
import 'package:todoai_flutter/providers/task_provider.dart';

//Region Hive
import 'models/hives/count_app.dart';
import 'models/hives/task.dart';
import 'models/hives/userid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserIdAdapter());
  await Hive.openBox<UserId>('userBox');
  Hive.registerAdapter(CountAppAdapter());
  await Hive.openBox<CountApp>('countBox');
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('taskBox');
  //====

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: TaskProvider()),
      ChangeNotifierProvider.value(value: MessagePageProvider()),
      ChangeNotifierProvider.value(value: CardProfileProvider())
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "TodoAi-Bold",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
