import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _intMinutes = 0;
  int _intSeconds = 0;
  int _intCentiseconds = 0;

  int _lapCounter = 0;
  Map<String, String> _laps = {};

  bool _stopwatchIsRunning = false;

  String stopwatchText = '00:00.00';

  Timer? _timer;

  void _startStopStopwatch() {
    if (_stopwatchIsRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
        if (_intCentiseconds == 99) {
          _intCentiseconds = 0;
          if (_intSeconds == 59) {
            _intSeconds = 0;
            _intMinutes++;
          } else {
            _intSeconds++;
          }
        } else {
          _intCentiseconds++;
        }

        final stringMinutes = _intMinutes.toString().padLeft(2, '0');
        final stringSeconds = _intSeconds.toString().padLeft(2, '0');
        final stringCentiseconds = _intCentiseconds.toString().padLeft(2, '0');

        setState(() {
          stopwatchText = '$stringMinutes:$stringSeconds.$stringCentiseconds';
        });
      });
    }

    setState(() {
      _stopwatchIsRunning = !_stopwatchIsRunning;
    });
  }

  void _lapOrReset() {

  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final timerHeight = MediaQuery.of(context).size.height * 0.15;

    final startStopButtonText = _stopwatchIsRunning ? 'Stop' : 'Start';
    final lapResetButtonText = _stopwatchIsRunning ? 'Lap' : 'Reset';

    return Scaffold(
      body: Center(
        child: SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: Column(
              children: <Widget>[
                Container(
                  height: timerHeight,
                  width: maxWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 3.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      stopwatchText,
                      style: const TextStyle(
                        fontSize: 70.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                          onPressed: _startStopStopwatch,
                          child: Text(startStopButtonText),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                          onPressed: _lapOrReset,
                          child: Text(lapResetButtonText),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
        ),
      ),
    );
  }
}
