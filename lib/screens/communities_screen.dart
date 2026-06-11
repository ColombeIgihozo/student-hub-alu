import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  String _tab = 'All';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final list = _tab == 'All'
        ? MockData.communities
        : MockData.communities.where((c) => app.isJoined(c.id)).toList();
    final myCount = MockData.communities.where((c) => app.isJoined(c.id)).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Communities', style: AppTheme.heading(context, size: 28)),
                  const SizedBox(height: 14),
                  SegmentedControl(
                    options: ['All Clubs', 'My Clubs $myCount'],
                    selected: _tab == 'All' ? 'All Clubs' : 'My Clubs $myCount',
                    onChanged: (v) => setState(() => _tab = v.startsWith('All') ? 'All' : 'My'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? EmptyState(
                      icon: Icons.extension_outlined,
                      title: 'No clubs joined yet',
                      subtitle: 'Join a community to see it here.',
                      action: GoldButton(label: 'Browse clubs', onPressed: () => setState(() => _tab = 'All')),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _CommunityCard(community: list[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final joined = app.isJoined(community.id);

    return AppCard(
      padding: const EdgeInsets.all(15),
      onTap: () => app.push('community', {'id': community.id}),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        colors: [avatarGradientStart(community.hue), avatarGradientEnd(community.hue)],
                      ),
                    ),
                    child: Text(
                      community.name[0],
                      style: GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  if (joined && community.newActivity)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.bg, width: 2.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(community.name, style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${community.members} members', style: AppTheme.muted(context, size: 12)),
                    const SizedBox(height: 7),
                    Text(community.short, style: AppTheme.muted(context, size: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                app.toggleJoin(community.id);
                app.showToast(joined ? 'Left ${community.name}' : 'Joined ${community.name}');
              },
              icon: Icon(joined ? Icons.check : Icons.add, size: 16),
              label: Text(joined ? 'Joined' : 'Join community'),
              style: OutlinedButton.styleFrom(
                backgroundColor: joined ? AppColors.s2 : AppColors.gold,
                foregroundColor: joined ? AppColors.txt : AppColors.onGold,
                side: BorderSide(color: joined ? AppColors.line2 : Colors.transparent),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
