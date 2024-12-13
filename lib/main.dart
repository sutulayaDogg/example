import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/alarm/screens/alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting('ru_RU');
  await Alarm.init();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlarmScreen(),
    ),
  );
}
