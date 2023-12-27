import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stopwatch/providers/stopwatch.dart';

class StopwatchPage extends ConsumerWidget {
  const StopwatchPage({super.key});

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
                    action: () => stopwatchState.isRunning ? ref.read(stopwatchProvider.notifier).stop() : ref.read(stopwatchProvider.notifier).start(),
                  ),
                  _buildActionButton(
                    label: stopwatchState.isRunning ? 'Lap' : 'Reset',
                    action: () => stopwatchState.isRunning ? ref.read(stopwatchProvider.notifier).addLap() : ref.read(stopwatchProvider.notifier).reset(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              if (stopwatchState.laps.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Total Laps: ${stopwatchState.laps.length}'),
                ),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: stopwatchState.laps.length,
                      itemBuilder: (context, index) {
                        List<String> keys = stopwatchState.laps.keys.toList().reversed.toList();
                        String key = keys[index];
                        String? value = stopwatchState.laps[key];
                        return ListTile(
                          leading: Text(key),
                          trailing: Text(value!),
                        );
                      },
                    ),
                  ),
                ),
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