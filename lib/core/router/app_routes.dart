import 'package:finance_app/core/router/app_transitions.dart';
import 'package:finance_app/core/router/routes_names.dart';
import 'package:finance_app/features/onboarding/forgot_password_screen/presentation/screen/forgot_password_screen.dart';
import 'package:finance_app/features/onboarding/login_screen/presentation/screen/login_screen.dart';
import 'package:finance_app/features/onboarding/signup_screen/presentation/screen/signup_screen.dart';
import 'package:finance_app/features/onboarding/splash_intro_screen/presentation/screen/splash_intro_screen.dart';
import 'package:finance_app/features/onboarding/splash_screen/presentation/screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

final AppRoute = GoRouter(
  initialLocation: RoutesNames.splash_screen,
  routes: [
    GoRoute(
      path: RoutesNames.splash_screen,
      pageBuilder: (context, state) => AppTransitions.fadeThrough(state, const SplashScreen()),
    ),
    GoRoute(
      path: RoutesNames.splash_intro_screen,
      pageBuilder: (context, state) => AppTransitions.sharedAxis(state, const SplashIntroScreen()),
    ),
    GoRoute(
      path: RoutesNames.login_screen,
      pageBuilder: (context, state) => AppTransitions.sharedAxis(state, const LoginScreen()),
    ),
    GoRoute(
      path: RoutesNames.sign_up_screen,
      pageBuilder: (context, state) => AppTransitions.sharedAxis(state, const SignupScreen()),
    ),
    GoRoute(
      path: RoutesNames.forgot_password_screen,
      pageBuilder: (context, state) => AppTransitions.sharedAxis(state, const ForgotPasswordScreen()),
    ),
  ],
);
