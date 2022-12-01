// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserModel {
  final String userId;
  final String userName;
  final int numberOfChips;
  final int numberOfVictories;
  final int numberOfGames;
  final double winRate;

  UserModel({
    required this.userId,
    required this.userName,
    required this.numberOfChips,
    required this.numberOfVictories,
    required this.numberOfGames,
    required this.winRate,
  });

  UserModel copyWith({
    String? userId,
    String? userName,
    int? numberOfChips,
    int? numberOfVictories,
    int? numberOfGames,
    double? winRate,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      numberOfChips: numberOfChips ?? this.numberOfChips,
      numberOfVictories: numberOfVictories ?? this.numberOfVictories,
      numberOfGames: numberOfGames ?? this.numberOfGames,
      winRate: winRate ?? this.winRate,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

}
