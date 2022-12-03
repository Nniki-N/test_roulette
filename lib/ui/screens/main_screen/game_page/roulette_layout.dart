import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_roulette/domain/cubits/roulette_game_cubit.dart';
import 'package:test_roulette/resources/resources.dart';

class RouletteLayout extends StatelessWidget {
  const RouletteLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: RouletteDelegate(),
      children: [
        LayoutId(
          id: 0,
          child: const _ZerroCell(),
        ),
        for (int i = 1; i <= 36; i++)
          LayoutId(
            id: i,
            child: _NumberCell(
              index: i,
              backgroundColor: RouletteGameCubit.redCells.contains(i)
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        for (int i = 37; i <= 39; i++)
          LayoutId(
            id: i,
            child: _FooterCell(index: i),
          ),
        for (int i = 40; i <= 48; i++)
          LayoutId(
            id: i,
            child: _SideCell(index: i),
          ),
      ],
    );
  }
}

class _SideCell extends StatelessWidget {
  const _SideCell({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final rouletteGameCubit = context.watch<RouletteGameCubit>();
    BetTypes? betType;

    if (index == 40) {
      betType = BetTypes.firstColumn;
    } else if (index == 41) {
      betType = BetTypes.secondColumn;
    } else if (index == 42) {
      betType = BetTypes.thirdColumn;
    } else if (index == 43) {
      betType = BetTypes.lowNumber;
    } else if (index == 44) {
      betType = BetTypes.even;
    } else if (index == 45) {
      betType = BetTypes.red;
    } else if (index == 46) {
      betType = BetTypes.black;
    } else if (index == 47) {
      betType = BetTypes.odd;
    } else if (index == 48) {
      betType = BetTypes.highNumber;
    }

    if (index == 45) {
      return GestureDetector(
        onTap: () {
          rouletteGameCubit.bet(betType: betType ?? BetTypes.number);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: rouletteGameCubit.typesAndBets.containsKey(betType)
              ? Center(child: SvgPicture.asset(Svgs.coin, width: 15))
              : const SizedBox.shrink(),
        ),
      );
    } else if (index == 46) {
      return GestureDetector(
        onTap: () {
          rouletteGameCubit.bet(betType: betType ?? BetTypes.number);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: rouletteGameCubit.typesAndBets.containsKey(betType)
              ? Center(child: SvgPicture.asset(Svgs.coin, width: 15))
              : const SizedBox.shrink(),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        rouletteGameCubit.bet(betType: betType ?? BetTypes.number);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Center(
          child: RotatedBox(
            quarterTurns:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0
                    : 1,
            child: rouletteGameCubit.typesAndBets.containsKey(betType)
                ? Center(child: SvgPicture.asset(Svgs.coin, width: 15))
                : Text(
                    '${RouletteGameCubit.labels[index]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _FooterCell extends StatelessWidget {
  const _FooterCell({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final rouletteGameCubit = context.watch<RouletteGameCubit>();
    BetTypes? betType;

    if (index - 36 == 1) {
      betType = BetTypes.firstRow;
    } else if (index - 36 == 2) {
      betType = BetTypes.secondRow;
    } else if (index - 36 == 3) {
      betType = BetTypes.thirdRow;
    }

    return GestureDetector(
      onTap: () {
        rouletteGameCubit.bet(betType: betType ?? BetTypes.number);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: rouletteGameCubit.typesAndBets.containsKey(betType)
            ? Center(child: SvgPicture.asset(Svgs.coin, width: 15))
            : const Center(
                child: Text(
                  '2 to 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }
}

class _ZerroCell extends StatelessWidget {
  const _ZerroCell({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rouletteGameCubit = context.watch<RouletteGameCubit>();

    return GestureDetector(
      onTap: () {
        rouletteGameCubit.bet(betType: BetTypes.number, number: 0);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Center(
          child: rouletteGameCubit.numbersAndBets.containsKey(0)
              ? SvgPicture.asset(Svgs.coin, width: 15)
              : const Text(
                  '0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}

class _NumberCell extends StatelessWidget {
  const _NumberCell({
    Key? key,
    required this.index,
    required this.backgroundColor,
  }) : super(key: key);

  final int index;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final rouletteGameCubit = context.watch<RouletteGameCubit>();

    return GestureDetector(
      onTap: () {
        rouletteGameCubit.bet(betType: BetTypes.number, number: index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          color: backgroundColor,
        ),
        child: Center(
          child: rouletteGameCubit.numbersAndBets.containsKey(index)
              ? SvgPicture.asset(Svgs.coin, width: 15)
              : Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}

class RouletteDelegate extends MultiChildLayoutDelegate {
  static const rows = 14.0;
  static const cols = 8.0;

  RouletteDelegate();

  @override
  void performLayout(Size size) {
    Map<int, Rect> rects;
    Size inputSize;
    inputSize = const Size(cols, rows);
    rects = {
      0: const Rect.fromLTWH(2, 0, 6, 1), // 0
      for (int i = 0; i < 36; i++)
        i + 1: Rect.fromLTWH(2 + 2 * (i % 3), 1 + (i ~/ 3).toDouble(), 2, 1),
      37: const Rect.fromLTWH(2, 13, 2, 1), // 2 to 1 #1
      38: const Rect.fromLTWH(4, 13, 2, 1), // 2 to 1 #2
      39: const Rect.fromLTWH(6, 13, 2, 1), // 2 to 1 #3
      40: const Rect.fromLTWH(1, 1, 1, 4), // 1st 12
      41: const Rect.fromLTWH(1, 5, 1, 4), // 2nd 12
      42: const Rect.fromLTWH(1, 9, 1, 4), // 3rd 12
      43: const Rect.fromLTWH(0, 1, 1, 2), // 1-18
      44: const Rect.fromLTWH(0, 3, 1, 2), // even
      45: const Rect.fromLTWH(0, 5, 1, 2), // red
      46: const Rect.fromLTWH(0, 7, 1, 2), // black
      47: const Rect.fromLTWH(0, 9, 1, 2), // odd
      48: const Rect.fromLTWH(0, 11, 1, 2), // 19-36
    };

    final fs = applyBoxFit(BoxFit.contain, inputSize, size);
    final scale = fs.destination.width / fs.source.width;
    final offset =
        Alignment.center.inscribe(fs.destination, Offset.zero & size).topLeft;
    for (int i = 0; i <= 48; i++) {
      layoutChild(i, BoxConstraints.tight(rects[i]!.size * scale));
      positionChild(i, rects[i]!.topLeft.scale(scale, scale) + offset);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}
