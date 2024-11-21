import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gaps extends StatelessWidget {
  final double width;
  final double height;

  const Gaps({super.key, required this.width, required this.height});

  factory Gaps.vertical(double height) => Gaps(width: 0, height: height);

  factory Gaps.horizontal(double width) => Gaps(width: width, height: 0);

  factory Gaps.v18() => Gaps(width: 0, height: 18.h);

  factory Gaps.h18() => Gaps(width: 18.w, height: 0);

  factory Gaps.v10() => Gaps(width: 0, height: 10.h);

  factory Gaps.h10() => Gaps(width: 10.w, height: 0);

  factory Gaps.v28() => Gaps(width: 0, height: 28.h);

  factory Gaps.h28() => Gaps(width: 28.w, height: 0);
  factory Gaps.v48() => Gaps(width: 0, height: 48.h);

  factory Gaps.h48() => Gaps(width: 48.w, height: 0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
