import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int page = 0;

  static const List<_OnboardingPage> pages = <_OnboardingPage>[
    _OnboardingPage(
      icon: Icons.restaurant_menu_rounded,
      title: 'Fresh food,\nright when you need it',
      body: 'Discover trusted restaurants and local favourites around you.',
    ),
    _OnboardingPage(
      icon: Icons.delivery_dining_rounded,
      title: 'Fast delivery,\nclear updates',
      body: 'Follow every step from the kitchen to your door in real time.',
    ),
    _OnboardingPage(
      icon: Icons.verified_user_rounded,
      title: 'Simple checkout,\nsecure payments',
      body: 'Pay with cash or your preferred digital payment method.',
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[BilooColors.deepBlue, BilooColors.royalBlue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Text(
                      'BILOO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: widget.onFinished,
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: pages.length,
                    onPageChanged: (int value) => setState(() => page = value),
                    itemBuilder: (BuildContext context, int index) {
                      final _OnboardingPage item = pages[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.10),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.16),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 40,
                                  offset: const Offset(0, 24),
                                ),
                              ],
                            ),
                            child: Icon(
                              item.icon,
                              size: 104,
                              color: BilooColors.amber,
                            ),
                          ),
                          const SizedBox(height: 52),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              height: 1.12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item.body,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    pages.length,
                    (int index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: page == index ? 28 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: page == index
                            ? BilooColors.amber
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                BilooButton(
                  label: page == pages.length - 1 ? 'Get started' : 'Continue',
                  onPressed: () {
                    if (page == pages.length - 1) {
                      widget.onFinished();
                    } else {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}
