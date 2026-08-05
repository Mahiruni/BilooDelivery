import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BilooDriverApp());
}

class BilooDriverApp extends StatelessWidget {
  const BilooDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biloo Driver',
      debugShowCheckedModeBanner: false,
      theme: BilooTheme.light(),
      home: const DriverHome(),
    );
  }
}

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  int tab = 0;
  bool isOnline = true;
  bool hasAcceptedOffer = false;
  int deliveryStep = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      _Dashboard(
        isOnline: isOnline,
        hasAcceptedOffer: hasAcceptedOffer,
        onOnlineChanged: (bool value) => setState(() => isOnline = value),
        onAccept: () => setState(() => hasAcceptedOffer = true),
      ),
      _ActiveDelivery(
        hasDelivery: hasAcceptedOffer,
        step: deliveryStep,
        onAdvance: () => setState(() {
          if (deliveryStep < 3) {
            deliveryStep += 1;
          }
        }),
      ),
      const _Earnings(),
      const _DriverProfile(),
    ];

    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (int value) => setState(() => tab = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route_rounded),
            label: 'Delivery',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({
    required this.isOnline,
    required this.hasAcceptedOffer,
    required this.onOnlineChanged,
    required this.onAccept,
  });

  final bool isOnline;
  final bool hasAcceptedOffer;
  final ValueChanged<bool> onOnlineChanged;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.paddingOf(context).top + 20,
              20,
              28,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[BilooColors.deepBlue, BilooColors.royalBlue],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Good evening, Abel',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Ready to deliver?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Badge(
                        smallSize: 8,
                        child: Icon(Icons.notifications_none_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isOnline
                              ? BilooColors.success
                              : BilooColors.muted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isOnline ? Icons.bolt_rounded : Icons.pause_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              isOnline ? 'You are online' : 'You are offline',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isOnline
                                  ? 'Listening for nearby delivery requests'
                                  : 'Go online to receive delivery requests',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: isOnline,
                        onChanged: onOnlineChanged,
                        activeTrackColor: BilooColors.amber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
          sliver: SliverList.list(
            children: <Widget>[
              const Row(
                children: <Widget>[
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.payments_rounded,
                      label: 'Today',
                      value: 'ETB 1,240',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.delivery_dining_rounded,
                      label: 'Deliveries',
                      value: '8',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.star_rounded,
                      label: 'Rating',
                      value: '4.9',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.schedule_rounded,
                      label: 'Online',
                      value: '5h 18m',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const AppSectionHeader(title: 'Delivery offer'),
              const SizedBox(height: 12),
              if (!isOnline)
                const SurfaceCard(
                  child: Text(
                    'Go online to receive available delivery requests.',
                    style: TextStyle(color: BilooColors.muted, height: 1.5),
                  ),
                )
              else if (hasAcceptedOffer)
                const SurfaceCard(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.check_circle_rounded, color: BilooColors.success),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Offer accepted. Open the Delivery tab to start navigation.',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Abyssinia Kitchen',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pickup in Bole • 2.4 km away',
                                  style: TextStyle(color: BilooColors.muted),
                                ),
                              ],
                            ),
                          ),
                          StatusPill(
                            label: 'ETB 185',
                            color: BilooColors.success,
                            icon: Icons.payments_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _RouteRow(
                        icon: Icons.restaurant_rounded,
                        title: 'Pickup',
                        subtitle: 'Abyssinia Kitchen, Bole Road',
                      ),
                      const SizedBox(height: 12),
                      const _RouteRow(
                        icon: Icons.home_rounded,
                        title: 'Drop-off',
                        subtitle: 'Megenagna, Addis Ababa',
                      ),
                      const SizedBox(height: 18),
                      BilooButton(
                        label: 'Accept delivery',
                        icon: Icons.check_rounded,
                        onPressed: onAccept,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActiveDelivery extends StatelessWidget {
  const _ActiveDelivery({
    required this.hasDelivery,
    required this.step,
    required this.onAdvance,
  });

  final bool hasDelivery;
  final int step;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Active delivery',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: !hasDelivery
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Accept a delivery offer from the dashboard to begin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BilooColors.muted, fontSize: 16),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
              children: <Widget>[
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: BilooColors.skyBlue,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: BilooColors.line),
                  ),
                  child: const Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.alt_route_rounded,
                          color: BilooColors.royalBlue,
                          size: 130,
                        ),
                      ),
                      Positioned(
                        left: 22,
                        bottom: 20,
                        child: StatusPill(
                          label: '12 min • 4.8 km',
                          color: BilooColors.deepBlue,
                          icon: Icons.navigation_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _deliveryTitle(step),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _deliverySubtitle(step),
                        style: const TextStyle(
                          color: BilooColors.muted,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _RouteRow(
                        icon: Icons.person_rounded,
                        title: 'Customer',
                        subtitle: 'Mahir A. • +251 924 093 037',
                      ),
                      const SizedBox(height: 12),
                      const _RouteRow(
                        icon: Icons.receipt_long_rounded,
                        title: 'Order',
                        subtitle: 'BL-684201 • 3 items • Cash',
                      ),
                      const SizedBox(height: 18),
                      BilooButton(
                        label: step == 3 ? 'Delivery completed' : _buttonLabel(step),
                        icon: step == 3
                            ? Icons.check_circle_rounded
                            : Icons.arrow_forward_rounded,
                        onPressed: step == 3 ? null : onAdvance,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  static String _deliveryTitle(int step) => switch (step) {
        0 => 'Navigate to pickup',
        1 => 'Confirm pickup',
        2 => 'Navigate to customer',
        _ => 'Delivered successfully',
      };

  static String _deliverySubtitle(int step) => switch (step) {
        0 => 'Abyssinia Kitchen is preparing the order. Arrive at the pickup point.',
        1 => 'Verify the order number and confirm all items before leaving.',
        2 => 'The customer can now follow your live location and arrival estimate.',
        _ => 'Proof of delivery has been captured and your earnings were updated.',
      };

  static String _buttonLabel(int step) => switch (step) {
        0 => 'Arrived at restaurant',
        1 => 'Confirm order pickup',
        _ => 'Confirm delivery',
      };
}

class _Earnings extends StatelessWidget {
  const _Earnings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Earnings',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[BilooColors.deepBlue, BilooColors.royalBlue],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Available balance', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
                Text(
                  'ETB 4,860.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20),
                StatusPill(
                  label: 'Next payout: Friday',
                  color: BilooColors.amber,
                  icon: Icons.event_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const AppSectionHeader(title: 'This week'),
          const SizedBox(height: 12),
          const SurfaceCard(
            child: Column(
              children: <Widget>[
                _EarningRow(day: 'Today', deliveries: '8 deliveries', value: 'ETB 1,240'),
                Divider(height: 28),
                _EarningRow(day: 'Tuesday', deliveries: '11 deliveries', value: 'ETB 1,680'),
                Divider(height: 28),
                _EarningRow(day: 'Monday', deliveries: '9 deliveries', value: 'ETB 1,390'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverProfile extends StatelessWidget {
  const _DriverProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver profile', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: const <Widget>[
          SurfaceCard(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 34,
                  backgroundColor: BilooColors.skyBlue,
                  child: Text('AM', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Abel Mekonnen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text('Verified motorcycle driver', style: TextStyle(color: BilooColors.muted)),
                    ],
                  ),
                ),
                Icon(Icons.verified_rounded, color: BilooColors.success),
              ],
            ),
          ),
          SizedBox(height: 18),
          _ProfileRow(icon: Icons.two_wheeler_rounded, title: 'Vehicle and documents'),
          _ProfileRow(icon: Icons.account_balance_rounded, title: 'Payout account'),
          _ProfileRow(icon: Icons.shield_outlined, title: 'Safety and incidents'),
          _ProfileRow(icon: Icons.support_agent_rounded, title: 'Driver support'),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: BilooColors.royalBlue),
          const SizedBox(height: 18),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: BilooColors.muted)),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: BilooColors.skyBlue, borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: BilooColors.royalBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(subtitle, style: const TextStyle(color: BilooColors.muted, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _EarningRow extends StatelessWidget {
  const _EarningRow({required this.day, required this.deliveries, required this.value});

  final String day;
  final String deliveries;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(day, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(deliveries, style: const TextStyle(color: BilooColors.muted)),
            ],
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        child: Row(
          children: <Widget>[
            Icon(icon, color: BilooColors.royalBlue),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
