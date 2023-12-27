import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stopwatch/providers/stopwatch.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final timerHeight = MediaQuery.of(context).size.height * 0.15;
    final stopwatchState = ref.watch(stopwatchProvider);

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
                  border: Border.all(color: Colors.black, width: 3.0),
                ),
                child: Center(
                  child: Text(
                    stopwatchState.time,
                    style: const TextStyle(fontSize: 70.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildActionButton(
                    label: stopwatchState.isRunning ? 'Stop' : 'Start',
                    action: () => ref.read(stopwatchProvider.notifier).startStop(),
                  ),
                  _buildActionButton(
                    label: stopwatchState.isRunning ? 'Lap' : 'Reset',
                    action: () => ref.read(stopwatchProvider.notifier).reset(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, required VoidCallback action}) {
    return SizedBox(
      height: 80.0,
      width: 80.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: action,
          child: Text(label),
        ),
      ),
    );
  }
}
