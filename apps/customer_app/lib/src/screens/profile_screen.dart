import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.appState, super.key});

  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: <Widget>[
          SurfaceCard(
            child: Row(
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        BilooColors.royalBlue,
                        BilooColors.deepBlue,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'MA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Mahir Aman',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 19,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '+251 924 093 037',
                        style: TextStyle(color: BilooColors.muted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const _ProfileTile(
            icon: Icons.location_on_outlined,
            title: 'Saved addresses',
            subtitle: 'Home, work and delivery locations',
          ),
          const _ProfileTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Wallet and payments',
            subtitle: 'Cards, Telebirr, Chapa and cash',
          ),
          const _ProfileTile(
            icon: Icons.local_offer_outlined,
            title: 'Promotions',
            subtitle: 'Vouchers and referral rewards',
          ),
          const _ProfileTile(
            icon: Icons.support_agent_rounded,
            title: 'Help and support',
            subtitle: 'FAQs, live chat and order support',
          ),
          const SizedBox(height: 12),
          SurfaceCard(
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text(
                'Dark mode',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: const Text('Use a darker interface theme'),
              value: appState.isDarkMode,
              onChanged: (_) => appState.toggleTheme(),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: appState.signOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: BilooColors.danger,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Biloo Delivery • Foundation build 0.1.0',
              style: TextStyle(color: BilooColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        onTap: () {},
        child: Row(
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: BilooColors.skyBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: BilooColors.royalBlue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: BilooColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
