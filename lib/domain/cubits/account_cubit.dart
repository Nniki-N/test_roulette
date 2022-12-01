import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/entity/user_model.dart';
import 'package:test_roulette/domain/repositories/users_repository.dart';

class AccountCubit extends Cubit<UserModel?> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usersRopository = UsersRepository();

  // to check auth changes
  StreamSubscription<User?>? _authStreamSubscription;
  StreamSubscription<DatabaseEvent>? _userDataStreamSubscription;

  UserModel? getUser() => state;

  AccountCubit() : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    // change user state base on auth status
    _authStreamSubscription =
        _firebaseAuth.authStateChanges().listen((User? user) {
      if (user?.uid == null) {
        emit(null);
      } else {
        _setUserSream(userId: user!.uid);
      }
    });
  }

  // change current user base on changes user data
  Future<void> _setUserSream({required String userId}) async {
    _userDataStreamSubscription = _usersRopository
        .getUserDataStreamFromFirebaseDatabase(userId: userId)
        .listen(
      (event) {
        final json = event.snapshot.value;

        if (json != null) {
          emit(UserModel.fromJson(_jsonToMap(json)));
        }
      },
    );
  }

  Map<String, dynamic> _jsonToMap(Object? value) {
    return jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }

  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      // delete user data from firebase database
      await _usersRopository.deleteUserDataFromFirebaseDatabase(
          userId: user.uid);

      // delete user account from firebase
      await user.delete();
    }
  }

  @override
  Future<void> close() async {
    await _authStreamSubscription?.cancel();
    await _userDataStreamSubscription?.cancel();
    return super.close();
  }
}
