import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'screens/auth_screen.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';


class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'ALU Intercampus Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        builder: (context, child) {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.bg,
            systemNavigationBarIconBrightness: Brightness.light,
          ));
          
          return child ?? const SizedBox.shrink();

        },
        home: const _RootRouter(),
      ),
    );
  }
}
// stateless widget
class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final phase = context.watch<AppState>().phase;

    return Material(
      color: AppColors.bg,
      child: switch (phase) {
        AppPhase.splash => const SplashScreen(),
        AppPhase.onboarding => const OnboardingScreen(),
        AppPhase.auth => const AuthScreen(),
        AppPhase.app => const MainShell(),
      },
    );
  }
}
