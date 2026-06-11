import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text('Messages', style: AppTheme.heading(context, size: 28)),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                itemCount: MockData.chats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _ChatTile(chat: MockData.chats[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat});

  final dynamic chat;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final isCommunity = chat.type == 'community';

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => app.push('chatDetail', {'id': chat.id}),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [avatarGradientStart(chat.hue), avatarGradientEnd(chat.hue)],
                  ),
                ),
                child: Text(
                  chat.name[0],
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              if (isCommunity)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.s3,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.bg, width: 2.5),
                    ),
                    child: const Icon(Icons.groups, size: 11, color: AppColors.txt2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(chat.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15.5)),
                    ),
                    Text(chat.time, style: AppTheme.muted(context, size: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  chat.last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.muted(context, size: 13.5),
                ),
              ],
            ),
          ),
          if (chat.unread > 0) ...[
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${chat.unread}',
                style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.onGold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
