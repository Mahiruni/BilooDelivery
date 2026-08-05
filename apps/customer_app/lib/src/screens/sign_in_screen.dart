import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({required this.onSignIn, super.key});

  final ValueChanged<String> onSignIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController phoneController =
      TextEditingController(text: '+251 ');

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 32),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: BilooColors.royalBlue,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.delivery_dining_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'Welcome to Biloo',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: BilooColors.ink,
                    ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your phone number to continue. We will verify it with a secure one-time code.',
                style: TextStyle(
                  color: BilooColors.muted,
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone_rounded),
                ),
              ),
              const SizedBox(height: 18),
              BilooButton(
                label: 'Continue securely',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => widget.onSignIn(phoneController.text),
              ),
              const SizedBox(height: 28),
              const Row(
                children: <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: BilooColors.muted),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => widget.onSignIn('apple-user'),
                      icon: const Icon(Icons.apple_rounded),
                      label: const Text('Apple'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => widget.onSignIn('google-user'),
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 30),
                      label: const Text('Google'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              const Center(
                child: Text(
                  'By continuing, you agree to Biloo’s Terms and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: BilooColors.muted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
