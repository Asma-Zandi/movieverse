import 'package:flutter/material.dart';
import 'account_page.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;


    final Color navBg = isDark ? const Color(0xFF0B0E12) : Colors.white;
    final Color activeBgColor = isDark ? const Color(0xFF1E2630) : Colors.grey[200]!;
    final Color activeColor = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859); // سبز تیره برای حالت روشن، سبز روشن برای تاریک
    final Color inactiveColor = isDark ? const Color(0xFF8E99A6) : Colors.grey[600]!;

    return Container(
      color: navBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _buildNavItem(
              context: context,
              index: 0,
              label: 'خانه',
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              activeBgColor: activeBgColor,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),

            _buildNavItem(
              context: context,
              index: 1,
              label: 'سریال‌ها',
              icon: Icons.tv_outlined,
              activeIcon: Icons.tv_rounded,
              activeBgColor: activeBgColor,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),

            _buildNavItem(
              context: context,
              index: 2,
              label: 'فیلم‌ها',
              icon: Icons.movie_creation_outlined,
              activeIcon: Icons.movie_creation_rounded,
              activeBgColor: activeBgColor,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),

            _buildNavItem(
              context: context,
              index: 3,
              label: 'حساب کاربری',
              icon: Icons.badge_outlined,
              activeIcon: Icons.badge_rounded,
              activeBgColor: activeBgColor,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required Color activeBgColor,
    required Color activeColor,
    required Color inactiveColor,
    required bool isDark,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountPage()),
          );
        } else {
          onTap(index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}