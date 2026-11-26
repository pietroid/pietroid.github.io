import 'package:flutter/material.dart';

/// Design tokens taken from finchcare.com's CSS ("nest" variables).
class FinchColors {
  static const text = Color(0xFF313131);
  static const textSecondary = Color(0xFF66757F);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceHigh = Color(0xFFF8F8F8);
  static const border = Color(0xFFF0F0F0);
  static const borderShadow = Color(0xFFD7D7DC);
  static const greenTint = Color(0xFFEAF6EA);
  static const blueTint = Color(0xFFEBF3F9);
  static const pinkTint = Color(0xFFFCF4F8);
  static const yellowTint = Color(0xFFFFF8E8);
  static const yellow = Color(0xFFFFC954);
  static const yellowShadow = Color(0xFFF1B712);
  static const yellowBorder = Color(0xFFF8DFA2);
  static const green = Color(0xFF0AA46C);
  static const greenDark = Color(0xFF169B43);
  static const grass = Color(0xFF75D975);
  static const skyTop = Color(0xFF72CAFC);
  static const skyBottom = Color(0xFFB8DFF4);
  static const ink = Color(0xFF386D84);
  static const sun = Color(0xFFF6D980);
  static const sunCore = Color(0xFFFFC354);
}

class FinchRadius {
  static const card = 24.0;
  static const button = 12.0;
}

ThemeData finchTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    scaffoldBackgroundColor: FinchColors.surfaceHigh,
    colorScheme: ColorScheme.fromSeed(seedColor: FinchColors.green, surface: FinchColors.surface),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: FinchColors.text, displayColor: FinchColors.text),
  );
}

/// Sky gradient header with the site's sun, as on finchcare.com.
class SkyHeader extends StatelessWidget {
  const SkyHeader({required this.title, required this.subtitle, this.label, super.key});

  final String title;
  final String subtitle;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(FinchRadius.card),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [FinchColors.skyTop, FinchColors.skyBottom],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -46,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(color: FinchColors.sun, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(color: FinchColors.sunCore, shape: BoxShape.circle),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(height: 10, color: FinchColors.grass),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null)
                  Text(
                    label!.toUpperCase(),
                    style: const TextStyle(
                      color: FinchColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),
                const SizedBox(height: 4),
                OutlineText(title),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: FinchColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
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

/// White text with a thick ink outline, like the finchcare.com headline.
class OutlineText extends StatelessWidget {
  const OutlineText(this.text, {this.size = 28, super.key});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: size, fontWeight: FontWeight.w700, height: 1.125);
    return Stack(
      children: [
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..strokeJoin = StrokeJoin.round
              ..color = FinchColors.ink,
            shadows: const [Shadow(color: FinchColors.ink, offset: Offset(0, 2))],
          ),
        ),
        Text(text, style: style.copyWith(color: Colors.white)),
      ],
    );
  }
}

class FinchCard extends StatelessWidget {
  const FinchCard({required this.child, this.color = FinchColors.surface, this.padding, this.borderColor, super.key});

  final Widget child;
  final Color color;
  final EdgeInsets? padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(FinchRadius.card),
        border: Border.all(color: borderColor ?? FinchColors.border, width: 2),
      ),
      child: child,
    );
  }
}

/// Chunky button with a solid bottom shadow, Finch style.
class FinchButton extends StatefulWidget {
  const FinchButton({required this.label, required this.onTap, this.icon, this.primary = true, super.key});

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool primary;

  @override
  State<FinchButton> createState() => _FinchButtonState();
}

class _FinchButtonState extends State<FinchButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final fill = widget.primary ? FinchColors.yellow : FinchColors.surface;
    final shadow = widget.primary ? FinchColors.yellowShadow : FinchColors.borderShadow;
    final border = widget.primary ? FinchColors.yellowShadow : FinchColors.border;
    final depth = _pressed ? 0.0 : 4.0;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: enabled
            ? (_) {
                setState(() => _pressed = false);
                widget.onTap!();
              }
            : null,
        child: MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            margin: EdgeInsets.only(top: 4 - depth),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(FinchRadius.button),
              border: Border.all(color: border, width: 1.5),
              boxShadow: [BoxShadow(color: shadow, offset: Offset(0, depth))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 20, color: FinchColors.text),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: FinchColors.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          color: FinchColors.textSecondary,
        ),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({required this.text, required this.color, required this.tint, this.icon, this.onTap, super.key});

  final String text;
  final Color color;
  final Color tint;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(99)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
            Text(
              text,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalIcon extends StatelessWidget {
  const GoalIcon({required this.icon, required this.accent, required this.tint, this.size = 36, super.key});

  final IconData icon;
  final Color accent;
  final Color tint;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
      child: Icon(icon, color: accent, size: size * 0.55),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.value, required this.color, this.background = FinchColors.border, super.key});

  final double value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Container(
        height: 10,
        color: background,
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 300),
          widthFactor: value.clamp(0, 1),
          child: Container(
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
          ),
        ),
      ),
    );
  }
}
