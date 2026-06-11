import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _tab = 'Posts';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final myPosts = [
      ...app.posts,
      ...MockData.events.where((e) => e.org == 'c1').take(1),
    ];
    final saved = MockData.events.where((e) => app.isSaved(e.id)).toList();
    final earned = MockData.badges.where((b) => b.earned).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profile', style: AppTheme.heading(context, size: 21)),
                  IconButton(
                    onPressed: () => app.push('settings'),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: const CoverBanner(hue: 45, height: 86),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -34),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const PersonAvatar(personId: 'me', size: 82),
                              const Spacer(),
                              OutlinedButton.icon(
                                onPressed: () => app.push('settings'),
                                icon: const Icon(Icons.edit, size: 15),
                                label: const Text('Edit'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.txt,
                                  side: const BorderSide(color: AppColors.line2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(MockData.people['me']!.name, style: AppTheme.heading(context, size: 23)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.goldSoft,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.goldLine),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 12, color: AppColors.gold),
                                  const SizedBox(width: 4),
                                  Text('ALU Kigali', style: GoogleFonts.inter(fontSize: 12, color: AppColors.gold2)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('@amara · ${app.role}', style: AppTheme.muted(context, size: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          _Stat(n: 14, label: 'Attended', onTap: () => app.push('rsvp')),
                          _divider(),
                          _Stat(n: app.joined.length, label: 'Communities', onTap: () => app.switchTab(AppTab.communities)),
                          _divider(),
                          const _Stat(n: 48, label: 'Connections'),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: StreakBanner(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: SegmentedControl(
                      options: const ['My Posts', 'Saved', 'Badges'],
                      selected: _tab == 'Posts' ? 'My Posts' : _tab,
                      onChanged: (v) => setState(() => _tab = v == 'My Posts' ? 'Posts' : v),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _tab == 'Posts'
                        ? Column(
                            children: myPosts.isEmpty
                                ? [
                                    const EmptyState(
                                      icon: Icons.edit_outlined,
                                      title: 'No posts yet',
                                      subtitle: 'Your published events appear here.',
                                    )
                                  ]
                                : myPosts.map((e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: EventCard(event: e),
                                    )).toList(),
                          )
                        : _tab == 'Saved'
                            ? Column(
                                children: saved.isEmpty
                                    ? [
                                        const EmptyState(
                                          icon: Icons.bookmark_outline,
                                          title: 'Nothing saved',
                                          subtitle: 'Tap the bookmark on any event to save it.',
                                        )
                                      ]
                                    : saved.map((e) => Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: ExploreRow(event: e),
                                        )).toList(),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('ACHIEVEMENT SHELF', style: AppTheme.muted(context, size: 10.5)),
                                      Text('$earned/${MockData.badges.length} earned',
                                          style: GoogleFonts.inter(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.9,
                                    ),
                                    itemCount: MockData.badges.length,
                                    itemBuilder: (_, i) => BadgeCard(badge: MockData.badges[i]),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 32, color: AppColors.line);
}

class _Stat extends StatelessWidget {
  const _Stat({required this.n, required this.label, this.onTap});

  final int n;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text('$n', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700)),
            Text(label, style: AppTheme.muted(context, size: 12)),
          ],
        ),
      ),
    );
  }
}
