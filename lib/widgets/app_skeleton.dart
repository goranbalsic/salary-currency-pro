import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A restrained pulsing placeholder block for loading states — no shimmer
/// sweep, just a slow opacity pulse, in keeping with the "short, purposeful,
/// no decorative motion" rule. Use in place of a spinner when the shape of
/// the eventual content is already known (e.g. a result card that's about
/// to populate).
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.onSurfaceVariant;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity =
            AppOpacity.skeleton + (_controller.value * AppOpacity.skeleton);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: base.withValues(alpha: opacity),
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(AppRadius.sm),
          ),
        );
      },
    );
  }
}
