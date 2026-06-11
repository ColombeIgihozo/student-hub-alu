import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_widgets.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _kind = 'event';
  double _hue = 45;
  bool _coverPicked = false;
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  final _max = TextEditingController();
  final _tagInput = TextEditingController();
  String _campus = 'Kigali';
  String _cat = 'Events';
  final List<String> _tags = [];
  String? _titleErr;
  String? _descErr;
  String? _dateErr;
  String? _timeErr;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _date.dispose();
    _time.dispose();
    _max.dispose();
    _tagInput.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _titleErr = _title.text.trim().isEmpty ? 'Give your post a title.' : null;
      _descErr = _desc.text.trim().length < 15 ? 'Add a description (15+ characters).' : null;
      _dateErr = _date.text.trim().isEmpty ? 'When is it happening?' : null;
      _timeErr = _kind == 'event' && _time.text.trim().isEmpty ? 'Add a start time.' : null;
    });
    return _titleErr == null && _descErr == null && _dateErr == null && _timeErr == null;
  }

  void _publish() {
    if (!_validate()) return;
    final app = context.read<AppState>();
    app.addPost(EventItem(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(),
      cat: _cat,
      kind: _kind,
      org: 'c1',
      day: 'NEW',
      date: _date.text.trim(),
      time: _kind == 'opportunity' ? 'Deadline' : _time.text.trim(),
      month: '2026',
      campus: _campus,
      hue: _hue,
      going: const [],
      goingN: 0,
      interestedN: 0,
      max: _max.text.isEmpty ? null : int.tryParse(_max.text),
      tags: List.of(_tags),
      about: _desc.text.trim(),
      deadline: _kind == 'opportunity' ? _date.text.trim() : null,
    ));
    app.pop();
    app.showToast('Published! 🎉');
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final cats = MockData.categories.where((c) => c != 'All').toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(onPressed: app.pop, icon: const Icon(Icons.close)),
                  Expanded(child: Text('Create post', style: AppTheme.heading(context, size: 20))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.goldSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.goldLine),
                    ),
                    child: Text(app.role, style: GoogleFonts.inter(color: AppColors.gold2, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                children: [
                  SegmentedControl(
                    options: const ['📅 Event', '🚀 Opportunity'],
                    selected: _kind == 'event' ? '📅 Event' : '🚀 Opportunity',
                    onChanged: (v) => setState(() => _kind = v.contains('Event') ? 'event' : 'opportunity'),
                  ),
                  const SizedBox(height: 20),
                  Text('Cover image', style: AppTheme.muted(context, size: 13)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => setState(() {
                      _coverPicked = true;
                      _hue = [45.0, 200.0, 320.0, 150.0, 270.0, 175.0, 20.0, 95.0][_tags.length % 8];
                    }),
                    child: _coverPicked
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CoverBanner(hue: _hue, height: 150),
                          )
                        : Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: AppColors.s1,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.line2, style: BorderStyle.solid),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt_outlined, color: AppColors.txt3, size: 30),
                                const SizedBox(height: 8),
                                Text('Tap to upload a cover', style: AppTheme.muted(context, size: 12)),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 18),
                  _field('Title', _title, _titleErr, _kind == 'event' ? 'e.g. Intercampus Hack Night' : 'e.g. Backend Intern — FinTech'),
                  _field('Description', _desc, _descErr, 'What should students know?', maxLines: 3),
                  Row(
                    children: [
                      Expanded(child: _field(_kind == 'opportunity' ? 'Deadline' : 'Date', _date, _dateErr, 'Jun 22')),
                      if (_kind == 'event') ...[
                        const SizedBox(width: 12),
                        Expanded(child: _field('Time', _time, _timeErr, '6:00 PM')),
                      ],
                    ],
                  ),
                  Text('Campus', style: AppTheme.muted(context, size: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: MockData.campuses.map((c) {
                      final selected = _campus == c;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: OutlinedButton(
                            onPressed: () => setState(() => _campus = c),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selected ? AppColors.goldSoft : AppColors.s1,
                              side: BorderSide(color: selected ? AppColors.goldLine : AppColors.line),
                              foregroundColor: selected ? AppColors.gold2 : AppColors.txt2,
                            ),
                            child: Text(c, style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Category', style: AppTheme.muted(context, size: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cats.map((c) {
                      return CategoryPill(label: c, active: _cat == c, onTap: () => setState(() => _cat = c));
                    }).toList(),
                  ),
                  if (_kind == 'event') ...[
                    const SizedBox(height: 16),
                    _field('Max participants (optional)', _max, null, 'e.g. 100', keyboard: TextInputType.number),
                  ],
                  const SizedBox(height: 16),
                  Text('Tags', style: AppTheme.muted(context, size: 13)),
                  const SizedBox(height: 8),
                  if (_tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: _tags.map((t) => Chip(
                            label: Text('#$t'),
                            onDeleted: () => setState(() => _tags.remove(t)),
                          )).toList(),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagInput,
                          decoration: const InputDecoration(hintText: 'Add a tag'),
                          onSubmitted: (_) => _addTag(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: _addTag, child: const Text('Add')),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                    child: GoldButton(label: 'Preview', icon: Icons.visibility_outlined, outlined: true, expand: true, onPressed: () {
                      if (_validate()) _showPreview();
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: GoldButton(label: 'Publish', expand: true, onPressed: _publish)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String? err, String hint, {int maxLines = 1, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.muted(context, size: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            keyboardType: keyboard,
            decoration: InputDecoration(hintText: hint, errorText: err),
          ),
        ],
      ),
    );
  }

  void _addTag() {
    final t = _tagInput.text.trim();
    if (t.isNotEmpty && !_tags.contains(t) && _tags.length < 6) {
      setState(() {
        _tags.add(t);
        _tagInput.clear();
      });
    }
  }

  void _showPreview() {
    final preview = EventItem(
      id: 'pv',
      title: _title.text.trim().isEmpty ? 'Your event title' : _title.text.trim(),
      cat: _cat,
      kind: _kind,
      org: 'c1',
      day: 'NEW',
      date: _date.text.trim().isEmpty ? 'Date' : _date.text.trim(),
      time: _kind == 'opportunity' ? 'Deadline' : (_time.text.trim().isEmpty ? 'Time' : _time.text.trim()),
      month: '2026',
      campus: _campus,
      hue: _hue,
      going: const [],
      goingN: 0,
      interestedN: 0,
      tags: List.of(_tags),
      about: _desc.text.trim(),
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.s1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preview', style: AppTheme.heading(context, size: 18)),
            const SizedBox(height: 4),
            Text('This is how your post will appear in the feed.', style: AppTheme.muted(context, size: 12)),
            const SizedBox(height: 16),
            EventCard(event: preview),
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, child: GoldButton(label: 'Looks good — Publish', expand: true, onPressed: () { Navigator.pop(ctx); _publish(); })),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: GoldButton(label: 'Keep editing', outlined: true, expand: true, onPressed: () => Navigator.pop(ctx))),
          ],
        ),
      ),
    );
  }
}
