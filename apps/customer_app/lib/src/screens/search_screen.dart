import 'package:biloo_domain/biloo_domain.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import '../widgets/network_food_image.dart';
import 'restaurant_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({required this.appState, super.key});

  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    final List<Restaurant> restaurants = appState.restaurants;
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text('Search', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            sliver: SliverToBoxAdapter(
              child: TextField(
                autofocus: false,
                onChanged: appState.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search food, groceries, products and more...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: const Color(0xFFF1F4F9),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          if (restaurants.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No restaurants or stores found.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
              sliver: SliverList.separated(
                itemCount: restaurants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final Restaurant restaurant = restaurants[index];
                  return _SearchResult(
                    restaurant: restaurant,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RestaurantScreen(restaurant: restaurant, appState: appState),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({required this.restaurant, required this.onTap});

  final Restaurant restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              SizedBox(width: 84, height: 84, child: ClipRRect(borderRadius: BorderRadius.circular(14), child: NetworkFoodImage(url: restaurant.imageUrl))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(restaurant.cuisine, style: const TextStyle(color: Color(0xFF6D7788), fontSize: 12)),
                    const SizedBox(height: 9),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFCA311)),
                        const SizedBox(width: 3),
                        Text('${restaurant.rating}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                        const SizedBox(width: 12),
                        const Icon(Icons.schedule_rounded, size: 15, color: Color(0xFF6D7788)),
                        const SizedBox(width: 3),
                        Text('${restaurant.deliveryMinutes} min', style: const TextStyle(color: Color(0xFF6D7788), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
