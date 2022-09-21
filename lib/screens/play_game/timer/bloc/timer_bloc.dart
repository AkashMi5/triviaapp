import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:trivia_fun/screens/play_game/timer/bloc/timer_event.dart';
import 'package:trivia_fun/screens/play_game/timer/bloc/timer_state.dart';
import 'package:trivia_fun/screens/play_game/timer/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  StreamSubscription<int> _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription.cancel();
    return super.close();
  }

  TimerBloc({@required Ticker ticker})
      : _ticker = ticker,
        super(ReadyTimerState(60)) {
    on<TimerEvent>((event, emit) async {
      if (event is StartTimerEvent) {
        emit(RunningTimerState(event.duration));
        _tickerSubscription?.cancel();
        _tickerSubscription = _ticker
            .tick(ticks: event.duration)
            .listen((duration) => add(RunningTimerEvent(duration: duration)));
      } else if (event is RunningTimerEvent) {
        print('duration ${event.duration}');
        if (event.duration > 0) {
          print('duration ${event.duration}');
          emit(RunningTimerState(event.duration));
        } else
          add(FinishedTimerEvent());
      } else if (event is PauseTimerEvent) {
        _tickerSubscription?.pause();
        emit(PausedTimerState(event.duration));
      } else if (event is ResumeTimerEvent) {
        _tickerSubscription?.resume();
        emit(ResumeTimerState(event.duration));
      } else if (event is FinishedTimerEvent) {
        emit(FinishedTimerState(0));
      }
    });
  }
}
