import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Map<String, dynamic>? weatherDataForecast;
  Map<String, dynamic>? weatherDataCurrent;

  // Объявляем переменные на уровне класса
  String? weatherDataCurrentName;
  String? weatherDataCurrentIcon;
  int? currentTemp; // Новая переменная для текущей температуры
  String? currentCity; // Переменная для текущего города

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(),
    );

    const apiKey = '2fe56a37e3fb2980e981e510f044d65c';

    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&cnt=8&lang=ru&units=metric&appid=$apiKey';

    final responseForecastUrl = await http.get(Uri.parse(forecastUrl));

    if (responseForecastUrl.statusCode == 200) {
      setState(() {
        weatherDataForecast =
            json.decode(responseForecastUrl.body) as Map<String, dynamic>?;
      });
    } else {
      throw Exception('Не удалось загрузить данные погоды');
    }

    final currentUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&lang=ru&units=metric&appid=$apiKey';

    // Корректируем URL для получения текущих данных погоды
    final responseCurrentUrl = await http.get(Uri.parse(currentUrl));

    if (responseCurrentUrl.statusCode == 200) {
      setState(() {
        weatherDataCurrent =
            json.decode(responseCurrentUrl.body) as Map<String, dynamic>?;

        // Безопасно парсим текущие данные погоды
        if (weatherDataCurrent!['weather'] is List<dynamic>) {
          // Явное приведение к List<dynamic>
          final weatherList =
              List<dynamic>.from(weatherDataCurrent!['weather'] as List<dynamic>);
          weatherDataCurrentName =
              weatherList.first['main'] as String? ?? 'Неизвестно'; // Значение по умолчанию
          weatherDataCurrentIcon =
              weatherList.first['icon'] as String? ?? '01d'; // Значок по умолчанию
        }

        // Извлечение текущей температуры
        if (weatherDataCurrent!['main'] is Map<String, dynamic> && weatherDataCurrent!['main']['temp'] is num) {
          currentTemp = (weatherDataCurrent!['main']['temp'] as num).toDouble().round();
        } else {
          currentTemp = null; // Или какое-либо значение по умолчанию
        }

        // Извлечение текущего города
        currentCity = weatherDataCurrent!['name'] as String? ?? 'Неизвестно';
      });
    } else {
      throw Exception('Не удалось загрузить текущие данные погоды');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (weatherDataForecast == null || weatherDataCurrent == null) {
      return const Center(
          child: CircularProgressIndicator(),
      );
    }

    if (weatherDataForecast!['list'] is! List<dynamic>) {
      return const Center(
          child: Text('Неверный формат данных погоды'),
      );
    }

    final forecasts =
        List<dynamic>.from(weatherDataForecast!['list'] as List<dynamic>);

    // Безопасный парсинг значений температуры и обработка возможных null
    final minTemp = forecasts
        .map((e) => (e['main']['temp_min'] as num).toDouble().round())
        .reduce((a, b) => a < b ? a : b);
    final maxTemp = forecasts
        .map((e) => (e['main']['temp_max'] as num).toDouble().round())
        .reduce((a, b) => a > b ? a : b);
    final windSpeed = forecasts
        .map((e) => (e['wind']['speed'] as num).toDouble().round())
        .reduce((a, b) => a > b ? a : b);

    return Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightGreen[100],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 1), 
                ),
        ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                  '$currentCity',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    width: 100,
                    height: 100,
                    'http://openweathermap.org/img/wn/$weatherDataCurrentIcon@2x.png',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${currentTemp!}°',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            ' $maxTemp°',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            ' $minTemp°',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 15,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Ветер: до $windSpeed м/с',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}