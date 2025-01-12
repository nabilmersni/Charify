import 'package:charify/core/di/get_it.dart';
import 'package:charify/core/router/app_router.dart';
import 'package:charify/core/theme/app_theme.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:charify/features/auth/presentation/bloc/user_event.dart';
import 'package:charify/features/auth/presentation/bloc/user_state.dart';
import 'package:charify/features/auth/presentation/page/auth_page.dart';
import 'package:charify/features/main/presentation/bloc/main_bloc.dart';
import 'package:charify/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<UserBloc>()..add(GetUserEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<MainBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: AppTheme.getTheme(),
        builder: (context, widget) {
          return BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state.status == UserStatus.error) {
                AppRouter.router.go(AuthPage.path);
              }

              if (state.status == UserStatus.logout) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Successfully logged out"),
                  ),
                );
                AppRouter.router.go(AuthPage.path);
              }
            },
            child: widget,
          );
        },
      ),
    ),
  );
}
