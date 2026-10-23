import 'package:flutter/material.dart';
import 'payment_page.dart';

class SubscriptionPage extends StatefulWidget {
  final bool? isDark;

  const SubscriptionPage({super.key, this.isDark});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final bool currentThemeIsDark = widget.isDark ?? (Theme.of(context).brightness == Brightness.dark);

    final Color primaryGreen = currentThemeIsDark ? const Color(0xFF00E676) : const Color(0xFF00A859);
    final Color backgroundColor = currentThemeIsDark ? const Color(0xFF0D1117) : const Color(0xFFF5F6FA);
    final Color cardBg = currentThemeIsDark ? const Color(0xFF161D26) : Colors.white;
    final Color textColor = currentThemeIsDark ? Colors.white : const Color(0xFF2D3142);
    final Color borderColor = currentThemeIsDark ? Colors.white12 : Colors.grey.shade300;
    final Color unselectedButtonColor = currentThemeIsDark ? Colors.white24 : Colors.grey.shade200;
    final Color unselectedButtonTextColor = currentThemeIsDark ? Colors.white : const Color(0xFF2D3142);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'خرید اشتراک ویژه',
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildPlanCard(
              index: 0,
              title: 'اشتراک ۱ ماهه',
              price: '۹۹,۰۰۰ تومان',
              isBadge: false,
              primaryGreen: primaryGreen,
              cardBg: cardBg,
              textColor: textColor,
              borderColor: borderColor,
              unselectedButtonColor: unselectedButtonColor,
              unselectedButtonTextColor: unselectedButtonTextColor,
              currentThemeIsDark: currentThemeIsDark,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              index: 1,
              title: 'اشتراک ۳ ماهه (پیشنهاد ویژه)',
              price: '۲۴۹,۰۰۰ تومان',
              isBadge: true,
              primaryGreen: primaryGreen,
              cardBg: cardBg,
              textColor: textColor,
              borderColor: borderColor,
              unselectedButtonColor: unselectedButtonColor,
              unselectedButtonTextColor: unselectedButtonTextColor,
              currentThemeIsDark: currentThemeIsDark,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              index: 2,
              title: 'اشتراک ۱ ساله',
              price: '۷۹۰,۰۰۰ تومان',
              isBadge: false,
              primaryGreen: primaryGreen,
              cardBg: cardBg,
              textColor: textColor,
              borderColor: borderColor,
              unselectedButtonColor: unselectedButtonColor,
              unselectedButtonTextColor: unselectedButtonTextColor,
              currentThemeIsDark: currentThemeIsDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required bool isBadge,
    required Color primaryGreen,
    required Color cardBg,
    required Color textColor,
    required Color borderColor,
    required Color unselectedButtonColor,
    required Color unselectedButtonTextColor,
    required bool currentThemeIsDark,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryGreen : borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!currentThemeIsDark)
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (isBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('به صرفه', style: TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              price,
              style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? primaryGreen : unselectedButtonColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        planTitle: title,
                        planPrice: price,
                      ),
                    ),
                  );
                },
                child: Text(
                  isSelected ? 'انتخاب و پرداخت' : 'انتخاب',
                  style: TextStyle(
                    color: isSelected ? Colors.white : unselectedButtonTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}