import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {}

class DashboardInitialEvent extends DashboardEvent {
  DashboardInitialEvent();

  @override
  List<Object> get props => [];
}

class DashboardLoadingEvent extends DashboardEvent {
  DashboardLoadingEvent();

  @override
  List<Object> get props => [];
}

class DashboardToCategoryScreenEvent extends DashboardEvent {
  DashboardToCategoryScreenEvent();

  @override
  List<Object> get props => [];
}

class DashboardToProfileScreenEvent extends DashboardEvent {
  DashboardToProfileScreenEvent();

  @override
  List<Object> get props => [];
}

class DashboardErrorClearEvent extends DashboardEvent {
  DashboardErrorClearEvent();

  @override
  List<Object> get props => [];
}
