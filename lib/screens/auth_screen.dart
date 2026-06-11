import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/phase_scaffold.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _signIn = true;
  String _role = 'Student';
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _nameErr = false;
  bool _emailErr = false;
  bool _pwErr = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _nameErr = !_signIn && _nameCtrl.text.trim().isEmpty;
      _emailErr = !RegExp(r'.+@.+\..+').hasMatch(_emailCtrl.text);
      _pwErr = _pwCtrl.text.length < 4;
    });
    if (_nameErr || _emailErr || _pwErr) return;
    context.read<AppState>().authenticate(_role);
  }

  @override
  Widget build(BuildContext context) {
    return PhaseScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogo(size: 48),
            const SizedBox(height: 26),
            Text(
              _signIn ? 'Welcome back' : 'Create your account',
              style: AppTheme.heading(context, size: 28),
            ),
            const SizedBox(height: 6),
            Text(
              _signIn
                  ? 'Sign in to connect across ALU campuses.'
                  : 'Join the ALU intercampus community.',
              style: AppTheme.muted(context, size: 14.5),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.read<AppState>().authenticate(_role),
                icon: const Icon(Icons.school_outlined, color: Color(0xFF1F1F1F)),
                label: Text(
                  'Sign in with ALU Account',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F1F1F),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.line)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text('or with email', style: AppTheme.muted(context, size: 12)),
                ),
                const Expanded(child: Divider(color: AppColors.line)),
              ],
            ),
            const SizedBox(height: 22),
            if (!_signIn) ...[
              _AuthField(
                label: 'Full name',
                child: TextField(
                  controller: _nameCtrl,
                  style: GoogleFonts.inter(color: AppColors.txt),
                  decoration: InputDecoration(
                    hintText: 'Amara Okafor',
                    errorText: _nameErr ? 'Required' : null,
                  ),
                ),
              ),
            ],
            _AuthField(
              label: 'ALU email',
              child: TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(color: AppColors.txt),
                decoration: InputDecoration(
                  hintText: 'you@alustudent.com',
                  errorText: _emailErr ? 'Enter a valid email address.' : null,
                ),
              ),
            ),
            _AuthField(
              label: 'Password',
              child: TextField(
                controller: _pwCtrl,
                obscureText: true,
                style: GoogleFonts.inter(color: AppColors.txt),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  errorText: _pwErr ? 'At least 4 characters.' : null,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text('I am a…', style: AppTheme.muted(context, size: 13)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 9,
              crossAxisSpacing: 9,
              childAspectRatio: 2.35,
              children: MockData.roles.map((r) {
                final selected = _role == r;
                return OutlinedButton(
                  onPressed: () => setState(() => _role = r),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selected ? AppColors.goldSoft : AppColors.s1,
                    side: BorderSide(
                      color: selected ? AppColors.goldLine : AppColors.line,
                    ),
                    foregroundColor: selected ? AppColors.gold2 : AppColors.txt2,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: selected ? AppColors.gold : AppColors.s3,
                            width: selected ? 5 : 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r,
                          style: GoogleFonts.inter(fontSize: 13.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (_role == 'Club Leader' || _role == 'Organizer')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Posting unlocked — you can publish events & opportunities.',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.gold2),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: GoldButton(
                label: _signIn ? 'Sign in' : 'Create account',
                expand: true,
                onPressed: _submit,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () => setState(() {
                  _signIn = !_signIn;
                  _nameErr = _emailErr = _pwErr = false;
                }),
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.inter(color: AppColors.txt2, fontSize: 14),
                    children: [
                      TextSpan(text: _signIn ? 'New here? ' : 'Already have an account? '),
                      TextSpan(
                        text: _signIn ? 'Create account' : 'Sign in',
                        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.muted(context, size: 13)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
