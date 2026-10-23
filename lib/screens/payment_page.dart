import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String planTitle;
  final String planPrice;

  const PaymentPage({
    super.key,
    required this.planTitle,
    required this.planPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedGateway = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF0F1017) : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF1E2630) : Colors.grey[100]!;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white54 : Colors.black54;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تکمیل خرید اشتراک',
          style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جزئیات سفارش',
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.planTitle,
                    style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // اصلاح شد
                    children: [
                      Text('مبلغ قابل پرداخت:', style: TextStyle(color: subTextColor)),
                      Text(
                        widget.planPrice,
                        style: TextStyle(color: primaryGreen, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'انتخاب درگاه پرداخت',
              style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildGatewayOption(
              id: 1,
              title: 'درگاه امن زرین‌پال',
              subtitle: 'پرداخت با تمامی کارت‌های شتابی',
              icon: Icons.shield_outlined,
              cardBg: cardBg,
              textColor: textColor,
              subTextColor: subTextColor,
              primaryGreen: primaryGreen,
            ),
            const SizedBox(height: 12),

            _buildGatewayOption(
              id: 2,
              title: 'کیف پول MovieVerse',
              subtitle: 'موجودی: ۲۵,۰۰۰ تومان',
              icon: Icons.account_balance_wallet_outlined,
              cardBg: cardBg,
              textColor: textColor,
              subTextColor: subTextColor,
              primaryGreen: primaryGreen,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                  setState(() => _isLoading = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (!mounted) return; // حل مشکل هشدار context
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('پرداخت با موفقیت انجام شد!')),
                    );
                    Navigator.pop(context);
                  });
                },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'اتصال به درگاه پرداخت و خرید',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildGatewayOption({
    required int id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color cardBg,
    required Color textColor,
    required Color subTextColor,
    required Color primaryGreen,
  }) {
    final bool isSelected = _selectedGateway == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedGateway = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primaryGreen : subTextColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 12)),
                ],
              ),
            ),
            Radio<int>(
              value: id,
              groupValue: _selectedGateway,
              activeColor: primaryGreen,
              onChanged: (value) => setState(() => _selectedGateway = value!),
            ),
          ],
        ),
      ),
    );
  }
}