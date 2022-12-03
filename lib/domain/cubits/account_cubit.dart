import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:test_roulette/domain/entity/user_model.dart';
import 'package:test_roulette/domain/repositories/sqflite_database_repository.dart';
import 'package:test_roulette/domain/repositories/firebase_database_repository.dart';

class AccountCubit extends Cubit<UserModel?> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseDatabaseRepository = FirebaseDatabaseRepository();
  final _sqfliteDatabaseRepository = SqfliteDatabaseRepository();
  final _connectivity = Connectivity();

  StreamSubscription<UserModel>? _sqfliteDatabaseSubscription;
  StreamSubscription<ConnectivityResult>? _connectionChangesSubscription;

  late final bool isRated;

  // to check auth changes
  StreamSubscription<User?>? _authStreamSubscription;
  StreamSubscription<DatabaseEvent>? _userDataStreamSubscription;

  UserModel? getUser() => state;

  AccountCubit() : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    // change user state base on auth status
    _authStreamSubscription = _firebaseAuth.authStateChanges().listen(
      (User? user) async {
        final userId = user?.uid;
        if (userId == null) {
          emit(null);
        } else {
          final connectivityResult = await (Connectivity().checkConnectivity());

          // load user online from firebase database
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            emit(await _firebaseDatabaseRepository.getUserModel(userId: userId));
          }
          // load user offline from sqflite database
          else {
            emit(await _sqfliteDatabaseRepository.getUserModel(userId: userId));
          }

          _setConnectionChnagesStream(userId: userId);

          // notifies about user changes from sqflite DB
          _setSqfliteDatabaseStream();
        }
      },
    );
  }

  // change user data storing base on connection status
  void _setConnectionChnagesStream({required String userId}) {
    _connectionChangesSubscription = _connectivity.onConnectivityChanged.listen(
      (event) async {
        // save current data status in firebase DB from sqflite DB and then
        // load chnages from firebase DB when online
        if (event == ConnectivityResult.mobile ||
            event == ConnectivityResult.wifi) {
          // load user data from sqflite DB
          final sqfliteUserModel =
              await _sqfliteDatabaseRepository.getUserModel(userId: userId);

          // save user data in firebase DB
          if (sqfliteUserModel != null) {
            await _firebaseDatabaseRepository.saveUserData(userModel: sqfliteUserModel);
          }

          emit(sqfliteUserModel);

          // notifies about user changes from firebase DB
          _setFirebaseDatabaseStream(userId: userId);
        }
        // load chnages from sqflite DB when offline
        else {
          await _userDataStreamSubscription?.cancel();

          emit(await _sqfliteDatabaseRepository.getUserModel(userId: userId));
        }
      },
    );
  }

  // update state on events in firebase DB stream
  void _setFirebaseDatabaseStream({required String userId}) {
    _userDataStreamSubscription =
        _firebaseDatabaseRepository.getUserDataStream(userId: userId).listen(
      (event) {
        final json = event.snapshot.value;

        if (json != null) {
          emit(UserModel.fromJson(_jsonToMap(json)));
        }
      },
    );
  }

  // update state on events in sqflite DB stream
  void _setSqfliteDatabaseStream() {
    _sqfliteDatabaseSubscription =
        SqfliteDatabaseRepository.sqfliteStream.listen((event) {
      emit(event);
    });
  }

  Map<String, dynamic> _jsonToMap(Object? value) {
    return jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }

  // delete user account
  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      // delete user data from firebase database
      await _firebaseDatabaseRepository.deleteUserData(userId: user.uid);

      // delete user account from firebase
      await user.delete();
    }
  }

  // rate app
  Future<void> rateApp() async {
    final inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing();
    }
  }

  @override
  Future<void> close() async {
    await _authStreamSubscription?.cancel();
    await _userDataStreamSubscription?.cancel();
    await _connectionChangesSubscription?.cancel();
    await _sqfliteDatabaseSubscription?.cancel();
    return super.close();
  }
}
