import 'package:biloo_domain/biloo_domain.dart';

abstract final class MockCatalog {
  static const List<FoodCategory> categories = <FoodCategory>[
    FoodCategory(id: 'all', name: 'All', emoji: '✨'),
    FoodCategory(id: 'burger', name: 'Burgers', emoji: '🍔'),
    FoodCategory(id: 'pizza', name: 'Pizza', emoji: '🍕'),
    FoodCategory(id: 'habesha', name: 'Habesha', emoji: '🍲'),
    FoodCategory(id: 'healthy', name: 'Healthy', emoji: '🥗'),
    FoodCategory(id: 'coffee', name: 'Coffee', emoji: '☕'),
  ];

  static const List<Restaurant> restaurants = <Restaurant>[
    Restaurant(
      id: 'r-abyssinia',
      name: 'Abyssinia Kitchen',
      cuisine: 'Ethiopian • Traditional',
      rating: 4.8,
      deliveryMinutes: 28,
      deliveryFee: Money(45),
      imageUrl:
          'https://images.unsplash.com/photo-1567364816519-cbc9d3b8cbd9?auto=format&fit=crop&w=1200&q=80',
      menu: <MenuItem>[
        MenuItem(
          id: 'm-doro',
          name: 'Doro Wot',
          description: 'Slow-cooked chicken stew, egg, injera and house spices.',
          price: Money(420),
          imageUrl:
              'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=80',
          isPopular: true,
        ),
        MenuItem(
          id: 'm-beyaynetu',
          name: 'Special Beyaynetu',
          description: 'A vibrant selection of vegan stews served with injera.',
          price: Money(310),
          imageUrl:
              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80',
        ),
        MenuItem(
          id: 'm-tibs',
          name: 'Shekla Tibs',
          description: 'Sizzling beef, rosemary, onion and green pepper.',
          price: Money(490),
          imageUrl:
              'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=80',
          isPopular: true,
        ),
      ],
    ),
    Restaurant(
      id: 'r-burger',
      name: 'Biloo Burger Lab',
      cuisine: 'Burgers • American',
      rating: 4.7,
      deliveryMinutes: 22,
      deliveryFee: Money(35),
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1200&q=80',
      menu: <MenuItem>[
        MenuItem(
          id: 'm-classic',
          name: 'Biloo Classic',
          description: 'Double smashed beef, cheddar, pickles and Biloo sauce.',
          price: Money(360),
          imageUrl:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=900&q=80',
          isPopular: true,
        ),
        MenuItem(
          id: 'm-chicken',
          name: 'Crispy Chicken',
          description: 'Buttermilk chicken, slaw, spicy mayo and brioche.',
          price: Money(330),
          imageUrl:
              'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=900&q=80',
        ),
        MenuItem(
          id: 'm-fries',
          name: 'Loaded Fries',
          description: 'Crispy fries with cheese sauce, jalapeño and herbs.',
          price: Money(190),
          imageUrl:
              'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=900&q=80',
        ),
      ],
    ),
    Restaurant(
      id: 'r-green',
      name: 'Green Bowl',
      cuisine: 'Healthy • Salads',
      rating: 4.9,
      deliveryMinutes: 20,
      deliveryFee: Money(30),
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=1200&q=80',
      menu: <MenuItem>[
        MenuItem(
          id: 'm-avocado',
          name: 'Avocado Power Bowl',
          description: 'Avocado, quinoa, chickpeas, greens and citrus dressing.',
          price: Money(340),
          imageUrl:
              'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=900&q=80',
          isPopular: true,
        ),
        MenuItem(
          id: 'm-chicken-bowl',
          name: 'Grilled Chicken Bowl',
          description: 'Herb chicken, brown rice, seasonal vegetables and tahini.',
          price: Money(390),
          imageUrl:
              'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=80',
        ),
      ],
    ),
  ];
}
