import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_roulette/resources/resources.dart';
import 'package:test_roulette/ui/screens/main_screen/game_page/roulette_layout.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';
import 'package:test_roulette/ui/widgets/custom_button.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              children: [
                Stack(
                  children: [
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(Svgs.europeanRouletteWheel),
                    ),
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(Svgs.arrow),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const RouletteLayout(),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const GameBetController(),
                CustomButton(
                  text: 'Start',
                  width: 140,
                  height: 45,
                  backgroundColor: Colors.orange,
                  foregroundColor: backgroundColor,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameBetController extends StatelessWidget {
  const GameBetController({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: 15,
              width: 15,
              child: SvgPicture.asset(Svgs.minus),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey, width: 1),
                right: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: const Text(
              '100',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: 15,
              width: 15,
              child: SvgPicture.asset(Svgs.plus),
            ),
          ),
        ],
      ),
    );
  }
}
