import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/rating_cubit.dart';
import 'package:test_roulette/domain/entity/user_model.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RatingCubit, List<UserModel>>(
        builder: (context, state) {
          final list = state;

          return ListView.builder(
            itemBuilder: (context, index) {
              return UserItem(
                index: index,
                userName: list[index].userName,
                numberOfChips: list[index].numberOfChips,
                winRate: list[index].winRate,
              );
            },
            itemCount: list.length,
          );
        }
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({
    Key? key,
    required this.index,
    required this.userName,
    required this.numberOfChips,
    required this.winRate,
  }) : super(key: key);

  final int index;
  final String userName;
  final int numberOfChips;
  final double winRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      color: Colors.amber,
      child: Row(
        children: [
          Text('${index + 1}'),
          const SizedBox(width: 10),
          Container(
            color: Colors.green,
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName),
                Text('$winRate'),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$numberOfChips',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: 20,
                color: Colors.yellow,
              )
            ],
          ),
        ],
      ),
    );
  }
}
