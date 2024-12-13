import 'package:alarm_example/apis/advice_widget.dart';
import 'package:alarm_example/apis/compliment_widget.dart';
import 'package:alarm_example/apis/weather_widget.dart';
import 'package:flutter/material.dart';


class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 1), 
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text(
                'Доброе утро!',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w600
                ),
                
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                WeatherWidget(),
                AdviceWidget(),
                ComplimentWidget()
              ],
            ),
          ),
        ],
      ),
    ) ;

  }
}