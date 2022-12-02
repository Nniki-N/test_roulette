import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_roulette/domain/entity/user_model.dart';
import 'package:test_roulette/domain/repositories/users_repository.dart';

enum AuthState {
  initial,
  signedIn,
  signedOut,
}

class AuthCubit extends Cubit<AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usersRopository = UsersRepository();

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
    // changes auth status
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

  // sign in with email and password
  Future<void> signInWithEmailAndPassword({
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
      } else {
        throw ('error');
      }
    } on FirebaseAuthException catch (e) {
      // display special error message
      switch (e.code) {
        case 'user-not-found':
          _setTextError('No user found for that email.');
          break;
        case 'invalid-email':
          _setTextError('Email address is written wrong');
          break;
        case 'wrong-password':
          _setTextError('Wrong password.');
          break;
        case 'user-disabled':
          _setTextError('Your account has been disabled by an administrator');
          break;
        default:
          _setTextError('Some error happened');
      }
    } catch (e) {
      _setTextError('$e');
    }
  }

  // sign in anonymously and create new account
  Future<void> signInAnonymously() async {
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
        _usersRopository.saveUserDataInFirebaseDatabase(userModel: userModel);

        errorTextClean();
      } else {
        throw ('error anonymous');
      }
    } on FirebaseAuthException catch (e) {
      // display special error message
      switch (e.code) {
        case 'peration-not-allowed':
          _setTextError('Anonymous auth hasn\'t been enabled for this project.');
          break;
        default:
          _setTextError('Some error happened');
      }
    } catch (e) {
      _setTextError('$e');
    }
  }

  // sign in with google and create new account if user is new
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = result.user;

      final newUser = result.additionalUserInfo?.isNewUser ?? false;

      // sign in was successfull and user is new
      if (user != null && newUser) {
        // create user profile
        final userModel = UserModel(
          userId: user.uid,
          userName: user.displayName ?? 'user name',
          numberOfChips: 2000,
          numberOfVictories: 0,
          numberOfGames: 0,
          winRate: 0.0,
        );

        // save user in firebases databases
        _usersRopository.saveUserDataInFirebaseDatabase(userModel: userModel);

        errorTextClean();
      }
    } catch (e) {
      _setTextError('$e');
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      // sign out
      await _firebaseAuth.signOut();

      errorTextClean();
    } on FirebaseAuthException catch (e) {
      // display special error message
      switch (e.code) {
        case 'user-signed-out':
          _setTextError('Invalid logout way.');
          break;
        default:
          _setTextError('Some error happened');
      }
    } catch (e) {
      _setTextError('$e');
    }
  }

  // regitrate with email and password and create new account
  Future<void> registrateWithEmailAndPassword({
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
        _usersRopository.saveUserDataInFirebaseDatabase(userModel: userModel);

        errorTextClean();
      } else {
        throw ('This user doesn\'t exist');
      }
    } on FirebaseAuthException catch (e) {
      // display special error message
      switch (e.code) {
        case 'email-already-exists':
          _setTextError('This email already exists.');
          break;
        case 'invalid-email':
          _setTextError('Please write your email correctly');
          break;
        case 'weak-password':
          _setTextError('Password shold be at least 6 characters.');
          break;
        default:
          _setTextError('Some error happened');
      }
    } catch (e) {
      _setTextError('$e');
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
