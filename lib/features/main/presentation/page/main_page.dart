import 'package:charify/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  static const String path = "/main";
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
    );
  }
}
