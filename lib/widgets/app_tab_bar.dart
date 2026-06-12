import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final unread = state.chatUnread;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.s1,
        border: Border(top: BorderSide(color: AppColors.line2)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      child: Row(
        children: [
          _TabItem(
            icon: Icons.home_rounded,
            label: 'Home',
            active: state.tab == AppTab.home,
            onTap: () => state.switchTab(AppTab.home),
          ),
          _TabItem(
            icon: Icons.explore_outlined,
            label: 'Explore',
            active: state.tab == AppTab.explore,
            onTap: () => state.switchTab(AppTab.explore),
          ),
          _TabItem(
            icon: Icons.groups_outlined,
            label: 'Clubs',
            active: state.tab == AppTab.communities,
            onTap: () => state.switchTab(AppTab.communities),
          ),
          _TabItem(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            active: state.tab == AppTab.chat,
            onTap: () => state.switchTab(AppTab.chat),
            showDot: unread > 0,
          ),
          _TabItem(
            icon: Icons.person_outline,
            label: 'Profile',
            active: state.tab == AppTab.profile,
            onTap: () => state.switchTab(AppTab.profile),
          ),
        ],
      ),
    );
  }
}


class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool showDot;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 23, color: active ? AppColors.gold : AppColors.txt2),
                if (showDot)
                  Positioned(
                    top: -2,
                    right: -6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? AppColors.gold : AppColors.txt2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
