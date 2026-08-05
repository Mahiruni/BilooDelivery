import 'package:biloo_domain/biloo_domain.dart';
import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import 'tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({required this.appState, super.key});

  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (BuildContext context, Widget? child) {
          if (appState.orders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Your active and past orders will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BilooColors.muted, fontSize: 16),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            itemCount: appState.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (BuildContext context, int index) {
              final DeliveryOrder order = appState.orders[index];
              return SurfaceCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TrackingScreen(
                        appState: appState,
                        orderId: order.id,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                order.restaurant.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.orderNumber,
                                style: const TextStyle(
                                  color: BilooColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusPill(
                          label: _statusLabel(order.status),
                          color: order.status == OrderStatus.delivered
                              ? BilooColors.success
                              : BilooColors.royalBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${order.lines.length} items • ${order.total.formatted}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  static String _statusLabel(OrderStatus status) => switch (status) {
        OrderStatus.pendingPayment => 'Payment pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.readyForPickup => 'Ready',
        OrderStatus.assigned => 'Driver assigned',
        OrderStatus.pickedUp => 'Picked up',
        OrderStatus.onTheWay => 'On the way',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
        OrderStatus.paymentFailed => 'Payment failed',
        OrderStatus.refunded => 'Refunded',
      };
}
