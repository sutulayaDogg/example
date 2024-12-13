import 'package:alarm/alarm.dart';
import 'package:alarm_example/alarm/repository/alarm_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmItem extends StatefulWidget {
  const AlarmItem({
    required this.title,
    required this.onPressed,
    required this.id,
    required this.alarm, 
    super.key,
    this.onDismissed,

  });

  final int id;
  final String title;
  final void Function() onPressed;
  final void Function()? onDismissed;
  final AlarmSettings alarm;
  


  @override
  State<AlarmItem> createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> {



  String getFormattedDate(DateTime dateTime) {
    final formatter = DateFormat('E, d MMM', 'ru_RU');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: Key(widget.id.toString()),
      direction: widget.onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => widget.onDismissed?.call(),
      child:  GestureDetector(
        onTap: widget.onPressed,
        child: Container(
            decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 25,  vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.alarm.notificationSettings.title != '')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                      widget.alarm.notificationSettings.title,
                      
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),
                    ), 
          
                  Text(
                    getTime(widget.alarm.dateTime), 
                    style: const TextStyle(
                      fontSize: 35, 
                      fontWeight: FontWeight.w400,),
                  ),
                ],
              ),
              const SizedBox(width: 10,),
              Row(
                children: [
                  Text(getFormattedDate(widget.alarm.dateTime)),
                  const SizedBox(width: 15,),
                  IconButton(
                    onPressed: (){
                     widget.onDismissed!();
                    }, 
                    icon: const Icon(Icons.delete_outline_rounded))           
                ],
              ),
            ],
          ),
          
          ),
      ),
    );
      // RawMaterialButton(
      //   onPressed: widget.onPressed,
      //   child: Container(
      //     height: 100,
      //     padding: const EdgeInsets.all(35),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text(
      //           widget.title,
      //           style: const TextStyle(
      //             fontSize: 28,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //         const Icon(Icons.keyboard_arrow_right_rounded, size: 35),
      //       ],
      //     ),
      //   ),
      // ),
  }
}
