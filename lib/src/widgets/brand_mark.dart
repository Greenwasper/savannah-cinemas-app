import 'package:flutter/material.dart';

import '../theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 22 : 27,
          height: compact ? 22 : 27,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment(-.35, -.35),
              colors: [
                Color(0xFFFFE2A2),
                SavannahColors.gold,
                SavannahColors.clay,
              ],
              stops: [0, .58, 1],
            ),
            boxShadow: [BoxShadow(color: Color(0x55EDAA3B), blurRadius: 15)],
          ),
        ),
        const SizedBox(width: 9),
        Flexible(
          child: Text(
            'Savannah',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 19 : 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -.5,
            ),
          ),
        ),
      ],
    );
  }
}
