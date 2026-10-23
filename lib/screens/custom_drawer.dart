import 'package:flutter/material.dart';

import 'artists_page.dart';
import 'subscription_page.dart';

import 'main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;


    final Color drawerBg = isDark ? const Color(0xFF0D1117) : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF161D26) : Colors.grey[100]!;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.white12 : Colors.grey[300]!;

    return Drawer(
      backgroundColor: drawerBg,
      width: MediaQuery.of(context).size.width * 0.85,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: textColor, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'MOVIEVERSE',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.play_circle_fill, color: primaryGreen, size: 28),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),


              InkWell(
                onTap: () async {
                  Navigator.pop(context);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SubscriptionPage(isDark: isDark)),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: primaryGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.workspace_premium, color: primaryGreen, size: 22),
                      ),
                      const Spacer(),
                      Text(
                        'خرید اشتراک',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.stars_rounded, color: primaryGreen, size: 26),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),


              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [

                    _buildCapsuleButton(
                      title: 'هنرمندان',
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ArtistsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),


                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: themeNotifier,
                      builder: (context, currentMode, child) {
                        bool isDarkTheme = currentMode == ThemeMode.dark;
                        return _buildCapsuleButton(
                          title: isDarkTheme ? 'حالت روشن (Light Mode)' : 'حالت تاریک (Dark Mode)',
                          cardBg: cardBg,
                          textColor: textColor,
                          onTap: () {

                            setThemeMode(isDarkTheme ? ThemeMode.light : ThemeMode.dark);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),


                    _buildSocialTile(
                      title: 'پیج اینستاگرام',
                      customIcon: _buildInstagramIcon(primaryGreen),
                      textColor: textColor,
                      primaryGreen: primaryGreen,
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _buildSocialTile(
                      title: 'کانال تلگرام',
                      customIcon: Icon(Icons.send_rounded, color: primaryGreen, size: 18),
                      textColor: textColor,
                      primaryGreen: primaryGreen,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapsuleButton({
    required String title,
    required Color cardBg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _buildSocialTile({
    required String title,
    required Widget customIcon,
    required Color textColor,
    required Color primaryGreen,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: primaryGreen.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: customIcon,
        ),
      ),
    );
  }


  Widget _buildInstagramIcon(Color primaryGreen) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        border: Border.all(color: primaryGreen, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            border: Border.all(color: primaryGreen, width: 1.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}