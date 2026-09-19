import 'package:biloo_domain/biloo_domain.dart';
import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

import '../state/customer_app_state.dart';
import '../widgets/network_food_image.dart';
import 'restaurant_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.appState, super.key});

  final CustomerAppState appState;

  static const List<_Category> _categories = <_Category>[
    _Category('Food', Icons.restaurant_rounded),
    _Category('Groceries', Icons.shopping_basket_rounded),
    _Category('Pharmacy', Icons.medication_rounded),
    _Category('Electronics', Icons.smartphone_rounded),
    _Category('Fashion', Icons.checkroom_rounded),
  ];

  static const List<_Product> _products = <_Product>[
    _Product(
      name: 'iPhone 15 Pro',
      subtitle: '128GB • Natural Titanium',
      price: 'Br 69,999',
      rating: '4.8',
      reviews: '342',
      discount: '-12%',
      imageUrl: 'https://images.unsplash.com/photo-1696446701796-da61225697cc?auto=format&fit=crop&w=700&q=85',
    ),
    _Product(
      name: 'Apple AirPods Pro',
      subtitle: '2nd Generation',
      price: 'Br 12,499',
      rating: '4.7',
      reviews: '189',
      discount: '-10%',
      imageUrl: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=700&q=85',
    ),
    _Product(
      name: 'Nike Air Force 1',
      subtitle: "Men's Sneakers",
      price: 'Br 8,999',
      rating: '4.6',
      reviews: '245',
      discount: '-15%',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=700&q=85',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: _HomeHeader(appState: appState)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 9),
                itemBuilder: (BuildContext context, int index) {
                  final _Category category = _categories[index];
                  final bool selected = index == 0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: selected ? BilooColors.deepBlue : Colors.white,
                      borderRadius: BorderRadius.circular(23),
                      border: Border.all(
                        color: selected ? BilooColors.deepBlue : const Color(0xFFE2E7EF),
                      ),
                      boxShadow: selected
                          ? const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x1A0B3B88),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          category.icon,
                          size: 18,
                          color: selected ? BilooColors.amber : BilooColors.deepBlue,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: selected ? Colors.white : BilooColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          sliver: SliverToBoxAdapter(child: _HeroBanner(appState: appState)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _SectionTitle(title: 'Featured Products', onSeeAll: () {}),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 294,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) => _ProductCard(
                  product: _products[index],
                  onAdd: () => _showAdded(context, _products[index].name),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _SectionTitle(title: 'Popular Restaurants & Stores', onSeeAll: () {}),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 222,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: appState.restaurants.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) {
                  final Restaurant restaurant = appState.restaurants[index];
                  return _StoreCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => RestaurantScreen(
                            restaurant: restaurant,
                            appState: appState,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 116),
          sliver: SliverToBoxAdapter(
            child: _TrackOrderCard(
              onTap: () => appState.setTab(3),
              colors: colors,
            ),
          ),
        ),
      ],
    );
  }

  void _showAdded(BuildContext context, String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$name added to your cart'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'View cart', onPressed: () => appState.setTab(2)),
        ),
      );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.appState});

  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 10, 20, 14),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: BilooColors.deepBlue,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'B',
                  style: TextStyle(color: BilooColors.amber, fontSize: 29, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  children: <InlineSpan>[
                    TextSpan(text: 'Biloo', style: TextStyle(color: BilooColors.deepBlue)),
                    TextSpan(text: 'App', style: TextStyle(color: BilooColors.amber)),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FB),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.location_on_rounded, size: 19, color: BilooColors.deepBlue),
                    SizedBox(width: 5),
                    Text('Addis Ababa', style: TextStyle(fontWeight: FontWeight.w700, color: BilooColors.ink)),
                    SizedBox(width: 3),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: BilooColors.ink),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: () {},
                icon: const Badge(
                  smallSize: 8,
                  backgroundColor: BilooColors.amber,
                  child: Icon(Icons.notifications_none_rounded, color: BilooColors.deepBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          TextField(
            onChanged: appState.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search for food, groceries, products and more...',
              hintStyle: const TextStyle(color: Color(0xFF6D7788), fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: BilooColors.deepBlue),
              filled: true,
              fillColor: const Color(0xFFF1F4F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.appState});

  final CustomerAppState appState;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[Color(0xFF082D69), BilooColors.royalBlue],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -8,
            top: 0,
            bottom: 0,
            width: 185,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
              child: NetworkFoodImage(
                url: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=900&q=85',
              ),
            ),
          ),
          Container(
            width: 235,
            padding: const EdgeInsets.fromLTRB(18, 18, 8, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xCC082D69), Color(0x00082D69)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('FAST & FRESH', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                const SizedBox(height: 5),
                const Text('Your Favorite\nFood, Delivered', style: TextStyle(color: Colors.white, fontSize: 24, height: 1.05, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                const Text('From top restaurants to your door.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                const Spacer(),
                FilledButton(
                  onPressed: () => appState.setTab(0),
                  style: FilledButton.styleFrom(backgroundColor: BilooColors.amber, foregroundColor: Colors.white, minimumSize: const Size(112, 38)),
                  child: const Text('Order Now', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 18,
            bottom: 10,
            child: Row(
              children: <Widget>[
                _Dot(active: true),
                SizedBox(width: 6),
                _Dot(active: false),
                SizedBox(width: 6),
                _Dot(active: false),
                SizedBox(width: 6),
                _Dot(active: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAdd});

  final _Product product;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E8EF)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x0D10233F), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 104,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: NetworkFoodImage(url: product.imageUrl),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: BilooColors.amber, borderRadius: BorderRadius.circular(8)),
                      child: Text(product.discount, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: BilooColors.ink, fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 2),
              Text(product.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: BilooColors.muted, fontSize: 10)),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  const Icon(Icons.star_rounded, color: BilooColors.amber, size: 15),
                  const SizedBox(width: 2),
                  Text('${product.rating} (${product.reviews})', style: const TextStyle(color: BilooColors.muted, fontSize: 10, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 3),
              Text(product.price, style: const TextStyle(color: BilooColors.ink, fontSize: 16, fontWeight: FontWeight.w900)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 34,
                child: FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.shopping_cart_outlined, size: 14),
                  label: const Text('Add to cart', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                  style: FilledButton.styleFrom(backgroundColor: BilooColors.deepBlue, foregroundColor: Colors.white, padding: EdgeInsets.zero),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.restaurant, required this.onTap});

  final Restaurant restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 174,
      child: SurfaceCard(
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 102,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  NetworkFoodImage(url: restaurant.imageUrl),
                  Positioned(
                    right: 7,
                    top: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(color: BilooColors.amber, borderRadius: BorderRadius.circular(9)),
                      child: const Text('Popular', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(restaurant.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: BilooColors.ink)),
                  const SizedBox(height: 2),
                  Text(restaurant.cuisine, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: BilooColors.muted)),
                  const SizedBox(height: 7),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.star_rounded, size: 14, color: BilooColors.amber),
                      const SizedBox(width: 2),
                      Text('${restaurant.rating}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 9),
                      const Icon(Icons.schedule_rounded, size: 14, color: BilooColors.muted),
                      const SizedBox(width: 2),
                      Text('${restaurant.deliveryMinutes}–${restaurant.deliveryMinutes + 5} min', style: const TextStyle(fontSize: 10, color: BilooColors.muted)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackOrderCard extends StatelessWidget {
  const _TrackOrderCard({required this.onTap, required this.colors});

  final VoidCallback onTap;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 10, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: <Color>[Color(0xFF0B3B88), BilooColors.royalBlue]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x220B3B88), blurRadius: 16, offset: Offset(0, 7))],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.14), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 27),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Track Your Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                SizedBox(height: 3),
                Text('Get real-time updates on your delivery', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
          FilledButton(
            onPressed: onTap,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              foregroundColor: WidgetStatePropertyAll(BilooColors.amber),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 13)),
            ),
            child: const Text('Track Order', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: const TextStyle(color: BilooColors.ink, fontSize: 19, fontWeight: FontWeight.w900))),
        TextButton.icon(
          onPressed: onSeeAll,
          icon: const Icon(Icons.arrow_forward_rounded, size: 15),
          label: const Text('See all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          style: TextButton.styleFrom(foregroundColor: BilooColors.amber, padding: EdgeInsets.zero),
          iconAlignment: IconAlignment.end,
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
        width: active ? 17 : 7,
        height: 7,
        decoration: BoxDecoration(color: active ? BilooColors.amber : Colors.white70, borderRadius: BorderRadius.circular(10)),
      );
}

class _Category {
  const _Category(this.name, this.icon);
  final String name;
  final IconData icon;
}

class _Product {
  const _Product({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.discount,
    required this.imageUrl,
  });

  final String name;
  final String subtitle;
  final String price;
  final String rating;
  final String reviews;
  final String discount;
  final String imageUrl;
}
