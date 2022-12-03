import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_roulette/domain/cubits/account_cubit.dart';
import 'package:test_roulette/domain/cubits/rating_cubit.dart';
import 'package:test_roulette/domain/cubits/roulette_game_cubit.dart';
import 'package:test_roulette/resources/resources.dart';
import 'package:test_roulette/ui/screens/main_screen/game_page/game_page.dart';
import 'package:test_roulette/ui/screens/main_screen/rating_page/rating_page.dart';
import 'package:test_roulette/ui/screens/main_screen/settings_page/settings_page.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: Container(
        height: 70,
        width: double.infinity,
        color: menuBarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _pageIndex = 0;
                });
              },
              child: const SizedBox(
                child: Icon(
                  Icons.local_play_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _pageIndex = 1;
                });
              },
              child: const SizedBox(
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _pageIndex = 2;
                });
              },
              child: const SizedBox(
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: MainScreenHeader(),
      ),
      body: IndexedStack(
        index: _pageIndex,
        children: [
          BlocProvider(
            create: (context) => RouletteGameCubit(),
            child: const GamePage(),
          ),
          BlocProvider(
            create: (context) => RatingCubit(),
            child: const RatingPage(),
          ),
          const SettingPage(),
        ],
      ),
    );
  }
}

class MainScreenHeader extends StatelessWidget {
  const MainScreenHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountCubit = context.watch<AccountCubit>();
    final userModel = accountCubit.getUser();
    final userName = userModel?.userName;
    final numberOfChips = userModel?.numberOfChips;

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
      color: menuBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            userName ?? 'user name',
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                numberOfChips != null ? numberOfChips.toString() : '0',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(Svgs.coin, width: 25),
            ],
          )
        ],
      ),
    );
  }
}
