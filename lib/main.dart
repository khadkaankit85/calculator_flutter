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

class CalculatorScreen extends StatefulWidget {
  final String lastValue;

  const CalculatorScreen({Key? key, required this.lastValue}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _currentValue = '';
  String _operator = '';
  double _storedValue = 0;

  @override
  void initState() {
    super.initState();
    _display = widget.lastValue;
  }

  void _onDigitPressed(String digit) {
    if (_currentValue.length >= 8) return; // Limit to 8 digits
    setState(() {
      _currentValue += digit;
      _display = _currentValue;
    });
  }

  void _onOperatorPressed(String operator) {
    if (_currentValue.isNotEmpty) {
      _storedValue = double.parse(_currentValue);
      _currentValue = '';
      _operator = operator;
    }
  }

  void _onEqualsPressed() async {
    if (_operator.isEmpty || _currentValue.isEmpty) return;

    double currentValue = double.parse(_currentValue);
    double result = 0;

    switch (_operator) {
      case '+':
        result = _storedValue + currentValue;
        break;
      case '-':
        result = _storedValue - currentValue;
        break;
      case '*':
        result = _storedValue * currentValue;
        break;
      case '/':
        if (currentValue == 0) {
          setState(() {
            _display = 'ERROR';
          });
          return;
        }
        result = _storedValue / currentValue;
        break;
    }

    if (result.toString().length > 8) {
      setState(() {
        _display = 'OVERFLOW';
      });
    } else {
      setState(() {
        _display = result.toString();
      });
    }

    // Save the last value
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastValue', _display);

    _currentValue = '';
    _operator = '';
  }

  void _onClearEntry() {
    setState(() {
      _currentValue = '';
      _display = '0';
    });
  }

  void _onClear() {
    setState(() {
      _currentValue = '';
      _storedValue = 0;
      _operator = '';
      _display = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: ['7', '8', '9'].map((digit) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () => _onDigitPressed(digit),
                          child: Text(digit),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: ['4', '5', '6'].map((digit) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () => _onDigitPressed(digit),
                          child: Text(digit),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: ['1', '2', '3'].map((digit) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () => _onDigitPressed(digit),
                          child: Text(digit),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: _onClearEntry,
                          child: const Text('CE'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () => _onDigitPressed('0'),
                          child: const Text('0'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: _onClear,
                          child: const Text('C'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: ['+', '-', '*', '/'].map((operator) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: () => _onOperatorPressed(operator),
                      child: Text(operator),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _onEqualsPressed,
            child: const Text('='),
          ),
        ],
      ),
    );
  }
}
