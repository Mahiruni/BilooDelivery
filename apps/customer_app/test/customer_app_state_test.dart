import 'package:biloo_customer_app/src/data/mock_catalog.dart';
import 'package:biloo_customer_app/src/state/customer_app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adding an item updates cart quantity and totals', () {
    final CustomerAppState state = CustomerAppState();
    final restaurant = MockCatalog.restaurants.first;
    final item = restaurant.menu.first;

    state.addItem(restaurant, item);
    state.addItem(restaurant, item);

    expect(state.cartQuantity, 2);
    expect(state.subtotal.amount, item.price.amount * 2);
    expect(
      state.total.amount,
      item.price.amount * 2 + restaurant.deliveryFee.amount,
    );
  });

  test('placing an order clears the cart and stores the order', () {
    final CustomerAppState state = CustomerAppState();
    final restaurant = MockCatalog.restaurants.first;

    state.addItem(restaurant, restaurant.menu.first);
    final order = state.placeOrder();

    expect(state.cartQuantity, 0);
    expect(state.orders.single.id, order.id);
    expect(order.restaurant.id, restaurant.id);
  });
}
