import 'package:flutter/material.dart';
import 'package:test_roulette/ui/screens/main_screen/game_page/game_page.dart';
import 'package:test_roulette/ui/screens/main_screen/rating_page/rating_page.dart';
import 'package:test_roulette/ui/screens/main_screen/settings_page/settings_page.dart';

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
      backgroundColor: const Color.fromARGB(255, 5, 38, 87),
      bottomNavigationBar: Container(
        height: 70,
        width: double.infinity,
        color: const Color.fromARGB(255, 46, 8, 8),
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
        children: const [
          GamePage(),
          RatingPage(),
          SettingPage(),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
      color: const Color.fromARGB(255, 46, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'user name',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Coins',
                style: TextStyle(
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
          )
        ],
      ),
    );
  }
}
