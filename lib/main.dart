import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoai_flutter/pages/home_page.dart';

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

//call-kit
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:workmanager/workmanager.dart';
import 'package:just_audio_background/just_audio_background.dart';

//workmanager
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    String title = inputData!["title"];

    CallKitParams params = CallKitParams(
      id: "21232dgfgbcbgb",
      nameCaller: "TODOAI",
      appName: "Demo",
      avatar:
          "https://i.pinimg.com/736x/1a/92/7a/1a927a94faf685e1326c981f06677f7b.jpg",
      handle: title,
      type: 0,
      textAccept: "Accept",
      textDecline: "Decline",
      textMissedCall: "Missed call",
      textCallback: "Call back",
      duration: 30000,
      extra: {'userId': "sdhsjjfhuwhf"},
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          isShowCallback: false,
          isShowMissedCallNotification: true,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: "#0955fa",
          backgroundUrl: "assets/backgrounds/bgCall.gif",
          actionColor: "#4CAF50",
          incomingCallNotificationChannelName: "Incoming call",
          missedCallNotificationChannelName: "Missed call"),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);

    return Future.value(true);
  });
}

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

  //Call-kit
  Workmanager().initialize(callbackDispatcher);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
