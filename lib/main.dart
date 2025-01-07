import 'package:charify/core/di/get_it.dart';
import 'package:charify/core/router/app_router.dart';
import 'package:charify/core/theme/app_theme.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:charify/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocProvider(
      create: (context) => getIt<UserBloc>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: AppTheme.getTheme(),
      ),
    ),
  );
}
