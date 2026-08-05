import 'package:biloo_domain/biloo_domain.dart';
import 'package:flutter/material.dart';

import '../data/mock_catalog.dart';

class CustomerAppState extends ChangeNotifier {
  bool hasCompletedOnboarding = false;
  bool isSignedIn = false;
  bool isDarkMode = false;
  int selectedTab = 0;
  String searchQuery = '';
  String selectedCategoryId = 'all';
  Restaurant? cartRestaurant;
  PaymentMethod paymentMethod = PaymentMethod.cash;

  final Map<String, CartLine> _cart = <String, CartLine>{};
  final List<DeliveryOrder> _orders = <DeliveryOrder>[];

  List<FoodCategory> get categories => MockCatalog.categories;
  List<Restaurant> get restaurants {
    final String query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return MockCatalog.restaurants;
    }
    return MockCatalog.restaurants
        .where(
          (Restaurant restaurant) =>
              restaurant.name.toLowerCase().contains(query) ||
              restaurant.cuisine.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  List<CartLine> get cartLines => _cart.values.toList(growable: false);
  List<DeliveryOrder> get orders => List<DeliveryOrder>.unmodifiable(_orders);
  int get cartQuantity => _cart.values.fold(
        0,
        (int total, CartLine line) => total + line.quantity,
      );
  Money get subtotal => _cart.values.fold(
        const Money(0),
        (Money total, CartLine line) => total + line.total,
      );
  Money get total => cartRestaurant == null
      ? subtotal
      : subtotal + cartRestaurant!.deliveryFee;

  void completeOnboarding() {
    hasCompletedOnboarding = true;
    notifyListeners();
  }

  void signIn(String phone) {
    if (phone.trim().isEmpty) {
      return;
    }
    isSignedIn = true;
    notifyListeners();
  }

  void signOut() {
    isSignedIn = false;
    selectedTab = 0;
    notifyListeners();
  }

  void setTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setCategory(String categoryId) {
    selectedCategoryId = categoryId;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void addItem(Restaurant restaurant, MenuItem item) {
    if (cartRestaurant != null && cartRestaurant!.id != restaurant.id) {
      _cart.clear();
    }
    cartRestaurant = restaurant;
    final CartLine? existing = _cart[item.id];
    _cart[item.id] = CartLine(
      item: item,
      quantity: (existing?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

  void incrementItem(String itemId) {
    final CartLine? line = _cart[itemId];
    if (line == null) {
      return;
    }
    _cart[itemId] = line.copyWith(quantity: line.quantity + 1);
    notifyListeners();
  }

  void decrementItem(String itemId) {
    final CartLine? line = _cart[itemId];
    if (line == null) {
      return;
    }
    if (line.quantity <= 1) {
      _cart.remove(itemId);
    } else {
      _cart[itemId] = line.copyWith(quantity: line.quantity - 1);
    }
    if (_cart.isEmpty) {
      cartRestaurant = null;
    }
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    paymentMethod = method;
    notifyListeners();
  }

  DeliveryOrder placeOrder() {
    final Restaurant restaurant = cartRestaurant!;
    final DateTime now = DateTime.now();
    final DeliveryOrder order = DeliveryOrder(
      id: 'order-${now.microsecondsSinceEpoch}',
      orderNumber: 'BL-${now.millisecondsSinceEpoch.toString().substring(6)}',
      restaurant: restaurant,
      lines: cartLines,
      status: OrderStatus.confirmed,
      deliveryAddress: const DeliveryAddress(
        id: 'address-home',
        label: 'Home',
        formattedAddress: 'Bole, Addis Ababa',
        latitude: 8.9806,
        longitude: 38.7578,
      ),
      paymentMethod: paymentMethod,
      createdAt: now,
      estimatedArrival: now.add(
        Duration(minutes: restaurant.deliveryMinutes),
      ),
    );
    _orders.insert(0, order);
    _cart.clear();
    cartRestaurant = null;
    selectedTab = 2;
    notifyListeners();
    return order;
  }

  void advanceOrder(String orderId) {
    final int index = _orders.indexWhere(
      (DeliveryOrder order) => order.id == orderId,
    );
    if (index < 0) {
      return;
    }
    const List<OrderStatus> progress = <OrderStatus>[
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.readyForPickup,
      OrderStatus.assigned,
      OrderStatus.pickedUp,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];
    final int current = progress.indexOf(_orders[index].status);
    if (current >= 0 && current < progress.length - 1) {
      _orders[index] = _orders[index].copyWith(status: progress[current + 1]);
      notifyListeners();
    }
  }
}
