import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.appState, super.key});

  final CustomerAppState appState;

  void _selectTab(BuildContext context, int index) {
    Navigator.of(context).pop();
    appState.setTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: HomeScreen(appState: appState),
      ),
      CartScreen(appState: appState, embedded: true),
      OrdersScreen(appState: appState),
      ProfileScreen(appState: appState),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BilooColors.deepBlue,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 4,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: BilooColors.amber,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.delivery_dining_rounded,
                size: 21,
                color: BilooColors.deepBlue,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'BILOO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'DELIVERY',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      BilooColors.deepBlue,
                      BilooColors.royalBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: BilooColors.amber,
                      child: Icon(
                        Icons.delivery_dining_rounded,
                        color: BilooColors.deepBlue,
                        size: 27,
                      ),
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'BILOO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          'Food, delivered better.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _DrawerItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: appState.selectedTab == 0,
                onTap: () => _selectTab(context, 0),
              ),
              _DrawerItem(
                icon: Icons.shopping_bag_rounded,
                label: 'Cart',
                selected: appState.selectedTab == 1,
                trailing: appState.cartQuantity > 0
                    ? Badge(label: Text('${appState.cartQuantity}'))
                    : null,
                onTap: () => _selectTab(context, 1),
              ),
              _DrawerItem(
                icon: Icons.receipt_long_rounded,
                label: 'Orders',
                selected: appState.selectedTab == 2,
                onTap: () => _selectTab(context, 2),
              ),
              _DrawerItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                selected: appState.selectedTab == 3,
                onTap: () => _selectTab(context, 3),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Divider(),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(
                  appState.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                title: Text(
                  appState.isDarkMode ? 'Light mode' : 'Dark mode',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                onTap: appState.toggleTheme,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text(
                    'Sign out',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    appState.signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: selected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        selectedTileColor: BilooColors.royalBlue.withOpacity(0.10),
        selectedColor: BilooColors.royalBlue,
        leading: Icon(icon),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
