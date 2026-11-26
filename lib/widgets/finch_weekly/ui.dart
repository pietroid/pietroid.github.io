import 'package:flutter/material.dart';

/// Look of the Finch app's home list: green background, white pill cards,
/// a round icon badge on the left and a chunky check button on the right.
class FinchColors {
  static const background = Color(0xFF7DB65F);
  static const text = Color(0xFF2F2F2F);
  static const textSecondary = Color(0xFF7A7A7A);
  static const card = Color(0xFFFFFFFF);
  static const badge = Color(0xFFF2F2F4);
  static const button = Color(0xFFF0F0F2);
  static const buttonShadow = Color(0xFFD5D5DA);
  static const check = Color(0xFF3EA44E);
  static const yellow = Color(0xFFFFC954);
  static const yellowShadow = Color(0xFFE5AC1E);
  static const onBackground = Colors.white;
  static const onBackgroundMuted = Color(0xCCFFFFFF);
  static const line = Color(0x66FFFFFF);
  static const ghost = Color(0x33FFFFFF);
}

class FinchRadius {
  static const card = 26.0;
  static const button = 12.0;
}

ThemeData finchTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    scaffoldBackgroundColor: FinchColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: FinchColors.check, surface: FinchColors.card),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: FinchColors.text, displayColor: FinchColors.text),
  );
}

/// Scrollable screen body on the green background.
class FinchList extends StatelessWidget {
  const FinchList({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(14, 14, 14, 20), children: children);
  }
}

/// White title block at the top of a screen.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle({required this.title, this.label, this.subtitle, super.key});

  final String title;
  final String? label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: const TextStyle(color: FinchColors.onBackgroundMuted, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          Text(
            title,
            style: const TextStyle(color: FinchColors.onBackground, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: const TextStyle(color: FinchColors.onBackgroundMuted, fontSize: 13, height: 1.3),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Start the day ———— (+)" style group header.
class GroupHeader extends StatelessWidget {
  const GroupHeader({required this.title, this.trailing = const [], super.key});

  final String title;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 2, 6),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: FinchColors.onBackground, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1.5, color: FinchColors.line)),
          for (final t in trailing) ...[const SizedBox(width: 8), t],
        ],
      ),
    );
  }
}

/// Small round translucent button on the green background, like the "+".
class GhostIconButton extends StatelessWidget {
  const GhostIconButton({required this.icon, required this.onTap, this.tooltip, super.key});

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      cursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1,
          child: Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(color: FinchColors.ghost, shape: BoxShape.circle),
            child: Icon(icon, size: 17, color: FinchColors.onBackground),
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// White pill card: icon badge, bold title, optional subtitle and trailing.
class GoalCard extends StatelessWidget {
  const GoalCard({
    required this.title,
    required this.icon,
    required this.accent,
    this.subtitle,
    this.trailing,
    this.muted = false,
    super.key,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final String? subtitle;
  final Widget? trailing;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(color: FinchColors.card, borderRadius: BorderRadius.circular(FinchRadius.card)),
      child: Row(
        children: [
          IconBadge(icon: icon, accent: accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: muted ? FinchColors.textSecondary : FinchColors.text,
                  ),
                ),
                if (subtitle != null)
                  Text(subtitle!, style: const TextStyle(fontSize: 11.5, color: FinchColors.textSecondary)),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

/// Round grey badge holding the mission's icon.
class IconBadge extends StatelessWidget {
  const IconBadge({required this.icon, required this.accent, this.size = 36, super.key});

  final IconData icon;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: FinchColors.badge, shape: BoxShape.circle),
      child: Icon(icon, color: accent, size: size * 0.52),
    );
  }
}

/// Chunky grey square button with a solid bottom shadow, like the check.
class ChunkyIconButton extends StatelessWidget {
  const ChunkyIconButton({
    required this.icon,
    required this.onTap,
    this.color = FinchColors.check,
    this.filled = false,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final bool filled;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final shadow = filled ? Color.lerp(color, Colors.black, 0.2)! : FinchColors.buttonShadow;
    final button = MouseRegion(
      cursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 34,
          margin: const EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
            color: filled ? color : FinchColors.button,
            borderRadius: BorderRadius.circular(FinchRadius.button),
            boxShadow: [BoxShadow(color: shadow, offset: const Offset(0, 3))],
          ),
          child: Icon(icon, size: 22, color: filled ? Colors.white : color),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// White rounded card for blocks that are not a single goal.
class WhiteCard extends StatelessWidget {
  const WhiteCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(color: FinchColors.card, borderRadius: BorderRadius.circular(22)),
      child: child,
    );
  }
}

/// Big yellow button with a solid bottom shadow.
class FinchButton extends StatelessWidget {
  const FinchButton({required this.label, required this.onTap, this.light = false, super.key});

  final String label;
  final VoidCallback? onTap;

  /// White variant, for secondary actions.
  final bool light;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: light ? FinchColors.card : FinchColors.yellow,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: light ? FinchColors.buttonShadow : FinchColors.yellowShadow,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: FinchColors.text),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small rounded label.
class Tag extends StatelessWidget {
  const Tag(this.text, {this.color = FinchColors.textSecondary, this.background = FinchColors.badge, super.key});

  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(99)),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.value, required this.color, super.key});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Container(
        height: 8,
        color: FinchColors.badge,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0, 1),
          child: Container(
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
          ),
        ),
      ),
    );
  }
}

/// Borderless text field, for typing inside a white pill.
InputDecoration pillInput(String hint) => const InputDecoration(
  isDense: true,
  border: InputBorder.none,
  contentPadding: EdgeInsets.symmetric(vertical: 9),
).copyWith(
  hintText: hint,
  hintStyle: const TextStyle(color: FinchColors.textSecondary, fontWeight: FontWeight.w500),
);
