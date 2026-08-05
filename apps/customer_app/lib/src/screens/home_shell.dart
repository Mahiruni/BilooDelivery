import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.appState, super.key});

  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      HomeScreen(appState: appState),
      CartScreen(appState: appState, embedded: true),
      OrdersScreen(appState: appState),
      ProfileScreen(appState: appState),
    ];

    return Scaffold(
      body: IndexedStack(index: appState.selectedTab, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: appState.selectedTab,
        onDestinationSelected: appState.setTab,
        destinations: <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: appState.cartQuantity > 0,
              label: Text('${appState.cartQuantity}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: appState.cartQuantity > 0,
              label: Text('${appState.cartQuantity}'),
              child: const Icon(Icons.shopping_bag_rounded),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
