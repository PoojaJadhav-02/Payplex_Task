import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/order_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../utils/routes.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details #${order.id}', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(child: _buildStatusSection(order)),
            const SizedBox(height: 24),
            FadeInLeft(child: _buildCustomerSection(order)),
            const SizedBox(height: 24),
            FadeInRight(child: _buildItemsSection(order)),
            const SizedBox(height: 24),
            FadeInUp(child: _buildSummarySection(order)),
            const SizedBox(height: 40),
            if (order.status == OrderStatus.accepted)
              CustomButton(
                text: 'Mark as On The Way',
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .updateOrderStatus(order.id, OrderStatus.onTheWay);
                  Navigator.pop(context);
                },
              )
            else if (order.status == OrderStatus.onTheWay)
              CustomButton(
                text: 'Confirm Payment & Deliver',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.payment, arguments: order);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildTimelineItem('Order Placed', 'Confirmed at ${DateFormat('hh:mm a').format(order.date)}', true),
          _buildTimelineItem('Accepted', order.status != OrderStatus.pending ? 'Picked up by you' : 'Waiting...', order.status != OrderStatus.pending),
          _buildTimelineItem('On the way', order.status == OrderStatus.onTheWay || order.status == OrderStatus.delivered ? 'Heading to destination' : 'Upcoming', order.status == OrderStatus.onTheWay || order.status == OrderStatus.delivered),
          _buildTimelineItem('Delivered', order.status == OrderStatus.delivered ? 'Success' : 'Upcoming', order.status == OrderStatus.delivered, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDone ? AppColors.primary : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isDone ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isDone ? AppColors.primary : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: isDone ? AppColors.textPrimary : AppColors.textTertiary)),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSection(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Details', style: AppTextStyles.h3.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(Icons.person_outline, 'Name', order.customerName),
                const Divider(height: 24),
                _buildInfoRow(Icons.phone_outlined, 'Phone', order.customerPhone),
                const Divider(height: 24),
                _buildInfoRow(Icons.location_on_outlined, 'Address', order.deliveryAddress),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Items', style: AppTextStyles.h3.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return ListTile(
                title: Text(item.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text('Qty: ${item.quantity}', style: AppTextStyles.bodySmall),
                trailing: Text('₹${(item.price * item.quantity).toStringAsFixed(2)}', style: AppTextStyles.bodyMedium),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(OrderModel order) {
    return Card(
      color: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Amount', style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
            Text(
              '₹${order.totalAmount.toStringAsFixed(2)}',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
