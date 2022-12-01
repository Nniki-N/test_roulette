import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/entity/user_model.dart';
import 'package:test_roulette/domain/repositories/user_repository.dart';

enum AuthState {
  initial,
  signedIn,
  signedOut,
  inProcess,
}

class AuthCubit extends Cubit<AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _userRopository = UserRepository();

  // variables used to display response to user
  String _errorText = '';
  String get errorText => _errorText;

  // to check auth changes
  StreamSubscription<User?>? _authStreamSubscription;

  // to check error text changes
  final _errorTextStreamController = StreamController<String>();
  StreamSubscription<String>? _errorTextStreamSubscription;
  Stream<String>? _errorTextStream;

  Stream<String>? get errorTextStream => _errorTextStream;  

  AuthCubit() : super(AuthState.initial) {
    _initialize();
  }

  Future<void> _initialize() async {
    // notifies about any auth status changes
    _authStreamSubscription =
        _firebaseAuth.authStateChanges().listen((User? user) {
      if (user?.uid == null) {
        emit(AuthState.signedOut);
      } else {
        emit(AuthState.signedIn);
      }
    });

    // notifies about aby error text changes
    _errorTextStream = _errorTextStreamController.stream.asBroadcastStream();
    _errorTextStreamSubscription = _errorTextStream?.listen((value) {
      _errorText = value;
    });
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // sign in with email and password
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // sign in was successful
      if (user != null) {
        errorTextClean();
        return true;
      } else {
        throw ('error');
      }
    } catch (e) {
      _setTextError('$e');
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      // sign in anonymously
      final result = await _firebaseAuth.signInAnonymously();
      final user = result.user;

      // sign in was successful
      if (user != null) {
        // create anonymous user
        final random = Random();
        final userModel = UserModel(
          userId: user.uid,
          userName: 'User${random.nextInt(888888) + 111111}',
          numberOfChips: 2000,
          numberOfVictories: 0,
          numberOfGames: 0,
          winRate: 0.0,
        );

        // save anonymous user in firebases databases
        _userRopository.saveUserDataInFirebaseDatabase(userModel: userModel);

        errorTextClean();
        return true;
      } else {
        throw ('error anonymous');
      }
    } catch (e) {
      _setTextError('$e');
      return false;
    }
  }

  Future<bool> signInByGoogle() async {
    return false;
  }

  Future<bool> signOut() async {
    try {
      // sign out
      await _firebaseAuth.signOut();

      errorTextClean();
      return true;
    } catch (e) {
      _setTextError('$e');
      return false;
    }
  }

  Future<bool> registrateWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      // create new account with email and password
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // registration was successfull
      if (user != null) {
        // create user profile
        final userModel = UserModel(
          userId: user.uid,
          userName: userName,
          numberOfChips: 2000,
          numberOfVictories: 0,
          numberOfGames: 0,
          winRate: 0.0,
        );

        // save user in firebases databases
        _userRopository.saveUserDataInFirebaseDatabase(userModel: userModel);

        errorTextClean();
        return true;
      } else {
        throw ('This user doesn\'t exist');
      }
    } catch (e) {
      _setTextError('$e');
      return false;
    }
  }

  Future<bool> registrateByGoogle() async {
    return false;
  }

  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      // delete user data from firebase database
      _userRopository.deleteUserDataFromFirebaseDatabase(userId: user.uid);

      // delete user account from firebase
      user.delete();
    }
  }

  // clean error text
  void errorTextClean() {
    _setTextError('');
  }

  // set error text
  void _setTextError(String errorText) {
    _errorTextStreamController.add(errorText);
  }

  @override
  Future<void> close() async {
    await _authStreamSubscription?.cancel();
    await _errorTextStreamSubscription?.cancel();
    return super.close();
  }
}
