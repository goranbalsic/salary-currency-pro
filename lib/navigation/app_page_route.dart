import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The app's standard screen-to-screen push: a subtle fade+slide-up,
/// replacing the instant default [MaterialPageRoute] everywhere the app
/// navigates to a new screen (not used for [RootShell]'s bottom-tab
/// switching, which stays instant via `IndexedStack`).
PageRoute<T> appPageRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionDuration: Motion.medium,
    reverseTransitionDuration: Motion.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Motion.curve);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
