import 'package:flutter/material.dart';

class RouletteLayout extends StatelessWidget {
  const RouletteLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = {
      40: '1st 12',
      41: '2nd 12',
      42: '3rd 12',
      43: '1-18',
      44: 'even',
      47: 'odd',
      48: '19-36'
    };

    final red = {
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

    return CustomMultiChildLayout(
      delegate: RouletteDelegate(),
      children: [
        LayoutId(
          id: 0,
          child: _buildZeroBox(),
        ),
        for (int i = 1; i <= 36; i++)
          LayoutId(
            id: i,
            child: RouletteBox(
              i: i,
              backgroundColor: red.contains(i) ? Colors.red : Colors.black,
            ),
          ),
        for (int i = 37; i <= 39; i++)
          LayoutId(
            id: i,
            child: _buildBottomRouletteBox(),
          ),
        for (int i = 40; i <= 48; i++)
          LayoutId(
            id: i,
            child: _buildSideRouletteBox(context, labels, i),
          ),
      ],
    );
  }

  Widget _buildZeroBox() {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
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

  Widget _buildBottomRouletteBox() {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: const Center(
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

  Widget _buildSideRouletteBox(
    BuildContext context,
    Map<int, String> labels,
    int i,
  ) {
    if (i == 45) {
      return GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
        ),
      );
    } else if (i == 46) {
      return GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {},
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
            child: Text(
              '${labels[i]}',
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

class RouletteBox extends StatelessWidget {
  const RouletteBox({
    Key? key,
    required this.i,
    required this.backgroundColor,
  }) : super(key: key);

  final int i;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            '$i',
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
