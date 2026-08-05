import 'package:biloo_domain/biloo_domain.dart';
import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import '../widgets/network_food_image.dart';
import 'tracking_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    required this.appState,
    this.embedded = false,
    super.key,
  });

  final CustomerAppState appState;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final Widget body = AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        if (appState.cartLines.isEmpty) {
          return const _EmptyCart();
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
          children: <Widget>[
            SurfaceCard(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: BilooColors.skyBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: BilooColors.royalBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Deliver to Home',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Bole, Addis Ababa',
                          style: TextStyle(color: BilooColors.muted),
                        ),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Change')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              appState.cartRestaurant?.name ?? 'Your order',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 14),
            ...appState.cartLines.map(
              (CartLine line) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: NetworkFoodImage(url: line.item.imageUrl),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              line.item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              line.total.formatted,
                              style: const TextStyle(
                                color: BilooColors.royalBlue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: BilooColors.skyBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>
                                  appState.decrementItem(line.item.id),
                              icon: const Icon(Icons.remove_rounded),
                            ),
                            Text(
                              '${line.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>
                                  appState.incrementItem(line.item.id),
                              icon: const Icon(Icons.add_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const AppSectionHeader(title: 'Payment method'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: PaymentMethod.values.map((PaymentMethod method) {
                final bool selected = appState.paymentMethod == method;
                return ChoiceChip(
                  selected: selected,
                  onSelected: (_) => appState.setPaymentMethod(method),
                  avatar: Icon(_paymentIcon(method), size: 18),
                  label: Text(_paymentLabel(method)),
                );
              }).toList(growable: false),
            ),
            const SizedBox(height: 24),
            SurfaceCard(
              child: Column(
                children: <Widget>[
                  _PriceRow(label: 'Subtotal', value: appState.subtotal.formatted),
                  const SizedBox(height: 12),
                  _PriceRow(
                    label: 'Delivery fee',
                    value: appState.cartRestaurant!.deliveryFee.formatted,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(height: 1),
                  ),
                  _PriceRow(
                    label: 'Total',
                    value: appState.total.formatted,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    final Widget scaffold = Scaffold(
      appBar: embedded
          ? null
          : AppBar(
              title: const Text(
                'Your cart',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
      body: SafeArea(child: body),
      bottomNavigationBar: AnimatedBuilder(
        animation: appState,
        builder: (BuildContext context, Widget? child) {
          if (appState.cartLines.isEmpty) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: BilooButton(
              label: 'Place order • ${appState.total.formatted}',
              icon: Icons.lock_rounded,
              onPressed: () {
                final DeliveryOrder order = appState.placeOrder();
                if (embedded) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TrackingScreen(
                        appState: appState,
                        orderId: order.id,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => TrackingScreen(
                        appState: appState,
                        orderId: order.id,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );

    return embedded
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                'Your cart',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            body: scaffold.body,
            bottomNavigationBar: scaffold.bottomNavigationBar,
          )
        : scaffold;
  }

  static String _paymentLabel(PaymentMethod method) => switch (method) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.chapa => 'Chapa',
        PaymentMethod.telebirr => 'Telebirr',
        PaymentMethod.card => 'Card',
      };

  static IconData _paymentIcon(PaymentMethod method) => switch (method) {
        PaymentMethod.cash => Icons.payments_outlined,
        PaymentMethod.chapa => Icons.bolt_rounded,
        PaymentMethod.telebirr => Icons.phone_android_rounded,
        PaymentMethod.card => Icons.credit_card_rounded,
      };
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isTotal ? BilooColors.ink : BilooColors.muted,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
              fontSize: isTotal ? 17 : 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? BilooColors.royalBlue : BilooColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: BilooColors.skyBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 54,
                color: BilooColors.royalBlue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add something delicious from a restaurant near you.',
              textAlign: TextAlign.center,
              style: TextStyle(color: BilooColors.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
