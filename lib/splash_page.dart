import 'package:charify/core/theme/app_colors.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:charify/features/auth/presentation/bloc/user_state.dart';
import 'package:charify/features/main/presentation/page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  static const String path = '/splash';

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == UserStatus.success) {
          context.go(MainPage.path);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Text(
            'Charify',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.surface,
                fontSize: 52,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
