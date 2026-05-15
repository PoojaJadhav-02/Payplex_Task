import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/order_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: _buildAmountCard(order.totalAmount),
            ),
            const SizedBox(height: 32),
            Text('Select Payment Method', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            FadeInLeft(child: _buildMethodTile('Cash', Icons.money_outlined)),
            const SizedBox(height: 12),
            FadeInLeft(delay: const Duration(milliseconds: 100), child: _buildMethodTile('UPI', Icons.qr_code_outlined)),
            const SizedBox(height: 12),
            FadeInLeft(delay: const Duration(milliseconds: 200), child: _buildMethodTile('Card', Icons.credit_card_outlined)),
            const Spacer(),
            FadeInUp(
              child: CustomButton(
                text: 'Confirm & Deliver',
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .updateOrderStatus(order.id, OrderStatus.delivered);
                  
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.success, size: 60),
                          const SizedBox(height: 16),
                          Text('Order Delivered!', style: AppTextStyles.h3),
                          const SizedBox(height: 8),
                          Text('Payment of ₹${order.totalAmount.toStringAsFixed(2)} received via $_selectedMethod.', textAlign: TextAlign.center),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Back to Dashboard',
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == '/dashboard');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(double amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Text('Total Bill Amount', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text('₹${amount.toStringAsFixed(2)}', style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 40)),
        ],
      ),
    );
  }

  Widget _buildMethodTile(String method, IconData icon) {
    bool isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 16),
            Text(method, style: AppTextStyles.bodyLarge.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected) const Icon(Icons.radio_button_checked, color: AppColors.primary)
            else const Icon(Icons.radio_button_off, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
