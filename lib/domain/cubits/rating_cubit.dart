// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_roulette/domain/entity/user_model.dart';
import 'package:test_roulette/domain/repositories/firebase_database_repository.dart';

class RatingCubit extends Cubit<List<UserModel>> {
  final _firebaseDatabaseRepository = FirebaseDatabaseRepository();

  StreamSubscription<DatabaseEvent>? _usersStreamSubscription;

  RatingCubit() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    // change list when one of users has changes
    _usersStreamSubscription = _firebaseDatabaseRepository
        .getAllUsersDataStream().listen((event) {
      List<UserModel> list = [];

      for (var item in event.snapshot.children) {
        final json = item.value as Map<dynamic, dynamic>;
        final userModel = _getUserModelFromJson(json);

        list.add(userModel);
        emit(list);
      }

      list.sort(_sortUserModels);
    });
  }

  int _sortUserModels(UserModel firstUser, UserModel secondUser) {
    final firstUserChips = firstUser.numberOfChips;
    final secondUserChips = secondUser.numberOfChips;

    if (secondUserChips > firstUserChips) {
      return 1;
    } else if (secondUserChips < firstUserChips) {
      return -1;
    } else {
      return 0;
    }
  }

  UserModel _getUserModelFromJson(Object? value) {
    return UserModel.fromJson(
        jsonDecode(jsonEncode(value)) as Map<String, dynamic>);
  }

  @override
  Future<void> close() async {
    await _usersStreamSubscription?.cancel();
    return super.close();
  }
}
