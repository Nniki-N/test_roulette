import 'package:firebase_database/firebase_database.dart';
import 'package:test_roulette/domain/entity/user_model.dart';

class UserRepository {
  final _firebaseDatabase = FirebaseDatabase.instance;

  Future<void> saveUserDataInFirebaseDatabase({required UserModel userModel}) async {
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

  Future<void> deleteUserDataFromFirebaseDatabase({required String userId}) async {
    final ref = _firebaseDatabase.ref().child('users/$userId');

    await ref.remove();
  }
}
