import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class RsvpManagerScreen extends StatefulWidget {
  const RsvpManagerScreen({super.key});

  @override
  State<RsvpManagerScreen> createState() => _RsvpManagerScreenState();
}

class _RsvpManagerScreenState extends State<RsvpManagerScreen> {
  String _tab = 'Going';
  EventItem? _confirm;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final all = app.allEvents;
    final going = all.where((e) => app.rsvpStatus(e.id) == 'going').toList();
    final interested = all.where((e) => app.rsvpStatus(e.id) == 'interested').toList();
    final past = MockData.events.where((e) => e.id == 'e3').toList();
    final list = _tab == 'Going' ? going : _tab == 'Interested' ? interested : past;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(onPressed: app.pop, icon: const Icon(Icons.arrow_back)),
                  Text('My RSVPs', style: AppTheme.heading(context, size: 21)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SegmentedControl(
                options: [
                  'Going${going.isNotEmpty ? ' ${going.length}' : ''}',
                  'Interested${interested.isNotEmpty ? ' ${interested.length}' : ''}',
                  'Past',
                ],
                selected: _tab == 'Going'
                    ? 'Going${going.isNotEmpty ? ' ${going.length}' : ''}'
                    : _tab == 'Interested'
                        ? 'Interested${interested.isNotEmpty ? ' ${interested.length}' : ''}'
                        : 'Past',
                onChanged: (v) => setState(() {
                  if (v.startsWith('Going')) {
                    _tab = 'Going';
                  } else if (v.startsWith('Interested')) _tab = 'Interested';
                  else _tab = 'Past';
                }),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? EmptyState(
                      icon: Icons.calendar_month_outlined,
                      title: 'Nothing here yet',
                      subtitle: 'RSVP to events and they\'ll show up here.',
                      action: GoldButton(
                        label: 'Explore events',
                        onPressed: () {
                          app.pop();
                          app.switchTab(AppTab.explore);
                        },
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _RsvpCard(
                        event: list[i],
                        tab: _tab,
                        onCancel: () => setState(() => _confirm = list[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
          if (_confirm != null) ...[
            GestureDetector(
              onTap: () => setState(() => _confirm = null),
              child: Container(color: Colors.black54),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.s1,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.line2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cancel RSVP?', style: AppTheme.heading(context, size: 18)),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ll be removed from ${_confirm!.title}. You can RSVP again anytime.',
                      style: AppTheme.muted(context, size: 14.5),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          app.toggleRsvp(_confirm!.id, null);
                          setState(() => _confirm = null);
                          app.showToast('RSVP cancelled');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: const Color(0xFF1A0D08),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Yes, cancel RSVP'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: GoldButton(
                        label: 'Keep my spot',
                        outlined: true,
                        expand: true,
                        onPressed: () => setState(() => _confirm = null),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RsvpCard extends StatelessWidget {
  const _RsvpCard({required this.event, required this.tab, required this.onCancel});

  final EventItem event;
  final String tab;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => app.push('event', {'id': event.id}),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CoverBanner(hue: event.hue, height: 64, borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CatBadge(cat: event.cat),
                      const SizedBox(height: 6),
                      Text(event.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
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
                if (tab == 'Past')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.s2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Attended', style: AppTheme.muted(context, size: 11)),
                  ),
              ],
            ),
          ),
          if (tab != 'Past') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => app.showToast('Added to your calendar'),
                    icon: const Icon(Icons.calendar_month_outlined, color: AppColors.gold, size: 17),
                    label: const Text('Add to Calendar'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.s2,
                      foregroundColor: AppColors.txt,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.txt2,
                    side: const BorderSide(color: AppColors.line2),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
