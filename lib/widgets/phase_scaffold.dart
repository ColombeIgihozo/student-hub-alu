import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Full-screen wrapper for splash / onboarding / auth.
/// Provides [Scaffold] + [Material] so TextFields and Text render correctly.
class PhaseScaffold extends StatelessWidget {
  const PhaseScaffold({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.5),
            radius: 1.1,
            colors: [AppColors.splashRadial, AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: padding != null
                ? Padding(padding: padding!, child: child)
                : child,
          ),
        ),
      ),
    );
  }
}
