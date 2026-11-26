import 'dart:math';

import 'package:flutter/material.dart';

import 'model.dart';
import 'ui.dart';

enum RetroSource {
  actual('My week'),
  partial('Partial'),
  perfect('All done');

  const RetroSource(this.label);

  final String label;
}

/// Scenario 3, end of the week: something is always celebrated.
class RetroScreen extends StatefulWidget {
  const RetroScreen({required this.model, required this.onPlanNext, super.key});

  final WeekModel model;
  final VoidCallback onPlanNext;

  @override
  State<RetroScreen> createState() => _RetroScreenState();
}

class _RetroScreenState extends State<RetroScreen> {
  late RetroSource _source;

  @override
  void initState() {
    super.initState();
    final hasProgress = widget.model.actualRetro().stepsDone > 0;
    _source = widget.model.weekOver || hasProgress ? RetroSource.actual : RetroSource.partial;
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final data = switch (_source) {
      RetroSource.actual => model.actualRetro(),
      RetroSource.partial => model.simulatedRetro(perfect: false),
      RetroSource.perfect => model.simulatedRetro(perfect: true),
    };
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        SkyHeader(
          label: 'Week ${model.week} · Sunday',
          title: 'Your week',
          subtitle: 'A look back at what you did. No grades, just good moments.',
        ),
        const SizedBox(height: 12),
        if (!model.weekOver) ...[
          FinchCard(
            color: FinchColors.blueTint,
            borderColor: FinchColors.skyBottom,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.started
                      ? 'Demo: it is only ${dayLong[model.day]}. Preview the retro with:'
                      : 'Demo: the week has not started. Preview with:',
                  style: const TextStyle(fontSize: 13, color: FinchColors.ink),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final s in RetroSource.values)
                      ChoiceChip(
                        label: Text(s.label),
                        selected: s == _source,
                        showCheckmark: false,
                        selectedColor: FinchColors.yellow,
                        backgroundColor: FinchColors.surface,
                        side: const BorderSide(color: FinchColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinchRadius.button)),
                        labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: FinchColors.text),
                        onSelected: (_) => setState(() => _source = s),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        CelebrationCard(key: ValueKey('${_source.name}-${data.allDone}'), data: data),
        const SizedBox(height: 12),
        DayBarsCard(data: data),
        const SizedBox(height: 12),
        VersusLastWeekCard(data: data),
        const SizedBox(height: 12),
        GoalsDoneCard(data: data),
        const SizedBox(height: 16),
        FinchButton(
          label: 'Plan next week',
          icon: Icons.arrow_forward_rounded,
          onTap: () {
            model.planNextWeek();
            widget.onPlanNext();
          },
        ),
      ],
    );
  }
}

class CelebrationCard extends StatelessWidget {
  const CelebrationCard({required this.data, super.key});

  final RetroData data;

  @override
  Widget build(BuildContext context) {
    final String title;
    final String text;
    final IconData icon;
    if (data.allDone) {
      title = 'You finished every step!';
      text = 'All ${data.stepsTotal} steps across ${data.goals.length} goals. Take a bow.';
      icon = Icons.emoji_events_rounded;
    } else if (data.stepsDone > 0) {
      final best = data.bestDays.map((d) => dayLong[d]).toList();
      final names = best.length == 1 ? best.first : '${best.sublist(0, best.length - 1).join(', ')} and ${best.last}';
      title = best.length == 1 ? 'Your best day was $names' : '$names were your best days';
      text =
          'You did ${data.bestCount} step${data.bestCount == 1 ? '' : 's'} on '
          '${best.length == 1 ? 'that day' : 'each of them'}, '
          'and ${data.stepsDone} in the whole week.';
      icon = Icons.star_rounded;
    } else if (data.checkInDays > 0) {
      title = 'You showed up ${data.checkInDays} day${data.checkInDays == 1 ? '' : 's'}';
      text = 'Checking in counts. Some weeks are for resting.';
      icon = Icons.favorite_rounded;
    } else {
      title = 'You made a plan';
      text = '${data.goals.length} goals and ${data.stepsTotal} steps. Planning is a step too.';
      icon = Icons.favorite_rounded;
    }
    return Stack(
      children: [
        FinchCard(
          color: FinchColors.yellowTint,
          borderColor: FinchColors.yellowBorder,
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: FinchColors.yellow, shape: BoxShape.circle),
                child: Icon(icon, size: 38, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.2),
              ),
              const SizedBox(height: 6),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: FinchColors.textSecondary, height: 1.35),
              ),
            ],
          ),
        ),
        if (data.allDone || data.stepsDone > 0)
          Positioned.fill(
            child: IgnorePointer(child: Confetti(dense: data.allDone)),
          ),
      ],
    );
  }
}

class DayBarsCard extends StatelessWidget {
  const DayBarsCard({required this.data, super.key});

  final RetroData data;

  @override
  Widget build(BuildContext context) {
    final top = max(1, max(data.bestCount, data.lastWeek.reduce(max)));
    const maxHeight = 90.0;
    final best = data.bestDays.toSet();
    return FinchCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Steps per day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          SizedBox(
            height: maxHeight + 44,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var d = 0; d < 7; d++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (best.contains(d))
                          const Icon(Icons.star_rounded, size: 16, color: FinchColors.yellowShadow)
                        else
                          Text(
                            data.stepsPerDay[d] > 0 ? '${data.stepsPerDay[d]}' : '',
                            style: const TextStyle(fontSize: 11, color: FinchColors.textSecondary),
                          ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: maxHeight,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 22,
                                height: data.lastWeek[d] / top * maxHeight,
                                decoration: BoxDecoration(
                                  color: FinchColors.border,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: data.stepsPerDay[d] / top * maxHeight),
                                duration: Duration(milliseconds: 400 + d * 60),
                                curve: Curves.easeOutBack,
                                builder: (context, h, _) => Container(
                                  width: 14,
                                  height: max(0, h),
                                  decoration: BoxDecoration(
                                    color: best.contains(d) ? FinchColors.yellow : FinchColors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dayShort[d],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: best.contains(d) ? FontWeight.w700 : FontWeight.w400,
                            color: FinchColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _legend(FinchColors.green, 'This week'),
              const SizedBox(width: 14),
              _legend(FinchColors.yellow, 'Best day'),
              const SizedBox(width: 14),
              _legend(FinchColors.border, 'Last week'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) => Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11, color: FinchColors.textSecondary)),
    ],
  );
}

class VersusLastWeekCard extends StatelessWidget {
  const VersusLastWeekCard({required this.data, super.key});

  final RetroData data;

  @override
  Widget build(BuildContext context) {
    final now = data.stepsDone;
    final before = data.lastWeekDone;
    final diff = now - before;
    final String headline;
    final String text;
    if (diff > 0) {
      headline = '+$diff steps vs last week';
      text = 'You grew from $before to $now steps.';
    } else if (diff == 0) {
      headline = 'Same as last week';
      text = '$now steps both weeks. Steady is a superpower.';
    } else {
      headline = 'A lighter week';
      text =
          '$now steps vs $before last week, and you were active on ${data.activeDays} '
          'day${data.activeDays == 1 ? '' : 's'}. Rest is part of it.';
    }
    final top = max(1, max(now, before));
    return FinchCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(headline, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              if (diff > 0) const Icon(Icons.trending_up_rounded, color: FinchColors.green),
            ],
          ),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 13, color: FinchColors.textSecondary, height: 1.35)),
          const SizedBox(height: 12),
          _bar('This week', now, now / top, FinchColors.green),
          const SizedBox(height: 8),
          _bar('Last week', before, before / top, FinchColors.borderShadow),
        ],
      ),
    );
  }

  Widget _bar(String label, int value, double fraction, Color color) => Row(
    children: [
      SizedBox(
        width: 72,
        child: Text(label, style: const TextStyle(fontSize: 12, color: FinchColors.textSecondary)),
      ),
      Expanded(
        child: ProgressBar(value: fraction, color: color),
      ),
      SizedBox(
        width: 28,
        child: Text(
          '$value',
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}

class GoalsDoneCard extends StatelessWidget {
  const GoalsDoneCard({required this.data, super.key});

  final RetroData data;

  @override
  Widget build(BuildContext context) {
    return FinchCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Goals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          for (final g in data.goals) ...[
            Row(
              children: [
                GoalIcon(icon: g.goal.palette.icon, accent: g.goal.palette.accent, tint: g.goal.palette.tint, size: 28),
                const SizedBox(width: 10),
                Expanded(child: Text(g.goal.title, style: const TextStyle(fontSize: 14))),
                if (g.total > 0 && g.done == g.total)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.check_circle_rounded, size: 16, color: FinchColors.green),
                  ),
                Text(
                  '${g.done}/${g.total}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: g.goal.palette.accent),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ProgressBar(
              value: g.total == 0 ? 0 : g.done / g.total,
              color: g.goal.palette.accent,
              background: g.goal.palette.tint,
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

/// A short burst of falling confetti, drawn once when the card appears.
class Confetti extends StatefulWidget {
  const Confetti({this.dense = true, super.key});

  final bool dense;

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _ConfettiPainter(_controller.value, widget.dense ? 60 : 24),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.count);

  final double t;
  final int count;

  static const _colors = [
    FinchColors.yellow,
    FinchColors.green,
    FinchColors.skyTop,
    Color(0xFFD96FA0),
    FinchColors.sunCore,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (t >= 1) return;
    final random = Random(7);
    final fade = t < 0.75 ? 1.0 : (1 - t) / 0.25;
    for (var i = 0; i < count; i++) {
      final x0 = random.nextDouble() * size.width;
      final delay = random.nextDouble() * 0.3;
      final speed = 0.6 + random.nextDouble() * 0.8;
      final drift = (random.nextDouble() - 0.5) * 60;
      final spin = random.nextDouble() * pi * 4;
      final color = _colors[i % _colors.length];
      final p = ((t - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (p <= 0) continue;
      final y = -10 + p * speed * (size.height + 20);
      final x = x0 + sin(p * pi * 2) * drift * 0.3 + drift * p;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(spin * p);
      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(-4, -2.5, 8, 5), const Radius.circular(1.5)),
        Paint()..color = color.withValues(alpha: fade),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
