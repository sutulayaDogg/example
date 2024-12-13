import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';


class AlarmEditScreen extends StatefulWidget {
  const AlarmEditScreen({super.key, this.alarmSettings});

  final AlarmSettings? alarmSettings;

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  
  bool loading = false;
  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late double fadeDuration;
  late String assetAudio;
  late TextEditingController controller;
  int hour = 0;
  int minute = 0;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;
    controller = TextEditingController();

    if (creating) {
      controller.text = '';
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      fadeDuration = 0;
      assetAudio = 'assets/egor_kreed.mp3';
    } else {
      controller.text = widget.alarmSettings!.notificationSettings.title;
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      fadeDuration = widget.alarmSettings!.fadeDuration;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
    hour = selectedDateTime.hour;
    minute = selectedDateTime.minute;
  }

  String getFormattedDate(DateTime dateTime) {
    final formatter = DateFormat('E, d MMM', 'ru_RU');
    return formatter.format(dateTime);
  }

  String getFormattedTime(DateTime dateTime) {
    final formatter = DateFormat('', 'ru_RU');
    return formatter.format(dateTime);
  }
  // String getDay() {
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   final difference = selectedDateTime.difference(today).inDays;

  //   switch (difference) {
  //     case 0:
  //       return 'Today';
  //     case 1:
  //       return 'Tomorrow';
  //     case 2:
  //       return 'After tomorrow';
  //     default:
  //       return 'In $difference days';
  //   }
  // }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      fadeDuration: fadeDuration,
      assetAudioPath: assetAudio,
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: NotificationSettings(
        title: controller.text,
        body: 'Your alarm ($id) is ringing',
        stopButton: 'Stop the alarm',
        icon: 'notification_icon',
      ),
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    final alarmSettings = buildAlarmSettings();
    Alarm.set(alarmSettings: alarmSettings).then((res) {

      if (res && mounted) {

        Navigator.pop(context, true);
      }
      setState(() => loading = false);
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res && mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Отмена',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: (){
                  selectedDateTime = selectedDateTime.copyWith(
                  hour: hour,
                  minute: minute,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0,
                );
                if (selectedDateTime.isBefore(DateTime.now())) {
                  selectedDateTime = selectedDateTime.add(
                        const Duration(days: 1),);
                }
                  saveAlarm(); 
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Сохранить',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
              ),
            ],
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberPicker(
                    minValue: 0,
                    maxValue: 23,
                    value: hour,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 80,
                    itemHeight: 60,
                    onChanged : (value) {
                      setState(() {
                        hour = value;
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    selectedTextStyle:
                        const TextStyle(color: Colors.black, fontSize: 26),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.white,
                          ),
                          bottom: BorderSide(color: Colors.white),),
                    ),
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 59,
                    value: minute,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 80,
                    itemHeight: 60,
                    onChanged: (value) {
                      setState(() {
                        minute = value;
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle:
                        const TextStyle(color: Colors.black, fontSize: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.white,
                          ),
                          bottom: BorderSide(color: Colors.white),),
                    ),
                  ),
                ],
              ),
          ), 
          // RawMaterialButton(
          //   onPressed: pickTime,
          //   fillColor: Colors.grey[200],
          //   child: Container(
          //     margin: const EdgeInsets.all(20),
          //     child: Text(
          //       TimeOfDay.fromDateTime(selectedDateTime).format(context),
          //       style: Theme.of(context)
          //           .textTheme
          //           .displayMedium!
          //           .copyWith(color: Colors.blueAccent),
          //     ),
          //   ),
          // ),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Название',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loop alarm audio',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vibrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'assets/egor_kreed.mp3',
                    child: Text('Егор Крид'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/marimba.mp3',
                    child: Text('Marimba'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom volume',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: volume != null,
                onChanged: (value) =>
                    setState(() => volume = value ? 0.5 : null),
              ),
            ],
          ),
          if (volume != null)
            SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    volume! > 0.7
                        ? Icons.volume_up_rounded
                        : volume! > 0.1
                            ? Icons.volume_down_rounded
                            : Icons.volume_mute_rounded,
                  ),
                  Expanded(
                    child: Slider(
                      value: volume!,
                      onChanged: (value) {
                        setState(() => volume = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fade duration',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton<double>(
                value: fadeDuration,
                items: List.generate(
                  6,
                  (index) => DropdownMenuItem<double>(
                    value: index * 3.0,
                    child: Text('${index * 3}s'),
                  ),
                ),
                onChanged: (value) => setState(() => fadeDuration = value!),
              ),
            ],
          ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
