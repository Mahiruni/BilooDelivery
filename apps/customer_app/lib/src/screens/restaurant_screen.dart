import 'package:biloo_domain/biloo_domain.dart';
import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import '../widgets/network_food_image.dart';
import 'cart_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({
    required this.restaurant,
    required this.appState,
    super.key,
  });

  final Restaurant restaurant;
  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            expandedHeight: 270,
            pinned: true,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  shadows: <Shadow>[Shadow(blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  NetworkFoodImage(url: restaurant.imageUrl),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      StatusPill(
                        label: '${restaurant.rating} rating',
                        color: BilooColors.amber,
                        icon: Icons.star_rounded,
                      ),
                      StatusPill(
                        label: '${restaurant.deliveryMinutes} min',
                        color: BilooColors.royalBlue,
                        icon: Icons.schedule_rounded,
                      ),
                      StatusPill(
                        label: restaurant.deliveryFee.formatted,
                        color: BilooColors.success,
                        icon: Icons.delivery_dining_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const AppSectionHeader(title: 'Popular dishes'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList.separated(
              itemCount: restaurant.menu.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (BuildContext context, int index) {
                final MenuItem item = restaurant.menu[index];
                return SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          width: 98,
                          height: 98,
                          child: NetworkFoodImage(url: item.imageUrl),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (item.isPopular)
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: BilooColors.amber,
                                    size: 20,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: BilooColors.muted,
                                height: 1.35,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    item.price.formatted,
                                    style: const TextStyle(
                                      color: BilooColors.royalBlue,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: () =>
                                      appState.addItem(restaurant, item),
                                  icon: const Icon(Icons.add_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: appState,
        builder: (BuildContext context, Widget? child) {
          if (appState.cartQuantity == 0) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: BilooButton(
              label:
                  'View cart • ${appState.cartQuantity} • ${appState.total.formatted}',
              icon: Icons.shopping_bag_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CartScreen(appState: appState),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
