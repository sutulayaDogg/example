import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdviceWidget extends StatefulWidget {
  const AdviceWidget({super.key});

  @override
  _AdviceWidgetState createState() => _AdviceWidgetState();
}

class _AdviceWidgetState extends State<AdviceWidget> {
  String _advice = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchAdvice();
  }

  Future<void> _fetchAdvice() async {
    final response = await http.get(Uri.parse('https://api.adviceslip.com/advice'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _advice = data['slip']['advice'].toString();
      });
    } else {
      setState(() {
        _advice = 'Failed to load advice';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.blue[50],
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
        _advice,
        style: const TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}