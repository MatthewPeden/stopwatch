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

    BorderSide borderSide = const BorderSide(
      color: secondaryColor,
      width: 1.0,
    );

    final stopwatchState = ref.watch(stopwatchProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        toolbarHeight: mediaHeight * 0.05,
      ),
      bottomNavigationBar: BottomAppBar(
        color: secondaryColor,
        height: mediaHeight * 0.05,
      ),
      body: Center(
        child: Container(
          width: maxWidth,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              Container(
                height: timerAndButtonsHeight,
                width: maxWidth,
                decoration: generalBoxDecoration,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Center(
                    child: Text(
                      stopwatchState.time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: timerAndButtonsHeight,
                width: maxWidth,
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _buildActionButton(
                          label: stopwatchState.isRunning ? 'Stop' : 'Start',
                          borderSide: borderSide,
                          action: () => stopwatchState.isRunning ? ref.read(stopwatchProvider.notifier).stop() : ref.read(stopwatchProvider.notifier).start(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _buildActionButton(
                          label: stopwatchState.isRunning ? 'Lap' : 'Reset',
                           borderSide: borderSide,
                          action: () => stopwatchState.isRunning ? ref.read(stopwatchProvider.notifier).addLap() : ref.read(stopwatchProvider.notifier).reset(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (stopwatchState.laps.isNotEmpty)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: mediaHeight * 0.06,
                        width: maxWidth,
                        decoration: generalBoxDecoration,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Laps: ${stopwatchState.laps.length}',
                              style: const TextStyle(
                                color: Colors.white,
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

  Widget _buildActionButton({required String label, required BorderSide borderSide, required VoidCallback action}) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      onPressed: action,
      shape: RoundedRectangleBorder(
        side: borderSide,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTileText({required String text}) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }
}