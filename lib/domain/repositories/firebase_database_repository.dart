import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:test_roulette/domain/entity/user_model.dart';

class FirebaseDatabaseRepository {
  final _firebaseDatabase = FirebaseDatabase.instance;

  // save user date or create user if user is missing in firebase database
  Future<void> saveUserData(
      {required UserModel userModel}) async {
    final ref = _firebaseDatabase.ref().child('users/${userModel.userId}');

    await ref.set({
      'user_id': userModel.userId,
      'user_name': userModel.userName,
      'number_of_chips': userModel.numberOfChips,
      'number_of_victories': userModel.numberOfVictories,
      'number_of_games': userModel.numberOfGames,
      'win_rate': userModel.winRate,
    });
  }

  Future<UserModel> getUserModel({required String userId}) async {
    final ref = _firebaseDatabase.ref().child('users/$userId');

    final snapshot = await ref.get();
    final json = snapshot.value as Map<dynamic, dynamic>;
    return _getUserModelFromJson(json);
  }

  // get user data stream by user id from firebase database
  Stream<DatabaseEvent> getUserDataStream(
      {required String userId}) {
    final ref = _firebaseDatabase.ref().child('users/$userId');

    return ref.onValue.asBroadcastStream();
  }

  // delete user from firebase database
  Future<void> deleteUserData(
      {required String userId}) async {
    final ref = _firebaseDatabase.ref().child('users/$userId');

    await ref.remove();
  }

  // gest all users data stream from firebase database
  Stream<DatabaseEvent> getAllUsersDataStream() {
    final ref = _firebaseDatabase.ref().child('users');

    return ref.onValue;
  }

  UserModel _getUserModelFromJson(Object? value) {
    return UserModel.fromJson(
        jsonDecode(jsonEncode(value)) as Map<String, dynamic>);
  }
}
