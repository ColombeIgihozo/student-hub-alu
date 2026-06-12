import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();

    return AppCard(
      onTap: () => app.push('event', {'id': event.id}),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CatBadge(cat: event.cat),
              StatusBadge(event: event),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            event.title,
            style: GoogleFonts.inter(
              fontSize: 17.5,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      avatarGradientStart(MockData.orgHue(event.org)),
                      avatarGradientEnd(MockData.orgHue(event.org)),
                    ],
                  ),
                ),
                child: Text(
                  MockData.orgName(event.org)[0],
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  MockData.orgName(event.org),
                  style: AppTheme.muted(context, size: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 15, color: AppColors.txt2),
                  const SizedBox(width: 5),
                  Text(
                    '${event.date} · ${event.time}',
                    style: AppTheme.muted(context, size: 13),
                  ),
                ],
              ),
              CampusTag(campus: event.campus, small: true),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: event.goingN > 0
                    ? Row(
                        children: [
                          _AvatarStack(ids: event.going.take(3).toList()),
                          const SizedBox(width: 9),
                          Text(
                            '${event.goingN} going',
                            style: AppTheme.muted(context, size: 12),
                          ),
                        ],
                      )
                    : Text(
                        'Be the first to RSVP',
                        style: AppTheme.muted(context, size: 12),
                      ),
              ),
              RsvpButton(event: event, small: true),
            ],
          ),
        ],
      ),
    );
  }
}

class RsvpButton extends StatelessWidget {
  const RsvpButton({super.key, required this.event, this.small = false});

  final EventItem event;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final going = app.rsvpStatus(event.id) == 'going';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => app.toggleRsvp(event.id, 'going'),
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: small ? 16 : 18,
            vertical: small ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: going ? AppColors.goldSoft : AppColors.gold,
            borderRadius: BorderRadius.circular(999),
            border: going ? Border.all(color: AppColors.goldLine) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (going) ...[
                const Icon(Icons.check, size: 15, color: AppColors.gold2),
                const SizedBox(width: 4),
              ],
              Text(
                going ? 'Going' : 'RSVP',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: going ? AppColors.gold2 : AppColors.onGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    if (event.trending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.goldSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department, size: 12, color: AppColors.gold2),
            const SizedBox(width: 4),
            Text(
              'Trending',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.gold2,
              ),
            ),
          ],
        ),
      );
    }
    if (event.deadline != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0x33E76F51),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 12, color: AppColors.error),
            const SizedBox(width: 4),
            Text(
              'Soon',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return GestureDetector(
      onTap: () => app.push('event', {'id': event.id}),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            CoverBanner(hue: event.hue, height: 200),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CatBadge(cat: 'Featured'),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${event.date} · ${event.campus}',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
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

class ExploreGridCard extends StatelessWidget {
  const ExploreGridCard({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => app.push('event', {'id': event.id}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoverBanner(hue: event.hue, height: 96),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CatBadge(cat: event.cat),
                const SizedBox(height: 8),
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 13, color: AppColors.txt2),
                    const SizedBox(width: 4),
                    Text(event.date, style: AppTheme.muted(context, size: 11.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreRow extends StatelessWidget {
  const ExploreRow({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return AppCard(
      padding: const EdgeInsets.all(10),
      onTap: () => app.push('event', {'id': event.id}),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CoverBanner(hue: event.hue, height: 74, borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CatBadge(cat: event.cat),
                const SizedBox(height: 6),
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 13, color: AppColors.txt2),
                    const SizedBox(width: 4),
                    Text(event.date, style: AppTheme.muted(context, size: 12)),
                    const SizedBox(width: 12),
                    CampusTag(campus: event.campus, small: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StreakBanner extends StatelessWidget {
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<AppState>().streak;
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return AppCard(
      border: Border.all(color: AppColors.goldLine),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$streak-day streak', style: AppTheme.heading(context, size: 19)),
                    Text(
                      streak < 7 ? '${7 - streak} days to "Consistent Leader"' : 'Consistent Leader unlocked!',
                      style: AppTheme.muted(context, size: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.goldLine),
                ),
                child: Text('$streak/7', style: GoogleFonts.inter(color: AppColors.gold2, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(7, (i) {
              final active = i < streak;
              return Expanded(
                child: Container(
                  height: 30,
                  margin: EdgeInsets.only(right: i < 6 ? 6 : 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? AppColors.gold : AppColors.s2,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    active ? '✓' : days[i],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: active ? AppColors.onGold : AppColors.txt3,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class PulseCard extends StatelessWidget {
  const PulseCard({super.key});

  @override
  Widget build(BuildContext context) {
    const p = MockData.pulse;
    final joinedN = context.watch<AppState>().joined.length;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 15, 18, 4),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.bar_chart, color: AppColors.gold, size: 17),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Campus Pulse', style: AppTheme.heading(context, size: 15)),
                      Text(p.week, style: AppTheme.muted(context, size: 11.5)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.goldLine),
                  ),
                  child: Text('Weekly', style: GoogleFonts.inter(color: AppColors.gold2, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _PulseStat(label: 'Most attended', value: p.topEventTitle, sub: '${p.topEventN} interested'),
                _PulseStat(label: 'Trending club', value: p.trendingCommunity, sub: p.trendingGrowth),
                _PulseStat(label: 'New opportunities', value: '${p.newOpps} posted', sub: 'this week'),
                _PulseStat(label: 'Your communities', value: '$joinedN active', sub: '2 new updates'),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.s2,
              borderRadius: BorderRadius.circular(12),
              border: const Border(left: BorderSide(color: AppColors.gold, width: 3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, color: AppColors.gold, size: 16),
                const SizedBox(height: 6),
                Text(
                  p.quote,
                  style: GoogleFonts.inter(fontSize: 13.5, fontStyle: FontStyle.italic, color: const Color(0xFFE8E8E8), height: 1.5),
                ),
                const SizedBox(height: 6),
                Text('— ${p.quoteBy}', style: AppTheme.muted(context, size: 11).copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseStat extends StatelessWidget {
  const _PulseStat({required this.label, required this.value, required this.sub});

  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.s2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTheme.muted(context, size: 10.5)),
          const SizedBox(height: 6),
          Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600)),
          Text(sub, style: AppTheme.muted(context, size: 11)),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ids.length * 18.0 + 14,
      height: 28,
      child: Stack(
        children: [
          for (var i = 0; i < ids.length; i++)
            Positioned(
              left: i * 18.0,
              child: PersonAvatar(personId: ids[i], size: 28),
            ),
        ],
      ),
    );
  }
}

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key, required this.badge});

  final BadgeItem badge;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(15),
      border: Border.all(color: badge.earned ? AppColors.goldLine : AppColors.line),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: badge.earned
                  ? const LinearGradient(colors: [AppColors.gold, Color(0xFFC77E26)])
                  : null,
              color: badge.earned ? null : AppColors.s2,
            ),
            child: Icon(badge.icon, color: badge.earned ? AppColors.onGold : AppColors.txt3, size: 26),
          ),
          const SizedBox(height: 10),
          Text(badge.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13.5)),
          const SizedBox(height: 4),
          Text(
            badge.earned ? badge.desc : (badge.progress ?? 'Locked'),
            textAlign: TextAlign.center,
            style: AppTheme.muted(context, size: 11),
          ),
        ],
      ),
    );
  }
}
