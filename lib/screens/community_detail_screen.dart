import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_widgets.dart';

class CommunityDetailScreen extends StatefulWidget {
  const CommunityDetailScreen({super.key, required this.communityId});

  final String communityId;

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  String _tab = 'About';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final c = MockData.communityById(widget.communityId);
    if (c == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: Text('Community not found', style: AppTheme.muted(context))),
      );
    }

    final joined = app.isJoined(c.id);
    final events = app.allEvents.where((e) => e.org == c.id).toList();
    final members = MockData.people.values.take(7).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CoverBanner(hue: c.hue, height: 150),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Transform.translate(
                      offset: const Offset(0, -34),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: AppColors.bg, width: 4),
                              gradient: LinearGradient(
                                colors: [avatarGradientStart(c.hue), avatarGradientEnd(c.hue)],
                              ),
                            ),
                            child: Text(c.name[0], style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              app.toggleJoin(c.id);
                              app.showToast(joined ? 'Left ${c.name}' : 'Joined ${c.name}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: joined ? AppColors.s2 : AppColors.gold,
                              foregroundColor: joined ? AppColors.txt : AppColors.onGold,
                              side: joined ? const BorderSide(color: AppColors.line2) : null,
                            ),
                            child: Text(joined ? 'Joined' : 'Join'),
                          ),
                        ],
                      ),
                    ),
                    Text(c.name, style: AppTheme.heading(context, size: 24)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('${c.members} members', style: AppTheme.muted(context, size: 13.5)),
                        const SizedBox(width: 14),
                        CatBadge(cat: c.cat),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: ['About', 'Events', 'Members'].map((t) {
                        final active = _tab == t;
                        return GestureDetector(
                          onTap: () => setState(() => _tab = t),
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: active ? AppColors.gold : Colors.transparent, width: 2)),
                            ),
                            child: Text(
                              t == 'Events' ? 'Events ${events.length}' : t,
                              style: GoogleFonts.inter(
                                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                                color: active ? AppColors.txt : AppColors.txt3,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    if (_tab == 'About') ...[
                      Text(c.about, style: GoogleFonts.inter(fontSize: 15, height: 1.65, color: const Color(0xFFDCDCDC))),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final ch = MockData.chats.where((x) => x.cid == c.id).firstOrNull;
                            if (ch != null) {
                              app.push('chatDetail', {'id': ch.id});
                            } else {
                              app.switchTab(AppTab.chat);
                            }
                          },
                          icon: const Icon(Icons.chat_bubble_outline, color: AppColors.gold),
                          label: const Text('Open community chat'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.s2,
                            foregroundColor: AppColors.txt,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                    if (_tab == 'Events')
                      events.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(30),
                              child: Center(child: Text('No upcoming events.', style: AppTheme.muted(context))),
                            )
                          : Column(
                              children: events
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: EventCard(event: e),
                                      ))
                                  .toList(),
                            ),
                    if (_tab == 'Members')
                      ...members.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                PersonAvatar(personId: p.id, size: 42),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${p.name}${p.id == 'me' ? ' (You)' : ''}', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.5)),
                                      Text(
                                        p.id == 'liam' || p.id == 'zuri' ? 'Club Leader' : 'Member',
                                        style: AppTheme.muted(context, size: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                if (p.id != 'me')
                                  OutlinedButton(
                                    onPressed: () => app.push('chatDetail', {'id': 'new', 'with': p.id}),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.txt2,
                                      side: const BorderSide(color: AppColors.line2),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                                    ),
                                    child: const Text('Message'),
                                  ),
                              ],
                            ),
                          )),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GlassIconButton(icon: Icons.arrow_back, onTap: app.pop),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
