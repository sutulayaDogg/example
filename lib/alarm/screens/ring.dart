import 'package:alarm/alarm.dart';
import 'package:alarm_example/alarm/repository/alarm_repository.dart';
import 'package:alarm_example/feed/feed_screen.dart';
import 'package:flutter/material.dart';

// class AlarmRingScreen extends StatelessWidget {
//   const AlarmRingScreen({required this.alarmSettings, super.key});

//   final AlarmSettings alarmSettings;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               Text(alarmSettings.)
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const Text('', style: TextStyle(fontSize: 50)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 RawMaterialButton(
//                   onPressed: () {

//                   },
//                   child: Text(
//                     'Snooze',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),
//                 RawMaterialButton(
//                   onPressed: () {
//                     Alarm.stop(alarmSettings.id).then((_) {
//                       if (context.mounted) Navigator.pop(context);
//                     });
//                   },
//                   child: Text(
//                     'Stop',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class AlarmRingScreen extends StatelessWidget {
  const AlarmRingScreen({required this.alarmSettings, super.key});
  final AlarmSettings alarmSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (alarmSettings.notificationSettings.title != '') ? alarmSettings.notificationSettings.title : 'Будильник',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                getTime(alarmSettings.dateTime),
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Alarm.stop(alarmSettings.id).then((_) {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FeedScreen()),
                      );
                    }
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.indigo[800],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                ),
                child: const Text(
                  'Остановить',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 70),
              TextButton(
                onPressed: () {
                  final now = DateTime.now();
                  Alarm.set(
                    alarmSettings: alarmSettings.copyWith(
                      dateTime: DateTime(
                        now.year,
                        now.month,
                        now.day,
                        now.hour,
                        now.minute,
                      ).add(const Duration(minutes: 1)),
                    ),
                  ).then((_) {
                    if (context.mounted) Navigator.pop(context);
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Отложить',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
