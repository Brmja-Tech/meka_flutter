import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin Utils {
  // BorderRadius
  static BorderRadius smallRadius = BorderRadius.all(Radius.circular(8.0.r));
  static BorderRadius mediumRadius = BorderRadius.all(Radius.circular(16.0.r));
  static BorderRadius largeRadius = BorderRadius.all(Radius.circular(24.0.r));

  // Padding
  static EdgeInsets smallPadding = EdgeInsets.all(8.0.w);
  static EdgeInsets mediumPadding = EdgeInsets.all(16.0.w);
  static EdgeInsets largePadding = EdgeInsets.all(24.0.w);

  // Margins
  static EdgeInsets smallMargin = EdgeInsets.all(8.0.w);
  static EdgeInsets mediumMargin = EdgeInsets.all(16.0.w);
  static EdgeInsets largeMargin = EdgeInsets.all(24.0.w);
}
