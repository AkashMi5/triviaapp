import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  TimerState(this.duration);
  final int duration;
}

class ReadyTimerState extends TimerState {
  ReadyTimerState(int duration) : super(duration);

  @override
  List<Object> get props => [duration];
}

class PausedTimerState extends TimerState {
  PausedTimerState(int duration) : super(duration);

  @override
  List<Object> get props => [duration];
}

class ResumeTimerState extends TimerState {
  ResumeTimerState(int duration) : super(duration);

  @override
  List<Object> get props => [duration];
}

class RunningTimerState extends TimerState {
  RunningTimerState(int duration) : super(duration);

  @override
  List<Object> get props => [duration];
}

class FinishedTimerState extends TimerState {
  FinishedTimerState(int duration) : super(duration);

  @override
  List<Object> get props => [duration];
}
