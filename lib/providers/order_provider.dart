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
        customerName: 'Pratiksha Patil',
        customerPhone: '+91 98765 43210',
        deliveryAddress: 'Flat 402, Shivajinagar, Pune, Maharashtra 411005',
        items: [
          OrderItem(name: 'Paneer Butter Masala', quantity: 2, price: 280.0),
          OrderItem(name: 'Butter Naan', quantity: 4, price: 45.0),
        ],
        totalAmount: 740.0,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: OrderStatus.pending,
      ),
      OrderModel(
        id: 'ORD002',
        customerName: 'Rahul Sharma',
        customerPhone: '+91 88888 77777',
        deliveryAddress: '12-B, Hiranandani Gardens, Powai, Mumbai 400076',
        items: [
          OrderItem(name: 'Chicken Dum Biryani', quantity: 1, price: 350.0),
          OrderItem(name: 'Thums Up (750ml)', quantity: 1, price: 40.0),
        ],
        totalAmount: 390.0,
        date: DateTime.now().subtract(const Duration(hours: 1)),
        status: OrderStatus.accepted,
      ),
      OrderModel(
        id: 'ORD003',
        customerName: 'Anita Desai',
        customerPhone: '+91 77777 66666',
        deliveryAddress: 'Plot 45, Sector 18, Vashi, Navi Mumbai 400703',
        items: [
          OrderItem(name: 'South Indian Platter', quantity: 1, price: 250.0),
        ],
        totalAmount: 250.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
      ),
    ];

    _offers = [
      OfferModel(
        id: 'OFF001',
        title: '50% OFF',
        description: 'Get 50% discount on your first delivery',
        code: 'WELCOME50',
        discount: '50%',
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=500',
      ),
      OfferModel(
        id: 'OFF002',
        title: 'Free Delivery',
        description: 'Free delivery on orders above ₹500',
        code: 'INDDEL',
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
