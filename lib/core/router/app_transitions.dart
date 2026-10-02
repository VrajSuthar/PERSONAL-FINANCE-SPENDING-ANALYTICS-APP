import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable page transitions for [GoRoute.pageBuilder].
///
/// ```dart
/// GoRoute(
///   path: '/transactions',
///   pageBuilder: (context, state) => AppTransitions.sharedAxis(state, const TransactionsScreen()),
/// )
/// ```
class AppTransitions {
  const AppTransitions._();

  static const Duration _duration = Duration(milliseconds: 350);

  /// Forward/back navigation: the new screen slides in horizontally while fading.
  static CustomTransitionPage<T> sharedAxis<T>(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: _duration,
      reverseTransitionDuration: _duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          ),
    );
  }

  /// Switching between sibling destinations (e.g. bottom-nav tabs).
  static CustomTransitionPage<T> fadeThrough<T>(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: _duration,
      reverseTransitionDuration: _duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: Colors.transparent,
            child: child,
          ),
    );
  }
}
