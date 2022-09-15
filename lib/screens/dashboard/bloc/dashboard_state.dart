import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  const DashboardState(
      {this.isLoading,
      this.navigateToProfileScreen,
      this.navigateToPlayGameScreen,
      this.username,
      this.coins,
      this.experiencePoints,
      this.subjectWiseGames,
      this.randomGames,
      this.percentage,
      this.errorMessage});

  final bool isLoading;
  final bool navigateToProfileScreen;
  final bool navigateToPlayGameScreen;
  final String username;
  final String coins;
  final String experiencePoints;
  final String subjectWiseGames;
  final String randomGames;
  final String percentage;
  final String errorMessage;

  @override
  List<Object> get props => [
        isLoading,
        navigateToProfileScreen,
        navigateToPlayGameScreen,
        username,
        coins,
        experiencePoints,
        subjectWiseGames,
        randomGames,
        percentage,
        errorMessage
      ];

  factory DashboardState.initital() => const DashboardState(
      isLoading: true,
      navigateToPlayGameScreen: false,
      navigateToProfileScreen: false);

  DashboardState copyWith({
    bool isLoading,
    bool navigateToProfileScreen,
    bool navigateToPlayGameScreen,
    String username,
    String coins,
    String experiencePoints,
    String subjectWiseGames,
    String randomGames,
    String percentage,
    String errorMessage,
  }) =>
      DashboardState(
          isLoading: isLoading ?? this.isLoading,
          navigateToProfileScreen:
              navigateToProfileScreen ?? this.navigateToProfileScreen,
          navigateToPlayGameScreen:
              navigateToPlayGameScreen ?? this.navigateToPlayGameScreen,
          username: username ?? this.username,
          coins: coins ?? this.coins,
          experiencePoints: experiencePoints ?? this.experiencePoints,
          subjectWiseGames: subjectWiseGames ?? this.subjectWiseGames,
          randomGames: randomGames ?? this.randomGames,
          percentage: percentage ?? this.percentage,
          errorMessage: errorMessage ?? this.errorMessage);
}
