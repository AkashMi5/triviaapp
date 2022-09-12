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

class DashboardLoadedState extends DashboardState {
  DashboardLoadedState(
      {this.username,
      this.coins,
      this.experiencePoints,
      this.subjectWiseGames,
      this.randomGames,
      this.percentage});
  final String username;
  final String coins;
  final String experiencePoints;
  final String subjectWiseGames;
  final String randomGames;
  final String percentage;
  @override
  List<Object> get props => [
        username,
        coins,
        experiencePoints,
        subjectWiseGames,
        randomGames,
        percentage
      ];
}

class DashboardToCategoryScreenState extends DashboardState {
  DashboardToCategoryScreenState();

  @override
  List<Object> get props => [];
}

class DashboardToProfileScreenState extends DashboardState {
  DashboardToProfileScreenState();

  @override
  List<Object> get props => [];
}

class DashboardErrorState extends DashboardState {
  DashboardErrorState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
