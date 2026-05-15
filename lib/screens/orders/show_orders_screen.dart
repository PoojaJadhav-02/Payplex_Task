import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order_card.dart';
import '../../utils/routes.dart';
import '../../models/order_model.dart';

class ShowOrdersScreen extends StatelessWidget {
  const ShowOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Orders', style: AppTextStyles.h3),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = orderProvider.activeOrders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 80, color: AppColors.textTertiary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('No active orders found', style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return FadeInLeft(
                delay: Duration(milliseconds: 100 * index),
                child: OrderCard(
                  order: order,
                  onTap: () => Navigator.pushNamed(
                    context, 
                    AppRoutes.orderDetails,
                    arguments: order,
                  ),
                  onAccept: order.status == OrderStatus.pending 
                    ? () => orderProvider.updateOrderStatus(order.id, OrderStatus.accepted)
                    : null,
                  onReject: order.status == OrderStatus.pending 
                    ? () => orderProvider.updateOrderStatus(order.id, OrderStatus.cancelled)
                    : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
