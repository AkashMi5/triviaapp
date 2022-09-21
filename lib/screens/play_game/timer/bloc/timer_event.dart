import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {}

class StartTimerEvent extends TimerEvent {
  StartTimerEvent({this.duration});

  final int duration;

  @override
  List<Object> get props => [duration];
}

class PauseTimerEvent extends TimerEvent {
  PauseTimerEvent({this.duration});

  final int duration;

  @override
  List<Object> get props => [duration];
}

class ResumeTimerEvent extends TimerEvent {
  ResumeTimerEvent({this.duration});

  final int duration;

  @override
  List<Object> get props => [duration];
}

class RunningTimerEvent extends TimerEvent {
  RunningTimerEvent({this.duration});

  final int duration;

  @override
  List<Object> get props => [duration];
}

class FinishedTimerEvent extends TimerEvent {
  FinishedTimerEvent({this.duration});

  final int duration;

  @override
  List<Object> get props => [duration];
}
