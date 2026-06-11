import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Color _iconColor(String type) {
    switch (type) {
      case 'chat':
        return const Color(0xFF7AA7FF);
      case 'event':
        return const Color(0xFF6FD3A8);
      case 'community':
        return const Color(0xFFF5A623);
      case 'streak':
        return const Color(0xFFFF8A4C);
      default:
        return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final groups = <String, List>{};
    for (final n in MockData.notifications) {
      groups.putIfAbsent(n.group, () => []).add(n);
    }

    final allRead = MockData.notifications.every((n) => app.isNotificationRead(n.id) || !n.unread);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => app.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(child: Text('Notifications', style: AppTheme.heading(context, size: 21))),
                  TextButton(
                    onPressed: allRead ? null : app.markAllNotificationsRead,
                    child: Text(
                      'Mark all read',
                      style: GoogleFonts.inter(
                        color: allRead ? AppColors.txt3 : AppColors.gold,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: groups.entries.expand((entry) {
                  return [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 8),
                      child: Text(
                        entry.key.toUpperCase(),
                        style: AppTheme.muted(context, size: 11).copyWith(letterSpacing: 1),
                      ),
                    ),
                    ...entry.value.map((n) {
                      final unread = n.unread && !app.isNotificationRead(n.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AppCard(
                          padding: const EdgeInsets.all(14),
                          border: Border.all(color: unread ? AppColors.goldLine : AppColors.line),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.s1,
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(color: AppColors.line),
                                    ),
                                    child: Icon(n.icon, color: _iconColor(n.type), size: 21),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(n.title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.5)),
                                        ),
                                        Text(n.time, style: AppTheme.muted(context, size: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(n.body, style: AppTheme.muted(context, size: 13.5)),
                                  ],
                                ),
                              ),
                              if (unread)
                                Container(
                                  width: 9,
                                  height: 9,
                                  margin: const EdgeInsets.only(top: 6, left: 6),
                                  decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ];
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
