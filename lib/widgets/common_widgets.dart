import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.onTap, this.border});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.s1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: border ?? Border.all(color: AppColors.line),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.personId,
    this.size = 44,
    this.ring = false,
  });

  final String personId;
  final double size;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final p = MockData.people[personId]!;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [avatarGradientStart(p.hue), avatarGradientEnd(p.hue)],
        ),
        border: ring ? Border.all(color: AppColors.gold, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        p.initials,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: size * 0.32,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CoverBanner extends StatelessWidget {
  const CoverBanner({
    super.key,
    required this.hue,
    required this.height,
    this.child,
    this.borderRadius,
  });

  final double hue;
  final double height;
  final Widget? child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [coverGradientStart(hue), coverGradientEnd(hue)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _KentePainter()),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _KentePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 4;
    for (var i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(i * 18 - 20, size.height + 20),
        Offset(i * 18 + 60, -20),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ],
    );

    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.txt,
          side: const BorderSide(color: AppColors.line2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.onGold,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: child,
    );
  }
}

class CategoryPill extends StatelessWidget {
  const CategoryPill({super.key, required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: active ? AppColors.goldSoft : AppColors.s2,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: active ? AppColors.gold : AppColors.line2,
                width: active ? 1.5 : 1,
              ),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: active ? AppColors.gold2 : AppColors.txt,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryPillBar extends StatelessWidget {
  const CategoryPillBar({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 8),
  });

  final List<String> labels;
  final String selected;
  final ValueChanged<String> onSelected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: labels
            .map(
              (label) => CategoryPill(
                label: label,
                active: label == selected,
                onTap: () => onSelected(label),
              ),
            )
            .toList(),
      ),
    );
  }
}

class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.s2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: options.map((o) {
          final active = o == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(o),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? AppColors.s3 : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  o,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active ? AppColors.txt : AppColors.txt3,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold, Color(0xFF2A3F8F)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'A',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: size * 0.42,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ToastOverlay extends StatelessWidget {
  const ToastOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Stack(
          children: [
            child,
            if (state.toastMessage != null)
              Positioned(
                left: 24,
                right: 24,
                bottom: 100,
                child: Material(
                  color: AppColors.s3,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.line2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.gold, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            state.toastMessage!,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CampusTag extends StatelessWidget {
  const CampusTag({super.key, required this.campus, this.small = false});

  final String campus;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          campus == 'Virtual' ? Icons.public : Icons.location_on_outlined,
          size: small ? 13 : 15,
          color: AppColors.txt2,
        ),
        const SizedBox(width: 4),
        Text(
          campus,
          style: GoogleFonts.inter(
            fontSize: small ? 11.5 : 13,
            fontWeight: FontWeight.w500,
            color: AppColors.txt2,
          ),
        ),
      ],
    );
  }
}

class CatBadge extends StatelessWidget {
  const CatBadge({super.key, required this.cat});

  final String cat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.s2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line2),
      ),
      child: Text(
        cat,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.txt2),
      ),
    );
  }
}

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.s1,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: AppColors.txt3, size: 30),
          ),
          const SizedBox(height: 14),
          Text(title, style: AppTheme.heading(context, size: 16)),
          const SizedBox(height: 5),
          Text(subtitle, textAlign: TextAlign.center, style: AppTheme.muted(context)),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
