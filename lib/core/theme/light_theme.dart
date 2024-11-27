import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/theme/app_colors.dart';

mixin LightTheme on ThemeData{
  static ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.secondaryColor,
        fontSize: 16,
        fontFamily: 'Poppins'
      ),
      bodyMedium: TextStyle(
        color: AppColors.secondaryColor.withOpacity(0.8),
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      headlineSmall: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.gestureColor,
      foregroundColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: AppColors.primaryColor,
        fontFamily: 'Poppins',
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
      ),
      border: OutlineInputBorder(
        borderSide:  BorderSide(color: HexColor.fromHex('#EBEBEB')),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:  BorderSide(color: HexColor.fromHex('#EBEBEB')),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:  BorderSide(color: HexColor.fromHex('#EBEBEB')),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:  BorderSide(color: HexColor.fromHex('#EBEBEB')),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:  BorderSide(color: HexColor.fromHex('#EBEBEB')),
        borderRadius: BorderRadius.circular(8),
      ),
  ));
  static ThemeData get darkTheme =>ThemeData(

  );
}