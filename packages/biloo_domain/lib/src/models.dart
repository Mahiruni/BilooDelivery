enum OrderStatus {
  pendingPayment,
  confirmed,
  preparing,
  readyForPickup,
  assigned,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
  paymentFailed,
  refunded,
}

enum PaymentMethod { cash, chapa, telebirr, card }

class Money {
  const Money(this.amount, {this.currency = 'ETB'});

  final double amount;
  final String currency;

  String get formatted => '$currency ${amount.toStringAsFixed(2)}';

  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies.');
    }
    return Money(amount + other.amount, currency: currency);
  }

  Money operator *(num multiplier) =>
      Money(amount * multiplier, currency: currency);
}

class FoodCategory {
  const FoodCategory({
    required this.id,
    required this.name,
    required this.emoji,
  });

  final String id;
  final String name;
  final String emoji;
}

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isPopular = false,
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final String description;
  final Money price;
  final String imageUrl;
  final bool isPopular;
  final bool isAvailable;
}

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryMinutes,
    required this.deliveryFee,
    required this.imageUrl,
    required this.menu,
    this.isOpen = true,
  });

  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int deliveryMinutes;
  final Money deliveryFee;
  final String imageUrl;
  final List<MenuItem> menu;
  final bool isOpen;
}

class CartLine {
  const CartLine({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  Money get total => item.price * quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(item: item, quantity: quantity ?? this.quantity);
}

class DeliveryAddress {
  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String label;
  final String formattedAddress;
  final double latitude;
  final double longitude;
}

class DeliveryOrder {
  const DeliveryOrder({
    required this.id,
    required this.orderNumber,
    required this.restaurant,
    required this.lines,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.createdAt,
    required this.estimatedArrival,
  });

  final String id;
  final String orderNumber;
  final Restaurant restaurant;
  final List<CartLine> lines;
  final OrderStatus status;
  final DeliveryAddress deliveryAddress;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime estimatedArrival;

  Money get subtotal => lines.fold(
        const Money(0),
        (Money total, CartLine line) => total + line.total,
      );

  Money get total => subtotal + restaurant.deliveryFee;

  DeliveryOrder copyWith({OrderStatus? status}) => DeliveryOrder(
        id: id,
        orderNumber: orderNumber,
        restaurant: restaurant,
        lines: lines,
        status: status ?? this.status,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        createdAt: createdAt,
        estimatedArrival: estimatedArrival,
      );
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
  });

  final String id;
  final String fullName;
  final String phone;
  final String email;
}
