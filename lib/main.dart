import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:todoai_flutter/models/task.dart';
import 'package:todoai_flutter/pages/home/home_screen.dart';
import 'package:todoai_flutter/providers/task_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>('taskBox');

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: TaskProvider())],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
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
  
      home: const HomePage(),
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

