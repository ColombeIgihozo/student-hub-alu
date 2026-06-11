import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String _tab = 'About';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    EventItem? ev;
    for (final e in app.allEvents) {
      if (e.id == widget.eventId) {
        ev = e;
        break;
      }
    }
    if (ev == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: Text('Event not found', style: AppTheme.muted(context))),
      );
    }

    final event = ev;
    final status = app.rsvpStatus(event.id);
    final going = status == 'going';
    final interested = status == 'interested';
    final goingPpl = event.going.isNotEmpty ? event.going : ['liam', 'zuri'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    CoverBanner(hue: event.hue, height: 300),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      top: MediaQuery.of(context).padding.top + 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GlassIconButton(icon: Icons.arrow_back, onTap: app.pop),
                          Row(
                            children: [
                              GlassIconButton(
                                icon: Icons.bookmark_outline,
                                onTap: () => app.toggleSave(event.id),
                              ),
                              const SizedBox(width: 9),
                              GlassIconButton(
                                icon: Icons.share_outlined,
                                onTap: () => app.openShare(event),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CatBadge(cat: event.cat),
                              if (event.trending) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                                  child: Text('Trending', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onGold)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.title,
                            style: GoogleFonts.poppins(fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white, height: 1.12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    AppCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () => app.push('community', {'id': event.org}),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              gradient: LinearGradient(
                                colors: [
                                  avatarGradientStart(MockData.orgHue(event.org)),
                                  avatarGradientEnd(MockData.orgHue(event.org)),
                                ],
                              ),
                            ),
                            child: Text(
                              MockData.orgName(event.org)[0],
                              style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Organized by', style: AppTheme.muted(context, size: 12)),
                                Text(MockData.orgName(event.org), style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.5)),
                              ],
                            ),
                          ),
                          OutlinedButton(onPressed: () => app.push('community', {'id': event.org}), child: const Text('View')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    AppCard(
                      child: Column(
                        children: [
                          _MetaRow(icon: Icons.calendar_today, title: '${event.date}, ${event.month}', sub: event.time == 'Deadline' ? 'Application deadline' : event.time),
                          const Divider(color: AppColors.line),
                          _MetaRow(
                            icon: event.campus == 'Virtual' ? Icons.public : Icons.location_on_outlined,
                            title: event.campus == 'Virtual' ? 'Online event' : 'ALU ${event.campus} Campus',
                            sub: event.campus == 'Virtual' ? 'Link shared after RSVP' : 'Main Auditorium',
                          ),
                          if (event.max != null) ...[
                            const Divider(color: AppColors.line),
                            _MetaRow(
                              icon: Icons.groups_outlined,
                              title: '${event.goingN} / ${event.max} spots filled',
                              sub: '${event.max! - event.goingN} spots left',
                              progress: event.goingN / event.max!,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('${event.goingN} going · ${event.interestedN} interested', style: GoogleFonts.inter(fontSize: 13.5)),
                    const SizedBox(height: 22),
                    Row(
                      children: ['About', 'Attendees', 'Discussion'].map((t) {
                        final active = _tab == t;
                        return GestureDetector(
                          onTap: () => setState(() => _tab = t),
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: active ? AppColors.gold : Colors.transparent, width: 2),
                              ),
                            ),
                            child: Text(
                              t,
                              style: GoogleFonts.inter(
                                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                                color: active ? AppColors.txt : AppColors.txt3,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (_tab == 'About') ...[
                      const SizedBox(height: 8),
                      Text(event.about, style: GoogleFonts.inter(fontSize: 15, height: 1.65, color: const Color(0xFFDCDCDC))),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: event.tags.map((t) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.s2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('#$t', style: GoogleFonts.inter(fontSize: 12)),
                            )).toList(),
                      ),
                    ],
                    if (_tab == 'Attendees')
                      ...goingPpl.map((pid) {
                        final p = MockData.people[pid];
                        if (p == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              PersonAvatar(personId: pid, size: 40),
                              const SizedBox(width: 12),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.5)),
                                  Text('Going', style: AppTheme.muted(context, size: 12)),
                                ],
                              )),
                              const Icon(Icons.check_circle, color: AppColors.gold),
                            ],
                          ),
                        );
                      }),
                    if (_tab == 'Discussion') ...[
                      const _DiscussionBubble(personId: 'kofi', text: 'Is there parking at the venue?', time: '2h'),
                      const _DiscussionBubble(personId: 'nadia', text: 'So excited for this! Who else is coming from Mauritius?', time: '5h'),
                    ],
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [AppColors.bg, AppColors.bg.withValues(alpha: 0)],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => app.toggleRsvp(event.id, 'going'),
                      icon: Icon(going ? Icons.check : Icons.event_available_outlined, size: 19),
                      label: Text(going ? "You're going" : "I'm going"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: going ? AppColors.goldSoft : AppColors.gold,
                        foregroundColor: going ? AppColors.gold2 : AppColors.onGold,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: going ? const BorderSide(color: AppColors.goldLine) : BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => app.toggleRsvp(event.id, 'interested'),
                    icon: Icon(
                      interested ? Icons.favorite : Icons.favorite_border,
                      size: 19,
                      color: interested ? AppColors.gold2 : AppColors.txt,
                    ),
                    label: const Text('Interested'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: interested ? AppColors.goldSoft : AppColors.s2,
                      foregroundColor: interested ? AppColors.gold2 : AppColors.txt,
                      side: BorderSide(color: interested ? AppColors.goldLine : AppColors.line),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.title, required this.sub, this.progress});

  final IconData icon;
  final String title;
  final String sub;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: AppColors.gold, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.5)),
                Text(sub, style: AppTheme.muted(context, size: 12)),
                if (progress != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: AppColors.s3,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscussionBubble extends StatelessWidget {
  const _DiscussionBubble({required this.personId, required this.text, required this.time});

  final String personId;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    final p = MockData.people[personId]!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonAvatar(personId: personId, size: 36),
          const SizedBox(width: 11),
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      Text(time, style: AppTheme.muted(context, size: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(text, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFDCDCDC))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
