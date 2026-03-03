import 'package:flutter/material.dart';
import 'package:template/utils/app_colors.dart';

ThemeData light() => ThemeData(
  fontFamily: "Poppins",
  scaffoldBackgroundColor: AppColors.neutral[50],
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.neutral[50],
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.neutral[900]),
    titleTextStyle: TextStyle(
      color: AppColors.neutral[900],
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
);
