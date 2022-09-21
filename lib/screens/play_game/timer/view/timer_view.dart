import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_fun/screens/play_game/timer/bloc/timer_bloc.dart';
import 'package:trivia_fun/screens/play_game/timer/bloc/timer_event.dart';
import 'package:trivia_fun/screens/play_game/timer/bloc/timer_state.dart';
import 'package:trivia_fun/screens/play_game/timer/ticker.dart';

class TimerView extends StatefulWidget {
  const TimerView({Key key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  TimerBloc _timerBloc;
  Ticker _ticker;

  @override
  void initState() {
    _ticker = Ticker();
    _timerBloc = TimerBloc(ticker: _ticker);
    _timerBloc.add(StartTimerEvent(duration: 60));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _timerBloc,
        child: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {},
          child: BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(state.duration.toString()),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      child: ElevatedButton(
                        onPressed: () {
                          if (state is PausedTimerState ||
                              state is FinishedTimerState) {
                            return null;
                          } else {
                            _timerBloc
                                .add(PauseTimerEvent(duration: state.duration));
                          }
                        },
                        child: Text("Pause"),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      child: ElevatedButton(
                        onPressed: () {
                          if (state is RunningTimerState ||
                              state is FinishedTimerState) {
                            return null;
                          } else {
                            _timerBloc.add(
                                ResumeTimerEvent(duration: state.duration));
                          }
                        },
                        child: Text("Resume"),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Finish"),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
