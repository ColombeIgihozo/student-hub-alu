import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_tab_bar.dart';
import '../widgets/common_widgets.dart';
import 'chat_detail_screen.dart';
import 'chat_screen.dart';
import 'communities_screen.dart';
import 'community_detail_screen.dart';
import 'create_post_screen.dart';
import 'event_detail_screen.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'rsvp_manager_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ToastOverlay(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Stack(
          children: [
            IndexedStack(
              index: state.tab.index,
              children: const [
                HomeScreen(),
                ExploreScreen(),
                CommunitiesScreen(),
                ChatScreen(),
                ProfileScreen(),
              ],
            ),
            if (state.overlayStack.isEmpty)
              const Positioned(left: 0, right: 0, bottom: 0, child: AppTabBar()),
            ...state.overlayStack.asMap().entries.map((entry) {
              return Positioned.fill(
                child: Material(
                  color: AppColors.bg,
                  child: _OverlayScreen(route: entry.value),
                ),
              );
            }),
            if (state.shareEvent != null) _ShareSheet(event: state.shareEvent!),
          ],
        ),
      ),
    );
  }
}

class _OverlayScreen extends StatelessWidget {
  const _OverlayScreen({required this.route});

  final AppOverlayRoute route;

  @override
  Widget build(BuildContext context) {
    switch (route.name) {
      case 'event':
        return EventDetailScreen(eventId: route.params['id']!);
      case 'community':
        return CommunityDetailScreen(communityId: route.params['id']!);
      case 'create':
        return const CreatePostScreen();
      case 'rsvp':
        return const RsvpManagerScreen();
      case 'chatDetail':
        return ChatDetailScreen(
          chatId: route.params['id']!,
          partnerId: route.params['with'],
        );
      case 'notifications':
        return const NotificationsScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return Center(child: Text('Unknown screen: ${route.name}'));
    }
  }
}

class _ShareSheet extends StatelessWidget {
  const _ShareSheet({required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final options = [
      ('Share to a chat', Icons.chat_bubble_outline),
      ('Post to community', Icons.groups_outlined),
      ('Email invite', Icons.mail_outline),
      ('Copy link', Icons.share_outlined),
    ];

    return Stack(
      children: [
        GestureDetector(
          onTap: app.closeShare,
          child: Container(color: Colors.black54),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: AppColors.s1,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.line2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.s3,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                Text('Share event', style: AppTheme.heading(context, size: 18)),
                const SizedBox(height: 4),
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.muted(context, size: 12),
                ),
                const SizedBox(height: 16),
                ...options.map((o) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        onTap: () {
                          app.closeShare();
                          app.showToast(o.$1 == 'Copy link' ? 'Link copied' : 'Shared');
                        },
                        tileColor: AppColors.s2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.s3,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(o.$2, color: AppColors.gold, size: 19),
                        ),
                        title: Text(o.$1),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
