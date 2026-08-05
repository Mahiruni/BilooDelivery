import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BilooVendorApp());
}

class BilooVendorApp extends StatelessWidget {
  const BilooVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biloo Vendor',
      debugShowCheckedModeBanner: false,
      theme: BilooTheme.light(),
      home: const VendorHome(),
    );
  }
}

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int tab = 0;
  bool isOpen = true;
  final List<_VendorOrder> orders = <_VendorOrder>[
    const _VendorOrder(
      number: 'BL-684201',
      customer: 'Mahir A.',
      items: 'Doro Wot ×1, Beyaynetu ×1',
      total: 'ETB 775',
      status: 'New',
    ),
    const _VendorOrder(
      number: 'BL-684198',
      customer: 'Hana T.',
      items: 'Shekla Tibs ×2',
      total: 'ETB 1,025',
      status: 'Preparing',
    ),
    const _VendorOrder(
      number: 'BL-684192',
      customer: 'Samuel K.',
      items: 'Special Beyaynetu ×2',
      total: 'ETB 665',
      status: 'Ready',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      _VendorDashboard(
        isOpen: isOpen,
        onOpenChanged: (bool value) => setState(() => isOpen = value),
        orders: orders,
        onAdvanceOrder: _advanceOrder,
      ),
      _OrdersPage(orders: orders, onAdvanceOrder: _advanceOrder),
      const _MenuPage(),
      const _VendorProfile(),
    ];

    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (int value) => setState(() => tab = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu_rounded),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Store',
          ),
        ],
      ),
    );
  }

  void _advanceOrder(String number) {
    final int index = orders.indexWhere((_VendorOrder order) => order.number == number);
    if (index < 0) {
      return;
    }
    const Map<String, String> next = <String, String>{
      'New': 'Preparing',
      'Preparing': 'Ready',
      'Ready': 'Picked up',
    };
    final String? status = next[orders[index].status];
    if (status != null) {
      setState(() => orders[index] = orders[index].copyWith(status: status));
    }
  }
}

class _VendorDashboard extends StatelessWidget {
  const _VendorDashboard({
    required this.isOpen,
    required this.onOpenChanged,
    required this.orders,
    required this.onAdvanceOrder,
  });

  final bool isOpen;
  final ValueChanged<bool> onOpenChanged;
  final List<_VendorOrder> orders;
  final ValueChanged<String> onAdvanceOrder;

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
              26,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[BilooColors.deepBlue, BilooColors.royalBlue],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
            ),
            child: Column(
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Abyssinia Kitchen', style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 4),
                          Text(
                            'Operations dashboard',
                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.storefront_rounded, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        isOpen ? Icons.storefront_rounded : Icons.store_mall_directory_outlined,
                        color: BilooColors.amber,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isOpen ? 'Store is accepting orders' : 'Store is temporarily closed',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Switch.adaptive(
                        value: isOpen,
                        onChanged: onOpenChanged,
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
                  Expanded(child: _VendorMetric(label: 'Today sales', value: 'ETB 18,450', icon: Icons.trending_up_rounded)),
                  SizedBox(width: 12),
                  Expanded(child: _VendorMetric(label: 'Orders', value: '42', icon: Icons.receipt_long_rounded)),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: <Widget>[
                  Expanded(child: _VendorMetric(label: 'Avg. prep', value: '18 min', icon: Icons.timer_outlined)),
                  SizedBox(width: 12),
                  Expanded(child: _VendorMetric(label: 'Rating', value: '4.8', icon: Icons.star_rounded)),
                ],
              ),
              const SizedBox(height: 26),
              const AppSectionHeader(title: 'Live orders', actionLabel: 'View all'),
              const SizedBox(height: 12),
              ...orders.take(3).map(
                (_VendorOrder order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OrderCard(order: order, onAdvance: () => onAdvanceOrder(order.number)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrdersPage extends StatelessWidget {
  const _OrdersPage({required this.orders, required this.onAdvanceOrder});

  final List<_VendorOrder> orders;
  final ValueChanged<String> onAdvanceOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order queue', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          final _VendorOrder order = orders[index];
          return _OrderCard(order: order, onAdvance: () => onAdvanceOrder(order.number));
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onAdvance});

  final _VendorOrder order;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(order.number, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                    const SizedBox(height: 4),
                    Text(order.customer, style: const TextStyle(color: BilooColors.muted)),
                  ],
                ),
              ),
              StatusPill(
                label: order.status,
                color: order.status == 'Ready' || order.status == 'Picked up'
                    ? BilooColors.success
                    : order.status == 'New'
                        ? BilooColors.amber
                        : BilooColors.royalBlue,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(order.items, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(child: Text(order.total, style: const TextStyle(fontWeight: FontWeight.w900))),
              FilledButton(
                onPressed: order.status == 'Picked up' ? null : onAdvance,
                child: Text(_actionLabel(order.status)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _actionLabel(String status) => switch (status) {
        'New' => 'Accept',
        'Preparing' => 'Mark ready',
        'Ready' => 'Hand to driver',
        _ => 'Completed',
      };
}

class _MenuPage extends StatefulWidget {
  const _MenuPage();

  @override
  State<_MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<_MenuPage> {
  final Map<String, bool> availability = <String, bool>{
    'Doro Wot': true,
    'Special Beyaynetu': true,
    'Shekla Tibs': true,
    'Kitfo Special': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu management', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: <Widget>[
          IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add_rounded)),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: <Widget>[
          const SurfaceCard(
            child: Row(
              children: <Widget>[
                Icon(Icons.info_outline_rounded, color: BilooColors.royalBlue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Availability changes are reflected in the customer app immediately.',
                    style: TextStyle(color: BilooColors.muted, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...availability.entries.map(
            (MapEntry<String, bool> entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SurfaceCard(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: BilooColors.amberSoft, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.restaurant_rounded, color: BilooColors.deepBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          const Text('ETB 420 • Main dishes', style: TextStyle(color: BilooColors.muted)),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: entry.value,
                      onChanged: (bool value) => setState(() => availability[entry.key] = value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorProfile extends StatelessWidget {
  const _VendorProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store settings', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: const <Widget>[
          SurfaceCard(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 34,
                  backgroundColor: BilooColors.amberSoft,
                  child: Icon(Icons.storefront_rounded, color: BilooColors.deepBlue, size: 32),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Abyssinia Kitchen', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      SizedBox(height: 4),
                      Text('Approved vendor • Bole', style: TextStyle(color: BilooColors.muted)),
                    ],
                  ),
                ),
                Icon(Icons.verified_rounded, color: BilooColors.success),
              ],
            ),
          ),
          SizedBox(height: 18),
          _SettingRow(icon: Icons.schedule_rounded, title: 'Opening hours'),
          _SettingRow(icon: Icons.group_outlined, title: 'Staff and permissions'),
          _SettingRow(icon: Icons.local_offer_outlined, title: 'Promotions and discounts'),
          _SettingRow(icon: Icons.account_balance_outlined, title: 'Payout and commission'),
          _SettingRow(icon: Icons.analytics_outlined, title: 'Reports and analytics'),
          _SettingRow(icon: Icons.support_agent_rounded, title: 'Vendor support'),
        ],
      ),
    );
  }
}

class _VendorMetric extends StatelessWidget {
  const _VendorMetric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: BilooColors.royalBlue),
          const SizedBox(height: 18),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: BilooColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.icon, required this.title});

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

class _VendorOrder {
  const _VendorOrder({
    required this.number,
    required this.customer,
    required this.items,
    required this.total,
    required this.status,
  });

  final String number;
  final String customer;
  final String items;
  final String total;
  final String status;

  _VendorOrder copyWith({String? status}) => _VendorOrder(
        number: number,
        customer: customer,
        items: items,
        total: total,
        status: status ?? this.status,
      );
}
