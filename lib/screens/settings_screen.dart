import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminders = true;
  bool _streak = true;
  bool _digest = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final rows = [
      (Icons.notifications_outlined, 'Notifications', 'Push, email & in-app', () => app.push('notifications')),
      (Icons.person_outline, 'Account Settings', 'Name, email, password', () => app.showToast('Coming soon')),
      (Icons.public, 'Campus', 'ALU Kigali', () => app.showToast('Coming soon')),
      (Icons.help_outline, 'Help & Support', 'FAQs and contact', () => app.showToast('Coming soon')),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(onPressed: app.pop, icon: const Icon(Icons.arrow_back)),
                  Text('Settings', style: AppTheme.heading(context, size: 21)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const PersonAvatar(personId: 'me', size: 52),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(MockData.people['me']!.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
                              Text('amara@alustudent.com', style: AppTheme.muted(context, size: 12)),
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
                          child: Text(app.role, style: GoogleFonts.inter(color: AppColors.gold2, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...rows.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          padding: const EdgeInsets.all(14),
                          onTap: r.$4,
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.s2,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Icon(r.$1, color: AppColors.gold, size: 19),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.$2, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.5)),
                                    Text(r.$3, style: AppTheme.muted(context, size: 12)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.txt3),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _ToggleRow(label: 'Event reminders', value: _reminders, onChanged: (v) => setState(() => _reminders = v)),
                        const Divider(color: AppColors.line, height: 1),
                        _ToggleRow(label: 'Streak nudges', value: _streak, onChanged: (v) => setState(() => _streak = v)),
                        const Divider(color: AppColors.line, height: 1),
                        _ToggleRow(label: 'Community digest', value: _digest, onChanged: (v) => setState(() => _digest = v)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: app.logout,
                      icon: const Icon(Icons.logout, color: AppColors.error),
                      label: Text('Log out', style: GoogleFonts.inter(color: AppColors.error, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0x1FE76F51),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(child: Text('ALU Intercampus Connect · v1.0', style: AppTheme.muted(context, size: 12))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14.5)),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? AppColors.gold : AppColors.s3,
                borderRadius: BorderRadius.circular(999),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
