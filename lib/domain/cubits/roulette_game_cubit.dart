import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_roulette/domain/entity/user_model.dart';
import 'package:test_roulette/domain/repositories/users_repository.dart';

enum BetTypes {
  highNumber,
  lowNumber,
  red,
  black,
  even,
  odd,
  firstRow,
  secondRow,
  thirdRow,
  firstColumn,
  secondColumn,
  thirdColumn,
  number,
}

class RouletteGameState {
  UserModel? currentUser;

  RouletteGameState({required this.currentUser});
}

class RouletteGameCubit extends Cubit<RouletteGameState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usersRopository = UsersRepository();

  // cells constants
  static const Set<int> redCells = {
    1,
    3,
    5,
    7,
    9,
    12,
    14,
    16,
    18,
    19,
    21,
    23,
    25,
    27,
    30,
    32,
    34,
    36
  };
  static const Set<int> firstRowCells = {
    1,
    4,
    7,
    10,
    13,
    16,
    19,
    22,
    25,
    28,
    31,
    34
  };
  static const Set<int> secondRowCells = {
    2,
    5,
    8,
    11,
    14,
    17,
    20,
    23,
    26,
    29,
    32,
    25
  };
  static const Set<int> thirdRowCells = {
    3,
    6,
    9,
    12,
    15,
    18,
    21,
    24,
    27,
    30,
    33,
    36
  };
  static const List<int> rouletteNumbersOrder = [
    0,
    32,
    15,
    19,
    4,
    21,
    2,
    25,
    17,
    34,
    6,
    27,
    13,
    36,
    11,
    30,
    8,
    23,
    10,
    5,
    24,
    16,
    33,
    1,
    20,
    14,
    31,
    9,
    22,
    18,
    29,
    7,
    28,
    12,
    35,
    3,
    26,
  ];
  static final Map<int, String> labels = {
    40: '1st 12',
    41: '2nd 12',
    42: '3rd 12',
    43: '1-18',
    44: 'even',
    47: 'odd',
    48: '19-36'
  };

  // roulette table scroll controller
  final ScrollController _rouletteScrollController = ScrollController();
  ScrollController get rouletteScrollController => _rouletteScrollController;

  // wheel start and end positions
  double rouletteWheelAngleStart = 0.0;
  double rouletteWheelAngleEnd = 0.0;

  // user bets
  final Map<int, int> _numbersAndBets = {};
  final Map<BetTypes, int> _typesAndBets = {};
  Map<int, int> get numbersAndBets => _numbersAndBets;
  Map<BetTypes, int> get typesAndBets => _typesAndBets;

  // user bets conditions
  final _minBet = 10;
  int _currentBet = 0;
  int _totalBet = 0;

  int get currentBet => _currentBet;

  // notifies when wheel has to rotate
  bool isPlaying = false;

  // wheel rotating duration 
  static const int wheelRotatingDurationSeconds = 4;

  RouletteGameCubit() : super(RouletteGameState(currentUser: null)) {
    _initialize();
  }

  Future<void> _initialize() async {
    final userId = _firebaseAuth.currentUser?.uid;

    // load current user
    if (userId != null) {
      final currentUser =
          await _usersRopository.getUserModelFromFirebase(userId: userId);
      final newState = RouletteGameState(currentUser: currentUser);
      emit(newState);
    }

    // set first bet base on amount of user chips
    _currentBet = _stepperBet();
  }

  // throw random number and increase number of user chips by reward if user won
  Future<void> play() async {
    if (_numbersAndBets.isEmpty && _typesAndBets.isEmpty) return;

    final random = Random();
    final number = random.nextInt(37);
    int reward = 0;

    // spin roulette wheel and scroll to top
    isPlaying = true;
    animateRoulette(number: number);

    Timer(
      const Duration(seconds: wheelRotatingDurationSeconds),
      () async {
        // check high number
        if (_typesAndBets.containsKey(BetTypes.highNumber)) {
          if (number >= 19 && number <= 36) {
            reward += (_typesAndBets[BetTypes.highNumber] as int) * 2;
          }
        }

        // check low number
        if (_typesAndBets.containsKey(BetTypes.lowNumber)) {
          if (number >= 1 && number <= 18) {
            reward += (_typesAndBets[BetTypes.lowNumber] as int) * 2;
          }
        }

        // check red
        if (_typesAndBets.containsKey(BetTypes.red)) {
          if (redCells.contains(number)) {
            reward += (_typesAndBets[BetTypes.red] as int) * 2;
          }
        }

        // check black
        if (_typesAndBets.containsKey(BetTypes.black)) {
          if (!redCells.contains(number)) {
            reward += (_typesAndBets[BetTypes.black] as int) * 2;
          }
        }

        // check even
        if (_typesAndBets.containsKey(BetTypes.even)) {
          if (number % 2 == 0) {
            reward += (_typesAndBets[BetTypes.even] as int) * 2;
          }
        }

        // check odd
        if (_typesAndBets.containsKey(BetTypes.odd)) {
          if (number % 2 != 0) {
            reward += (_typesAndBets[BetTypes.odd] as int) * 2;
          }
        }

        // check first column
        if (_typesAndBets.containsKey(BetTypes.firstColumn)) {
          if (number >= 1 && number <= 12) {
            reward += (_typesAndBets[BetTypes.firstColumn] as int) * 3;
          }
        }

        // check second column
        if (_typesAndBets.containsKey(BetTypes.secondColumn)) {
          if (number >= 13 && number <= 24) {
            reward += (_typesAndBets[BetTypes.secondColumn] as int) * 3;
          }
        }

        // check third column
        if (_typesAndBets.containsKey(BetTypes.thirdColumn)) {
          if (number >= 25 && number <= 36) {
            reward += (_typesAndBets[BetTypes.thirdColumn] as int) * 3;
          }
        }

        // check first row
        if (_typesAndBets.containsKey(BetTypes.firstRow)) {
          if (firstRowCells.contains(number)) {
            reward += (_typesAndBets[BetTypes.firstRow] as int) * 3;
          }
        }

        // check second row
        if (_typesAndBets.containsKey(BetTypes.secondRow)) {
          if (secondRowCells.contains(number)) {
            reward += (_typesAndBets[BetTypes.secondRow] as int) * 3;
          }
        }

        // check third row
        if (_typesAndBets.containsKey(BetTypes.thirdRow)) {
          if (thirdRowCells.contains(number)) {
            reward += (_typesAndBets[BetTypes.thirdRow] as int) * 3;
          }
        }

        // check number
        if (_typesAndBets.containsKey(BetTypes.number)) {
          for (int i = 0; i <= 36; i++) {
            if (_numbersAndBets.containsKey(i)) {
              reward += (_numbersAndBets[i] as int) * 36;
            }
          }
        }

        isPlaying = false;

        // update user rating
        await _updateUserRating(isVictory: reward != 0);

        // update user chips amount nad set new basic bet
        await _increaseUserChips(count: reward);

        _totalBet = 0;
        _numbersAndBets.clear();
        _typesAndBets.clear();
        _currentBet = _stepperBet();
        emit(RouletteGameState(currentUser: state.currentUser?.copyWith()));
      },
    );
  }

  // animate roulette
  Future<void> animateRoulette({required int number}) async {
    // scroll to top
    _rouletteScrollController.animateTo(
      _rouletteScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );

    // set wheele start and end position
    rouletteWheelAngleStart = rouletteWheelAngleEnd - 3.0;
    rouletteWheelAngleEnd =
        3.0 + (-(360 / 37) * rouletteNumbersOrder.indexOf(number)) / 360;

    final newState =
        RouletteGameState(currentUser: state.currentUser?.copyWith());
    emit(newState);
  }

  // update winRate, number of games nad number of victories
  Future<void> _updateUserRating({required bool isVictory}) async {
    UserModel? currentUser = state.currentUser;

    if (currentUser != null) {
      final numberOfGames = currentUser.numberOfGames + 1;
      final numberOfVictories = isVictory
          ? currentUser.numberOfVictories + 1
          : currentUser.numberOfVictories;
      final winrate = double.tryParse(
          (numberOfVictories / (numberOfGames / 100)).toStringAsFixed(1));

      // decrease amount of users chips
      currentUser = currentUser.copyWith(
        numberOfGames: numberOfGames,
        numberOfVictories: numberOfVictories,
        winRate: winrate,
      );
      _usersRopository.saveUserDataInFirebaseDatabase(userModel: currentUser);

      final newState = RouletteGameState(currentUser: currentUser);
      emit(newState);
    }
  }

  // increase number of user chips in firebase database
  Future<void> _increaseUserChips({required int count}) async {
    UserModel? currentUser = state.currentUser;

    if (currentUser != null) {
      int newNumberOfChips;

      if (count == 0 && currentUser.numberOfChips < _minBet) {
        newNumberOfChips = 100;
      } else {
        newNumberOfChips = currentUser.numberOfChips + count;
      }

      // increase amount of users chips
      currentUser = currentUser.copyWith(numberOfChips: newNumberOfChips);
      await _usersRopository.saveUserDataInFirebaseDatabase(
          userModel: currentUser);

      final newState = RouletteGameState(currentUser: currentUser);
      emit(newState);
    }
  }

  // dencrease number of user chips in firebase database
  Future<void> _decreaseUserChips({required int count}) async {
    UserModel? currentUser = state.currentUser;

    if (currentUser != null) {
      int newNumberOfChips = currentUser.numberOfChips - count;

      // decrease amount of users chips
      currentUser = currentUser.copyWith(numberOfChips: newNumberOfChips);
      _usersRopository.saveUserDataInFirebaseDatabase(userModel: currentUser);

      final newState = RouletteGameState(currentUser: currentUser);
      emit(newState);
    }
  }

  // bet chips
  Future<void> bet({required BetTypes betType, int? number}) async {
    if (isPlaying) return;
    
    UserModel? currentUser = state.currentUser;

    if (currentUser != null) {
      if (currentUser.numberOfChips < _minBet) return;

      // bet chips
      if (betType == BetTypes.number) {
        if (number == null) return;

        if (_numbersAndBets.containsKey(number)) {
          _numbersAndBets[number] =
              _currentBet + (_numbersAndBets[number] as int);
        } else {
          _numbersAndBets[number] = _currentBet;
        }
      } else {
        if (_typesAndBets.containsKey(betType)) {
          _typesAndBets[betType] =
              _currentBet + (_typesAndBets[betType] as int);
        } else {
          _typesAndBets[betType] = _currentBet;
        }
      }

      // inrease total bet
      _totalBet += _currentBet;

      await _decreaseUserChips(count: _currentBet);
      _currentBet = _stepperBet();
    }

    final newState =
        RouletteGameState(currentUser: state.currentUser?.copyWith());
    emit(newState);
  }

  // increase bet size
  void increaseBet() {
    UserModel? currentUser = state.currentUser;

    if (currentUser != null) {
      _currentBet += _stepperBet();

      if (_currentBet > currentUser.numberOfChips) {
        _currentBet = currentUser.numberOfChips;
      }

      final newState = RouletteGameState(currentUser: currentUser.copyWith());
      emit(newState);
    }
  }

  // decrease bet size
  void decreaseBet() {
    _currentBet -= _stepperBet();

    if (_currentBet < _minBet) {
      _currentBet = _minBet;
    }

    final newState =
        RouletteGameState(currentUser: state.currentUser?.copyWith());
    emit(newState);
  }

  // bet 1/10 part of total amount of chips
  int _stepperBet() {
    UserModel? currentUser = state.currentUser;

    if (currentUser != null) {
      if (currentUser.numberOfChips ~/ 10 <= _minBet) {
        return _minBet;
      }

      return currentUser.numberOfChips ~/ 10;
    }

    return 0;
  }

  // clear all bets
  void clearAllBets() async {
    await _increaseUserChips(count: _totalBet);

    _totalBet = 0;
    _numbersAndBets.clear();
    _typesAndBets.clear();
    _currentBet = _stepperBet();

    emit(RouletteGameState(currentUser: state.currentUser?.copyWith()));
  }
}
