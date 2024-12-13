import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/alarm_repository.dart';
import 'package:alarm_example/alarm/screens/edit_alarm.dart';
import 'package:alarm_example/alarm/screens/ring.dart';
import 'package:alarm_example/alarm/services/permission.dart';
import 'package:alarm_example/alarm/widgets/alarm_container.dart';
import 'package:alarm_example/alarm/widgets/tile.dart';
import 'package:alarm_example/feed/feed_screen.dart';
import 'package:flutter/material.dart';


class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {

  static StreamSubscription<AlarmSettings>? ringSubscription;
 //static StreamSubscription<int>? updateSubscription;

  @override
  void initState() {
    super.initState();
    AlarmPermissions.checkNotificationPermission();
    if (Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }
    unawaited(loadAlarms());
    ringSubscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);


  }

  Future<void> loadAlarms() async {
    final updatedAlarms = await Alarm.getAlarms();
    updatedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    setState(() {
      alarms = updatedAlarms;
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            AlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
    unawaited(loadAlarms());
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: AlarmEditScreen(alarmSettings: settings),
        );
      },
    );

    if (res != null && res == true) unawaited(loadAlarms());
  }


  @override
  void dispose() {
    ringSubscription?.cancel();
    //updateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const AlarmConteiner(),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedScreen())), 
                    icon: const Icon(Icons.bolt_outlined)),
                  IconButton(
                    onPressed: () => navigateToAlarmScreen(null),
                    icon: const Icon(Icons.add), iconSize: 30,),
                ],
              ),
            ),
            Expanded(
              child: alarms.isNotEmpty?
              ListView(
                children: [
                  for (final alarm in alarms)
                  AlarmItem(
                    alarm: alarm,
                    id: alarm.id,
                    key: Key(alarm.id.toString()),
                    title: alarm.notificationSettings.title, 
                    onPressed: () => navigateToAlarmScreen(alarm),
                    onDismissed: (){
                       Alarm.stop(alarm.id).then((_) => loadAlarms());
                    },
                  ),
                ],
              )
              : const Center(
                child: Text(
                  'Нет будильников', 
                  style: TextStyle(fontSize: 20),),),
            ),
          ],
        ),
      ),
    );
  }
}
