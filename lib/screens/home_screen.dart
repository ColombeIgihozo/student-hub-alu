import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _feedCategories = [
    'Events',
    'Hackathons',
    'Workshops',
    'Internships',
    'Startups',
  ];

  String _category = 'All';
  final _scrollController = ScrollController();
  final _sectionKeys = <String, GlobalKey>{
    for (final c in ['All', ..._feedCategories]) c: GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    setState(() => _category = category);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCategory(category));
  }

  void _scrollToCategory(String category) {
    final key = _sectionKeys[category];
    final context = key?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  List<EventItem> _eventsForCategory(String cat, List<EventItem> all, {bool excludeFeatured = true}) {
    return all.where((e) {
      if (excludeFeatured && e.featured) return false;
      return e.cat == cat;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final allEvents = app.allEvents;
    final featured = allEvents.where((e) => e.featured).firstOrNull;
    final rsvpEvents = allEvents
        .where((e) => app.rsvpStatus(e.id) != null)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: app.canPost
          ? FloatingActionButton(
              onPressed: () => app.push('create'),
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.onGold,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => app.switchTab(AppTab.profile),
                    child: const PersonAvatar(personId: 'me', size: 44, ring: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good morning,', style: AppTheme.muted(context, size: 12.5)),
                        Text(
                          '${MockData.people['me']!.name.split(' ').first} 👋',
                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => app.push('rsvp'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.goldSoft,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.goldLine),
                      ),
                      child: Row(
                        children: [
                          const Text('🔥'),
                          const SizedBox(width: 5),
                          Text(
                            '${app.streak}',
                            style: GoogleFonts.inter(color: AppColors.gold, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  IconButton(
                    onPressed: () => app.push('notifications'),
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_none, size: 24),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CategoryPillBar(
              labels: MockData.categories,
              selected: _category,
              onSelected: _selectCategory,
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                children: [
                  const StreakBanner(),
                  const SizedBox(height: 14),
                  const PulseCard(),
                  if (_category == 'All' && rsvpEvents.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _SectionHeader(
                      title: 'Your RSVPs',
                      trailing: GestureDetector(
                        onTap: () => app.push('rsvp'),
                        child: Text(
                          'Manage',
                          style: GoogleFonts.inter(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 118,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: rsvpEvents.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final ev = rsvpEvents[i];
                          final status = app.rsvpStatus(ev.id);
                          return GestureDetector(
                            onTap: () => app.push('event', {'id': ev.id}),
                            child: Container(
                              width: 220,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.s1,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.line2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        status == 'going'
                                            ? Icons.check_circle
                                            : Icons.favorite_border,
                                        size: 16,
                                        color: AppColors.gold,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          status == 'going' ? 'Going' : 'Interested',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.gold2,
                                          ),
                                        ),
                                      ),
                                      CatBadge(cat: ev.cat),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ev.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${ev.date} · ${ev.campus}',
                                    style: AppTheme.muted(context, size: 11),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (_category == 'All' && featured != null) ...[
                    const SizedBox(height: 18),
                    Text('Featured', style: AppTheme.heading(context)),
                    const SizedBox(height: 12),
                    FeaturedCard(event: featured),
                  ],
                  if (_category == 'All') ...[
                    const SizedBox(height: 18),
                    _SectionHeader(
                      key: _sectionKeys['All'],
                      title: 'Happening soon',
                      trailing: GestureDetector(
                        onTap: () => app.switchTab(AppTab.explore),
                        child: Text(
                          'See all',
                          style: GoogleFonts.inter(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._feedCategories.expand((cat) {
                      final items = _eventsForCategory(cat, allEvents);
                      if (items.isEmpty) return <Widget>[];
                      return [
                        _CategoryBlock(
                          sectionKey: _sectionKeys[cat]!,
                          title: cat,
                          events: items,
                          count: items.length,
                        ),
                      ];
                    }),
                  ] else ...[
                    const SizedBox(height: 18),
                    _CategoryBlock(
                      sectionKey: _sectionKeys[_category]!,
                      title: _category,
                      events: _eventsForCategory(_category, allEvents),
                      count: _eventsForCategory(_category, allEvents).length,
                      showSeeAll: true,
                      onSeeAll: () => app.switchTab(AppTab.explore),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.heading(context)),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.sectionKey,
    required this.title,
    required this.events,
    required this.count,
    this.showSeeAll = false,
    this.onSeeAll,
  });

  final GlobalKey sectionKey;
  final String title;
  final List<EventItem> events;
  final int count;
  final bool showSeeAll;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Padding(
        key: sectionKey,
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTheme.heading(context, size: 17)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.s1,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(
                'No ${title.toLowerCase()} right now.',
                textAlign: TextAlign.center,
                style: AppTheme.muted(context),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      key: sectionKey,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: AppTheme.heading(context, size: 17)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.s2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.txt2,
                      ),
                    ),
                  ),
                ],
              ),
              if (showSeeAll && onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'See all',
                    style: GoogleFonts.inter(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...events.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EventCard(event: e),
            ),
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
