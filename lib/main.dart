import 'package:calculator/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final lastValue = prefs.getString('lastValue') ?? '0';
  runApp(CalculatorApp(lastValue: lastValue));
}

class CalculatorApp extends StatelessWidget {
  final String lastValue;

  const CalculatorApp({Key? key, required this.lastValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(lastValue: lastValue),
    );
  }
}
