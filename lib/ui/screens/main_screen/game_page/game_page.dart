import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_roulette/domain/cubits/roulette_game_cubit.dart';
import 'package:test_roulette/resources/resources.dart';
import 'package:test_roulette/ui/screens/main_screen/game_page/roulette_layout.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';
import 'package:test_roulette/ui/widgets/custom_button.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final rouletteGameCubit = context.watch<RouletteGameCubit>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: rouletteGameCubit.rouletteScrollController,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              children: [
                Stack(
                  children: [
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    rouletteGameCubit.isPlaying
                        ? RotatedWheel(
                            key: UniqueKey(),
                            rouletteWheelAngleStart:
                                rouletteGameCubit.rouletteWheelAngleStart,
                            rouletteWheelAngleEnd:
                                rouletteGameCubit.rouletteWheelAngleEnd,
                          )
                        : RotationTransition(
                            turns: AlwaysStoppedAnimation(
                                rouletteGameCubit.rouletteWheelAngleEnd),
                            child: SizedBox(
                              height: 300,
                              child:
                                  SvgPicture.asset(Svgs.europeanRouletteWheel),
                            ),
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
                GestureDetector(
                  onTap: () {
                    rouletteGameCubit.clearAllBets();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                CustomButton(
                  text: 'Start',
                  width: 140,
                  height: 45,
                  backgroundColor: Colors.orange,
                  foregroundColor: backgroundColor,
                  onPressed: () {
                    rouletteGameCubit.play();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RotatedWheel extends StatefulWidget {
  const RotatedWheel({
    Key? key,
    required this.rouletteWheelAngleEnd,
    required this.rouletteWheelAngleStart,
  }) : super(key: key);

  final double rouletteWheelAngleEnd;
  final double rouletteWheelAngleStart;

  @override
  State<RotatedWheel> createState() => _RotatedWheelState();
}

class _RotatedWheelState extends State<RotatedWheel>
    with TickerProviderStateMixin {
  late AnimationController _rouletteWheelcontroller;

  @override
  void initState() {
    _rouletteWheelcontroller = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: RouletteGameCubit.wheelRotatingDurationSeconds),
    )..forward();

    super.initState();
  }

  @override
  void dispose() {
    _rouletteWheelcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: widget.rouletteWheelAngleStart,
        end: widget.rouletteWheelAngleEnd,
      ).animate(_rouletteWheelcontroller),
      child: SizedBox(
        height: 300,
        child: SvgPicture.asset(Svgs.europeanRouletteWheel),
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
    final rouletteGameCubit = context.watch<RouletteGameCubit>();

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
              rouletteGameCubit.decreaseBet();
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
            child: Text(
              '${rouletteGameCubit.currentBet}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              rouletteGameCubit.increaseBet();
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
