import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.appState, super.key});

  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: HomeScreen(appState: appState),
      ),
      SearchScreen(appState: appState),
      CartScreen(appState: appState, embedded: true),
      OrdersScreen(appState: appState),
      ProfileScreen(appState: appState),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFCFE),
      body: IndexedStack(index: appState.selectedTab.clamp(0, screens.length - 1), children: screens),
      bottomNavigationBar: NavigationBar(
        height: 74,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        indicatorColor: const Color(0xFFFFF0E0),
        elevation: 8,
        selectedIndex: appState.selectedTab.clamp(0, 4),
        onDestinationSelected: appState.setTab,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: BilooColors.amber),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded, color: BilooColors.amber),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: appState.cartQuantity > 0,
              label: Text('${appState.cartQuantity}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: appState.cartQuantity > 0,
              label: Text('${appState.cartQuantity}'),
              child: const Icon(Icons.shopping_cart_rounded, color: BilooColors.amber),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded, color: BilooColors.amber),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: BilooColors.amber),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
