import 'package:biloo_domain/biloo_domain.dart';
import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({
    required this.appState,
    required this.orderId,
    super.key,
  });

  final CustomerAppState appState;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        final DeliveryOrder order = appState.orders.firstWhere(
          (DeliveryOrder item) => item.id == orderId,
        );
        final int activeIndex = _progressIndex(order.status);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              order.orderNumber,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: <Widget>[
              Container(
                height: 290,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFFE9F0FF), Color(0xFFF8F9FC)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: BilooColors.line),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CustomPaint(painter: const _RoutePainter()),
                    ),
                    const Positioned(
                      left: 38,
                      bottom: 44,
                      child: _MapMarker(
                        icon: Icons.restaurant_rounded,
                        color: BilooColors.amber,
                      ),
                    ),
                    const Positioned(
                      right: 38,
                      top: 40,
                      child: _MapMarker(
                        icon: Icons.home_rounded,
                        color: BilooColors.royalBlue,
                      ),
                    ),
                    Positioned(
                      left: 138,
                      top: 124,
                      child: Transform.rotate(
                        angle: -0.35,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: BilooColors.deepBlue,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: BilooColors.deepBlue.withOpacity(0.28),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.delivery_dining_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SurfaceCard(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: BilooColors.skyBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: BilooColors.royalBlue,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Abel M.',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Driver • 4.9 ★ • Blue motorcycle',
                            style: TextStyle(color: BilooColors.muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.phone_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                order.status == OrderStatus.delivered
                    ? 'Delivered successfully'
                    : 'Estimated arrival ${order.estimatedArrival.hour.toString().padLeft(2, '0')}:${order.estimatedArrival.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                _statusDescription(order.status),
                style: const TextStyle(color: BilooColors.muted, height: 1.5),
              ),
              const SizedBox(height: 20),
              SurfaceCard(
                child: Column(
                  children: List<Widget>.generate(
                    _steps.length,
                    (int index) {
                      final bool complete = index <= activeIndex;
                      return _ProgressStep(
                        title: _steps[index],
                        complete: complete,
                        isLast: index == _steps.length - 1,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: order.status == OrderStatus.delivered
                    ? null
                    : () => appState.advanceOrder(order.id),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Advance demo status'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static const List<String> _steps = <String>[
    'Order confirmed',
    'Restaurant is preparing',
    'Driver picked up the order',
    'Order is on the way',
    'Delivered',
  ];

  static int _progressIndex(OrderStatus status) => switch (status) {
        OrderStatus.pendingPayment || OrderStatus.confirmed => 0,
        OrderStatus.preparing || OrderStatus.readyForPickup => 1,
        OrderStatus.assigned || OrderStatus.pickedUp => 2,
        OrderStatus.onTheWay => 3,
        OrderStatus.delivered => 4,
        _ => 0,
      };

  static String _statusDescription(OrderStatus status) => switch (status) {
        OrderStatus.confirmed => 'The restaurant has received your order.',
        OrderStatus.preparing => 'Your meal is being prepared with care.',
        OrderStatus.readyForPickup => 'The order is packed and ready.',
        OrderStatus.assigned => 'A driver is heading to the restaurant.',
        OrderStatus.pickedUp => 'Your driver has collected the order.',
        OrderStatus.onTheWay => 'Your order is moving toward your address.',
        OrderStatus.delivered => 'Enjoy your meal and rate the experience.',
        _ => 'We are processing the latest order update.',
      };
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({
    required this.title,
    required this.complete,
    required this.isLast,
  });

  final String title;
  final bool complete;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: complete ? BilooColors.royalBlue : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: complete ? BilooColors.royalBlue : BilooColors.line,
                  width: 2,
                ),
              ),
              child: complete
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: complete ? BilooColors.royalBlue : BilooColors.line,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: complete ? FontWeight.w800 : FontWeight.w600,
                color: complete ? BilooColors.ink : BilooColors.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint grid = Paint()
      ..color = BilooColors.line.withOpacity(0.75)
      ..strokeWidth = 1;
    for (double x = 20; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 20; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final Path route = Path()
      ..moveTo(58, size.height - 62)
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.68,
        size.width * 0.55,
        size.height * 0.58,
        size.width - 62,
        62,
      );
    final Paint routePaint = Paint()
      ..color = BilooColors.royalBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
