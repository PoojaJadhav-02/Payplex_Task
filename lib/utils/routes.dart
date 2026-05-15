import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/orders/show_orders_screen.dart';
import '../screens/orders/order_details_screen.dart';
import '../screens/orders/payment_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/offers/offers_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String showOrders = '/show-orders';
  static const String orderDetails = '/order-details';
  static const String payment = '/payment';
  static const String history = '/history';
  static const String offers = '/offers';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    dashboard: (context) => const DashboardScreen(),
    showOrders: (context) => const ShowOrdersScreen(),
    orderDetails: (context) => const OrderDetailsScreen(),
    payment: (context) => const PaymentScreen(),
    history: (context) => const HistoryScreen(),
    offers: (context) => const OffersScreen(),
  };
}
