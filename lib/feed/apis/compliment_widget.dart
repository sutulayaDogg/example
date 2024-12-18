import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplimentWidget extends StatefulWidget {

  const ComplimentWidget({super.key});

  @override
  _ComplimentWidgetState createState() => _ComplimentWidgetState();
}

class _ComplimentWidgetState extends State<ComplimentWidget> {

  String _compliment = 'Загрузка...';

  @override
  void initState() {
    super.initState();
    _fetchCompliment();
  }

  Future<void> _fetchCompliment() async {
    final response = await http.get(Uri.parse('https://tools-api.robolatoriya.com/compliment?'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _compliment = data['text'].toString();
      });
    } else {
      setState(() {
        _compliment = 'Не удалось загрузить комплимент';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Colors.pink[50],
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
          child: Text(
            _compliment,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
    );
  }
}
