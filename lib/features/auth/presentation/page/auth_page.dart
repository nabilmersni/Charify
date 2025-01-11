import 'package:charify/core/ui/widgets/default_button.dart';
import 'package:charify/core/ui/widgets/loader.dart';
import 'package:charify/features/auth/presentation/bloc/user_bloc.dart';
import 'package:charify/features/auth/presentation/bloc/user_event.dart';
import 'package:charify/features/auth/presentation/bloc/user_state.dart';
import 'package:charify/features/main/presentation/page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatelessWidget {
  static const String path = "/auth";
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state.status == UserStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? "Error occured"),
                  ),
                );
              }
              if (state.status == UserStatus.success) {
                context.go(MainPage.path);
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                "Charify",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                '''Small steps big impact. Let's make a difference together!''',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                  child: SvgPicture.asset(
                                      "assets/images/hand.svg")),
                              const SizedBox(height: 40),
                              Text(
                                '''Be a hero in someone's story. Join now!''',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        DefaultButton(
                          text: "Sign in with Google",
                          onPressed: () {
                            context
                                .read<UserBloc>()
                                .add(SignInWithGoogleEvent());
                          },
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  state.status == UserStatus.loading
                      ? const Loader()
                      : const SizedBox(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
