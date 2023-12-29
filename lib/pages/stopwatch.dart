import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stopwatch/providers/stopwatch.dart';
import 'package:stopwatch/utils/colors.dart';

class StopwatchPage extends ConsumerWidget {
  const StopwatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    final maxWidth = mediaWidth * 0.9;
    final timerAndButtonsHeight = mediaHeight * 0.15;

    BoxDecoration generalBoxDecoration = BoxDecoration(
      color: primaryColor,
      border: Border.all(
        width: 1.0,
        color: secondaryColor,
      ),
      borderRadius: BorderRadius.circular(4.0),
    );

    final stopwatchState = ref.watch(stopwatchProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        toolbarHeight: mediaHeight * 0.05,
      ),
      bottomNavigationBar: BottomAppBar(
        color: secondaryColor,
        height: mediaHeight * 0.08,
      ),
      body: Center(
        child: SizedBox(
            width: maxWidth,
            height: mediaHeight * 0.8,
            child: Column(
              children: <Widget>[
                Container(
                  height: timerAndButtonsHeight,
                  width: maxWidth,
                  decoration: generalBoxDecoration,
                  child: Center(
                    child: Text(
                      stopwatchState.time,
                      style: const TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: timerAndButtonsHeight,
                  width: maxWidth,
                  child: Row(
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
                ),
                if (stopwatchState.laps.isNotEmpty)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: generalBoxDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Total Laps: ${stopwatchState.laps.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: stopwatchState.laps.length,
                              itemBuilder: (context, index) {
                                List<String> keys = stopwatchState.laps.keys.toList().reversed.toList();
                                String key = keys[index];
                                String? value = stopwatchState.laps[key];

                                BorderSide borderSide = const BorderSide(
                                  color: secondaryColor,
                                  width: 1.0,
                                );

                                return Container(
                                  decoration: BoxDecoration(
                                      color: listTileColor,
                                      border: Border(
                                        bottom: borderSide,
                                        left: borderSide,
                                        right: borderSide,
                                      ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: ListTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    leading: _buildListTileText(text: key),
                                    trailing: _buildListTileText(text: value!),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
          backgroundColor: primaryColor,
          onPressed: action,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  width: 0.75,
                  color: secondaryColor,
              ),
              borderRadius: BorderRadius.circular(100.0)),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTileText({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
      ),
    );
  }
}