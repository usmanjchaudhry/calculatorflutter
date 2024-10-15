import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _output = '0';
  String _expression = '';
  List<String> _history = [];
  double _num1 = 0;
  double _num2 = 0;
  String _operator = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0'; // Clear the current output
        _expression = ''; // Clear the current expression
        _num1 = 0;
        _num2 = 0;
        _operator = '';
      } else if (buttonText == 'DEL') {
        _output =
            _output.length > 1 ? _output.substring(0, _output.length - 1) : '0';
        _expression = _expression.length > 1
            ? _expression.substring(0, _expression.length - 1)
            : '';
      } else if (buttonText == '+/-') {
        if (_output.startsWith('-')) {
          _output = _output.substring(1);
          _expression = _expression.substring(1);
        } else {
          _output = '-' + _output;
          _expression = '-' + _expression;
        }
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == 'x' ||
          buttonText == '/') {
        _num1 = double.parse(_output);
        _operator = buttonText;
        _expression = _output + _operator;
        _output = '0';
      } else if (buttonText == '.') {
        if (!_output.contains('.')) {
          _output += '.';
        }
      } else if (buttonText == '=') {
        _num2 = double.parse(_output);
        String result = '';
        if (_operator == '+') {
          result = (_num1 + _num2).toString();
        }
        if (_operator == '-') {
          result = (_num1 - _num2).toString();
        }
        if (_operator == 'x') {
          result = (_num1 * _num2).toString();
        }
        if (_operator == '/') {
          result = (_num1 / _num2).toString();
        }
        _history.add(_expression + _num2.toString() + '=' + result);
        _expression = _history.last;
        _output = result;
        _num1 = 0;
        _num2 = 0;
        _operator = '';
      } else if (buttonText == '√') {
        double num = double.parse(_output);
        _output = sqrt(num).toString();
        _expression = '√($_expression)';
        _history.add(_expression + ' = ' + _output);
      } else if (buttonText == 'x²') {
        double num = double.parse(_output);
        _output = (num * num).toString();
        _expression = '($_expression)²';
        _history.add(_expression + ' = ' + _output);
      } else if (buttonText == '1/x') {
        double num = double.parse(_output);
        _output = (1 / num).toString();
        _expression = '1/($_expression)';
        _history.add(_expression + ' = ' + _output);
      } else if (buttonText == '%') {
        double num = double.parse(_output);
        _output = (num / 100).toString();
        _expression = '($_expression)%';
        _history.add(_expression + ' = ' + _output);
      } else {
        // Handling for number buttons
        if (_output == '0' || _operator != '' && _output == '0') {
          _output = buttonText;
          _expression += buttonText;
        } else {
          _output += buttonText;
          _expression += buttonText;
        }
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 64.0,
          child: OutlinedButton(
            onPressed: () => _buttonPressed(buttonText),
            style: OutlinedButton.styleFrom(
              backgroundColor: buttonText == '=' ? Colors.blue : Colors.white,
              foregroundColor: Colors.black,
              textStyle:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Adjust the size of the history container to avoid overflow
            Container(
              height: MediaQuery.of(context).size.height *
                  0.2, // 20% of screen height
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: ListView.builder(
                reverse: false,
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Text(
                    _history[index],
                    style: const TextStyle(fontSize: 20.0, color: Colors.grey),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 24.0),
              child: Text(
                _expression,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Text(
                _output,
                style: const TextStyle(
                    fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Column(
              children: [
                Row(
                  children: [
                    _buildButton('√'),
                    _buildButton('x²'),
                    _buildButton('1/x'),
                    _buildButton('DEL'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('/'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('x'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('.'),
                    _buildButton('0'),
                    _buildButton('+/-'),
                    _buildButton('+'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('C'),
                    _buildButton('%'),
                    _buildButton('='),
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
