import 'package:alarm/model/alarm_settings.dart';
import 'package:intl/intl.dart';

  List<AlarmSettings> alarms = [];

  String getTime(DateTime dateTime){
    final formatter = DateFormat('HH:mm').format(dateTime);
    return formatter;
  }
  
  







