import 'package:charify/features/auth/presentation/page/auth_page.dart';
import 'package:charify/features/main/presentation/page/main_page.dart';
import 'package:charify/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static var router = GoRouter(
    initialLocation: SplashPage.path,
    routes: [
      GoRoute(
        path: SplashPage.path,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: AuthPage.path,
        builder: (context, state) {
          return const AuthPage();
        },
      ),
      GoRoute(
        path: MainPage.path,
        builder: (context, state) {
          return const MainPage();
        },
      ),
    ],
  );
}
