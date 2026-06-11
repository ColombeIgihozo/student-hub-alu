import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/phase_scaffold.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _index = 0;

  static const _slides = [
    (
      title: 'Discover Opportunities',
      desc:
          'Hackathons, internships, workshops and startup events from Kigali to Mauritius — all in one feed.',
      icon: Icons.explore_outlined,
    ),
    (
      title: 'Join Communities',
      desc:
          'Find your people. Join clubs, follow what they post, and never miss what your communities are building.',
      icon: Icons.groups_outlined,
    ),
    (
      title: 'Lead & Collaborate',
      desc:
          'RSVP, chat, earn badges and keep your streak alive. Engagement is leadership at ALU.',
      icon: Icons.emoji_events_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_index];
    final last = _index == _slides.length - 1;

    return PhaseScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppLogo(size: 36),
                TextButton(
                  onPressed: () => context.read<AppState>().setPhase(AppPhase.auth),
                  child: Text('Skip', style: GoogleFonts.inter(color: AppColors.txt2)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 168,
                    height: 168,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44),
                      gradient: const LinearGradient(
                        colors: [AppColors.gold, Color(0xFF2A3F8F)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.3),
                          blurRadius: 50,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Icon(slide.icon, size: 74, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: AppTheme.heading(context, size: 30),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    slide.desc,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15.5,
                      color: AppColors.txt2,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (k) {
                    final active = k == _index;
                    return GestureDetector(
                      onTap: () => setState(() => _index = k),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: active ? 26 : 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: active ? AppColors.gold : AppColors.s3,
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: GoldButton(
                    label: last ? 'Get Started' : 'Next',
                    icon: Icons.arrow_forward,
                    expand: true,
                    onPressed: () {
                      if (last) {
                        context.read<AppState>().setPhase(AppPhase.auth);
                      } else {
                        setState(() => _index++);
                      }
                    },
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
