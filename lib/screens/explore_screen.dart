import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _query = '';
  String _filter = 'All';
  bool _grid = true;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final q = _query.trim().toLowerCase();

    bool matchEvent(EventItem e) {
      if (q.isEmpty) return true;
      return e.title.toLowerCase().contains(q) ||
          e.campus.toLowerCase().contains(q) ||
          e.cat.toLowerCase().contains(q) ||
          e.tags.any((t) => t.toLowerCase().contains(q)) ||
          MockData.orgName(e.org).toLowerCase().contains(q);
    }

    bool matchClub(Community c) {
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) || c.short.toLowerCase().contains(q);
    }

    var events = MockData.events.where(matchEvent).toList();
    if (_filter == 'Events') events = events.where((e) => e.kind == 'event').toList();
    if (_filter == 'Opportunities') events = events.where((e) => e.kind == 'opportunity').toList();
    if (_filter == 'Academics') events = events.where((e) => e.cat == 'Workshops').toList();

    final clubs = MockData.communities.where(matchClub).toList();
    final showClubs = _filter == 'All' || _filter == 'Clubs';
    final showEvents = _filter != 'Clubs';
    final recommended = MockData.events.where((e) => app.isJoined(e.org) && matchEvent(e)).toList();
    final showReco = q.isEmpty && _filter == 'All' && recommended.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore', style: AppTheme.heading(context, size: 28)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.s1,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.line2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: AppColors.txt3, size: 19),
                              const SizedBox(width: 9),
                              Expanded(
                                child: TextField(
                                  onChanged: (v) => setState(() => _query = v),
                                  style: GoogleFonts.inter(color: AppColors.txt),
                                  decoration: const InputDecoration(
                                    hintText: 'Search events, clubs, opportunities…',
                                    border: InputBorder.none,
                                    filled: false,
                                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                                  ),
                                ),
                              ),
                              if (_query.isNotEmpty)
                                GestureDetector(
                                  onTap: () => setState(() => _query = ''),
                                  child: const Icon(Icons.close, color: AppColors.txt3, size: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (showEvents) ...[
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () => setState(() => _grid = !_grid),
                          icon: Icon(_grid ? Icons.view_list : Icons.grid_view),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            CategoryPillBar(
              labels: MockData.exploreFilters,
              selected: _filter,
              onSelected: (f) => setState(() => _filter = f),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                children: [
                  if (showReco) ...[
                    Text('✨ Recommended for you', style: AppTheme.heading(context, size: 17)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommended.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => SizedBox(
                          width: 230,
                          child: ExploreGridCard(event: recommended[i]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  if (q.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '${(showEvents ? events.length : 0) + (showClubs ? clubs.length : 0)} results for "$_query"',
                        style: AppTheme.muted(context, size: 12),
                      ),
                    ),
                  if (showEvents && events.isNotEmpty)
                    _grid
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: events.length,
                            itemBuilder: (_, i) => ExploreGridCard(event: events[i]),
                          )
                        : Column(
                            children: events
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: ExploreRow(event: e),
                                    ))
                                .toList(),
                          ),
                  if (showClubs && clubs.isNotEmpty) ...[
                    if (_filter == 'All')
                      Padding(
                        padding: const EdgeInsets.only(top: 22, bottom: 12),
                        child: Text('Clubs & Communities', style: AppTheme.heading(context, size: 17)),
                      ),
                    ...clubs.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ClubResult(community: c),
                        )),
                  ],
                  if ((showEvents ? events.length : 0) + (showClubs ? clubs.length : 0) == 0)
                    const EmptyState(
                      icon: Icons.search,
                      title: 'Nothing found',
                      subtitle: 'Try a different search or filter.',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClubResult extends StatelessWidget {
  const _ClubResult({required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final joined = app.isJoined(community.id);

    return AppCard(
      padding: const EdgeInsets.all(13),
      onTap: () => app.push('community', {'id': community.id}),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [avatarGradientStart(community.hue), avatarGradientEnd(community.hue)],
              ),
            ),
            child: Text(
              community.name[0],
              style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(community.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                Text('${community.members} members', style: AppTheme.muted(context, size: 12)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => app.toggleJoin(community.id),
            style: TextButton.styleFrom(
              backgroundColor: joined ? AppColors.s2 : AppColors.gold,
              foregroundColor: joined ? AppColors.txt2 : AppColors.onGold,
            ),
            child: Text(joined ? 'Joined' : 'Join'),
          ),
        ],
      ),
    );
  }
}
