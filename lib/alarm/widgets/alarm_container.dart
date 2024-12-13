
import 'package:flutter/material.dart';

class AlarmConteiner extends StatefulWidget {

  const AlarmConteiner({
    super.key,
  });

  @override
  State<AlarmConteiner> createState() => _AlarmConteinerState();
}
class _AlarmConteinerState extends State<AlarmConteiner> {

  

  String getFormattedDuration(Duration duration){
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final result = '$hours ч. и $minutes мин.';
  return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        top: 50, 
        bottom: 30, 
        left: 40, 
        right: 40,),
      height: MediaQuery.sizeOf(context).height / 3 - 80,
      width: MediaQuery.sizeOf(context).width,
      child: const Text('Будильник', style: TextStyle(fontSize: 30),) 
          
    );
  }
}
