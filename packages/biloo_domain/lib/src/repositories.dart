import 'models.dart';

abstract interface class AuthRepository {
  Stream<UserProfile?> watchSession();
  Future<UserProfile> signInWithPhone(String phone);
  Future<void> signOut();
}

abstract interface class CatalogRepository {
  Future<List<FoodCategory>> getCategories();
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurant(String restaurantId);
}

abstract interface class OrderRepository {
  Stream<List<DeliveryOrder>> watchOrders();
  Stream<DeliveryOrder> watchOrder(String orderId);
  Future<DeliveryOrder> placeOrder({
    required Restaurant restaurant,
    required List<CartLine> lines,
    required DeliveryAddress address,
    required PaymentMethod paymentMethod,
  });
  Future<void> cancelOrder(String orderId);
}

abstract interface class LocationRepository {
  Future<DeliveryAddress> getCurrentAddress();
  Stream<(double latitude, double longitude)> watchDriverLocation(
    String orderId,
  );
}

abstract interface class PaymentRepository {
  Future<String> createPaymentSession({
    required DeliveryOrder order,
    required PaymentMethod method,
  });
}

abstract interface class NotificationRepository {
  Future<void> registerDevice();
  Future<void> unregisterDevice();
}
