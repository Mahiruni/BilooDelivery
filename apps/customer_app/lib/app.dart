import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import 'src/screens/home_shell.dart';
import 'src/screens/onboarding_screen.dart';
import 'src/screens/sign_in_screen.dart';
import 'src/state/customer_app_state.dart';

class BilooCustomerApp extends StatefulWidget {
  const BilooCustomerApp({super.key});

  @override
  State<BilooCustomerApp> createState() => _BilooCustomerAppState();
}

class _BilooCustomerAppState extends State<BilooCustomerApp> {
  late final CustomerAppState appState = CustomerAppState();

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Biloo Delivery',
          debugShowCheckedModeBanner: false,
          theme: BilooTheme.light(),
          darkTheme: BilooTheme.dark(),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: switch ((appState.hasCompletedOnboarding, appState.isSignedIn)) {
            (false, _) => OnboardingScreen(
                onFinished: appState.completeOnboarding,
              ),
            (true, false) => SignInScreen(
                onSignIn: appState.signIn,
              ),
            (true, true) => HomeShell(appState: appState),
          },
        );
      },
    );
  }
}
