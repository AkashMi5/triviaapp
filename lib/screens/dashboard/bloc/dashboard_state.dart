import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {}

class DashboardLoadingState extends DashboardState {
  DashboardLoadingState();

  @override
  List<Object> get props => [];
}

class DashboardInitialState extends DashboardState {
  DashboardInitialState();

  @override
  List<Object> get props => [];
}
