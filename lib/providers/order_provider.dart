import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/offer_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  List<OfferModel> _offers = [];
  final bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  List<OrderModel> get activeOrders => _orders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).toList();
  List<OrderModel> get orderHistory => _orders.where((o) => o.status == OrderStatus.delivered || o.status == OrderStatus.cancelled).toList();
  List<OfferModel> get offers => _offers;
  bool get isLoading => _isLoading;

  OrderProvider() {
    _loadDummyData();
  }

  void _loadDummyData() {
    _orders = [
      OrderModel(
        id: 'ORD001',
        customerName: 'Alice Johnson',
        customerPhone: '+1 987 654 321',
        deliveryAddress: '123 Main St, New York, NY 10001',
        items: [
          OrderItem(name: 'Margherita Pizza', quantity: 2, price: 15.0),
          OrderItem(name: 'Coke', quantity: 1, price: 2.5),
        ],
        totalAmount: 32.5,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: OrderStatus.pending,
      ),
      OrderModel(
        id: 'ORD002',
        customerName: 'Bob Smith',
        customerPhone: '+1 555 444 333',
        deliveryAddress: '456 Elm St, Brooklyn, NY 11201',
        items: [
          OrderItem(name: 'Chicken Burger', quantity: 1, price: 12.0),
          OrderItem(name: 'French Fries', quantity: 1, price: 4.5),
        ],
        totalAmount: 16.5,
        date: DateTime.now().subtract(const Duration(hours: 1)),
        status: OrderStatus.accepted,
      ),
      OrderModel(
        id: 'ORD003',
        customerName: 'Charlie Brown',
        customerPhone: '+1 111 222 333',
        deliveryAddress: '789 Oak Ave, Queens, NY 11375',
        items: [
          OrderItem(name: 'Sushi Platter', quantity: 1, price: 45.0),
        ],
        totalAmount: 45.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
      ),
    ];

    _offers = [
      OfferModel(
        id: 'OFF001',
        title: '50% OFF',
        description: 'Get 50% discount on your first delivery',
        code: 'FIRST50',
        discount: '50%',
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=500',
      ),
      OfferModel(
        id: 'OFF002',
        title: 'Free Delivery',
        description: 'Free delivery on orders above ₹50',
        code: 'FREEDEL',
        discount: 'Free',
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&q=80&w=500',
      ),
    ];
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      notifyListeners();
    }
  }

  List<OrderModel> searchHistory(String query) {
    if (query.isEmpty) return orderHistory;
    return orderHistory.where((o) => 
      o.id.toLowerCase().contains(query.toLowerCase()) || 
      o.customerName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
