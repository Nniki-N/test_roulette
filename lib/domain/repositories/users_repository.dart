import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:test_roulette/domain/entity/user_model.dart';


class UsersRepository {
  final _firebaseDatabase = FirebaseDatabase.instance;

  // save user date or create user if user is missing in firebase database
  Future<void> saveUserDataInFirebaseDatabase(
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

  // get user data stream by user id from firebase database
  Stream<DatabaseEvent> getUserDataStreamFromFirebaseDatabase(
      {required String userId}) {
    final ref = _firebaseDatabase.ref().child('users/$userId');

    return ref.onValue.asBroadcastStream();
  }

  // delete user from firebase database
  Future<void> deleteUserDataFromFirebaseDatabase(
      {required String userId}) async {
    final ref = _firebaseDatabase.ref().child('users/$userId');

    await ref.remove();
  }

  // gest all users data stream from firebase database
  Stream<DatabaseEvent> getUsersDataStreamFromFirebaseDatabase() {
    final ref = _firebaseDatabase.ref().child('users');

    return ref.onValue;
  }
}
