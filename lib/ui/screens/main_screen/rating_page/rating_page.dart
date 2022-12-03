import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_roulette/domain/cubits/rating_cubit.dart';
import 'package:test_roulette/domain/entity/user_model.dart';
import 'package:test_roulette/resources/resources.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body:
          BlocBuilder<RatingCubit, List<UserModel>>(builder: (context, state) {
        final list = state;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          itemBuilder: (context, index) {
            return UserItem(
              index: index + 1,
              userName: list[index].userName,
              numberOfChips: list[index].numberOfChips,
              winRate: list[index].winRate,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemCount: list.length,
        );
      }),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 4, 61, 33),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange)),
      child: Row(
        children: [
          Text(
            '$index',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.orange),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset(Svgs.defaultUserImage, width: 55),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Win rate: $winRate %',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 51, 163, 109),
                  ),
                ),
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
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(Svgs.coin, width: 30),
            ],
          ),
        ],
      ),
    );
  }
}
