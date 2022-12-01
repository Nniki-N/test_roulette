// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      numberOfChips: json['number_of_chips'] as int,
      numberOfVictories: json['number_of_victories'] as int,
      numberOfGames: json['number_of_games'] as int,
      winRate: (json['win_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'number_of_chips': instance.numberOfChips,
      'number_of_victories': instance.numberOfVictories,
      'number_of_games': instance.numberOfGames,
      'win_rate': instance.winRate,
    };
