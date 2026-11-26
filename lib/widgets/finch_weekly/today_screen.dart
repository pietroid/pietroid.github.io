import 'package:flutter/material.dart';

import 'model.dart';
import 'plan_screen.dart' show SizeChip;
import 'ui.dart';

/// Scenario 2, every day: check-in, suggested steps, drag to adjust.
class TodayScreen extends StatelessWidget {
  const TodayScreen({required this.model, required this.onGoToPlan, required this.onGoToRetro, super.key});

  final WeekModel model;
  final VoidCallback onGoToPlan;
  final VoidCallback onGoToRetro;

  @override
  Widget build(BuildContext context) {
    if (!model.started) {
      return _Empty(
        title: 'Plan your week first',
        text: 'Set your goals and steps, then come back here each day.',
        button: 'Go to plan',
        onTap: onGoToPlan,
      );
    }
    if (model.weekOver) {
      return _Empty(
        title: 'Your week is done',
        text: 'Time to look back at what you did.',
        button: 'See my retro',
        onTap: onGoToRetro,
      );
    }
    final energy = model.energy;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        SkyHeader(
          label: 'Week ${model.week} · Day ${model.day + 1} of 7',
          title: dayLong[model.day],
          subtitle: energy == null ? 'Good to see you. How are you today?' : energy.planLabel,
        ),
        const SizedBox(height: 12),
        WeekStrip(model: model),
        const SizedBox(height: 12),
        if (energy == null)
          CheckInCard(model: model)
        else ...[
          _EnergyRow(model: model, energy: energy),
          const SizedBox(height: 12),
          PaceCard(model: model),
          const SizedBox(height: 4),
          if (model.remainingPoints == 0 && model.goals.every((g) => model.doneToday(g).isEmpty))
            _AllDone(onGoToRetro: onGoToRetro)
          else if (!model.accepted) ...[
            const SectionLabel('Suggested for today · drag to adjust'),
            for (final goal in model.goals)
              if (model.maxCount(goal) > 0) ...[
                GoalSliderCard(model: model, goal: goal),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 6),
            FinchButton(label: 'Accept plan', icon: Icons.check_rounded, onTap: model.accept),
          ] else ...[
            const SectionLabel('Today'),
            for (final goal in model.goals)
              if (model.plannedFor(goal).isNotEmpty) ...[
                TodayChecklistCard(model: model, goal: goal),
                const SizedBox(height: 10),
              ],
            if (model.plannedPointsToday == 0)
              const FinchCard(
                color: FinchColors.greenTint,
                child: Text('A rest day. Nothing planned, and that is fine.', style: TextStyle(fontSize: 15)),
              ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: FinchButton(label: 'Adjust', primary: false, onTap: model.adjust),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FinchButton(
                    label: model.day < 6 ? 'End day' : 'End week',
                    icon: Icons.nights_stay_rounded,
                    onTap: () {
                      final last = model.day == 6;
                      model.endDay();
                      if (last) onGoToRetro();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Steps you don\'t finish move to tomorrow and count in tomorrow\'s plan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: FinchColors.textSecondary),
            ),
          ],
        ],
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.title, required this.text, required this.button, required this.onTap});

  final String title;
  final String text;
  final String button;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        SkyHeader(title: title, subtitle: text),
        const SizedBox(height: 16),
        FinchButton(label: button, onTap: onTap),
      ],
    );
  }
}

class _AllDone extends StatelessWidget {
  const _AllDone({required this.onGoToRetro});

  final VoidCallback onGoToRetro;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const FinchCard(
          color: FinchColors.greenTint,
          child: Text(
            'Every step of the week is done. You can rest for the remaining days.',
            style: TextStyle(fontSize: 15, height: 1.35),
          ),
        ),
        const SizedBox(height: 12),
        FinchButton(label: 'See my retro', icon: Icons.celebration_rounded, onTap: onGoToRetro),
      ],
    );
  }
}

class WeekStrip extends StatelessWidget {
  const WeekStrip({required this.model, super.key});

  final WeekModel model;

  @override
  Widget build(BuildContext context) {
    final perDay = model.actualRetro().stepsPerDay;
    return Row(
      children: [
        for (var d = 0; d < 7; d++)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: d == model.day ? FinchColors.yellowTint : FinchColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: d == model.day ? FinchColors.yellowShadow : FinchColors.border,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    dayShort[d],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: d < model.day ? FinchColors.textSecondary : FinchColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (d < model.day || perDay[d] > 0)
                    Text(
                      '${perDay[d]}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: perDay[d] > 0 ? FinchColors.green : FinchColors.borderShadow,
                      ),
                    )
                  else
                    const Icon(Icons.circle, size: 6, color: FinchColors.border),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class CheckInCard extends StatelessWidget {
  const CheckInCard({required this.model, super.key});

  final WeekModel model;

  @override
  Widget build(BuildContext context) {
    return FinchCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How is your energy today?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'One tap. It only sizes today\'s plan.',
            style: TextStyle(fontSize: 13, color: FinchColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final e in Energy.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _EnergyTile(energy: e, onTap: () => model.checkIn(e)),
                  ),
                ),
            ],
          ),
          if (model.carriedCount > 0) ...[
            const SizedBox(height: 12),
            Pill(
              text: '${model.carriedCount} step${model.carriedCount == 1 ? '' : 's'} carried from yesterday',
              icon: Icons.redo_rounded,
              color: FinchColors.ink,
              tint: FinchColors.blueTint,
            ),
          ],
          const SizedBox(height: 6),
          Center(
            child: TextButton(
              onPressed: () => model.checkIn(Energy.ok),
              child: const Text('Skip, plan a normal day', style: TextStyle(color: FinchColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnergyTile extends StatelessWidget {
  const _EnergyTile({required this.energy, required this.onTap});

  final Energy energy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (tint, accent) = switch (energy) {
      Energy.low => (FinchColors.pinkTint, const Color(0xFFC0487E)),
      Energy.ok => (FinchColors.blueTint, const Color(0xFF3D8FC4)),
      Energy.good => (FinchColors.greenTint, FinchColors.green),
    };
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withValues(alpha: 0.25), width: 2),
          ),
          child: Column(
            children: [
              Icon(energy.icon, color: accent, size: 28),
              const SizedBox(height: 6),
              Text(
                energy.label,
                style: TextStyle(fontWeight: FontWeight.w700, color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnergyRow extends StatelessWidget {
  const _EnergyRow({required this.model, required this.energy});

  final WeekModel model;
  final Energy energy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Pill(
          text: '${energy.label} energy',
          icon: energy.icon,
          color: FinchColors.ink,
          tint: FinchColors.blueTint,
        ),
        const SizedBox(width: 8),
        Pill(
          text: 'Change',
          color: FinchColors.textSecondary,
          tint: FinchColors.border,
          onTap: model.clearCheckIn,
        ),
      ],
    );
  }
}

class PaceCard extends StatelessWidget {
  const PaceCard({required this.model, super.key});

  final WeekModel model;

  @override
  Widget build(BuildContext context) {
    final pace = model.pace;
    final total = model.totalPoints;
    final daysAfter = model.daysLeft - 1;
    final left = model.leftAfterToday;
    final String detail;
    if (left <= 0) {
      detail = 'Today\'s plan finishes the week.';
    } else if (daysAfter <= 0) {
      detail = '$left point${left == 1 ? '' : 's'} would be left after today, the last day.';
    } else {
      detail = 'After today: $left point${left == 1 ? '' : 's'} over $daysAfter day${daysAfter == 1 ? '' : 's'}.';
    }
    return FinchCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Week: ${model.donePoints} of $total points',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              Pill(text: pace.label, color: pace.color, tint: pace.tint),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              ProgressBar(
                value: total == 0 ? 0 : (model.donePoints + model.openPlannedPointsToday) / total,
                color: FinchColors.yellow,
              ),
              ProgressBar(
                value: total == 0 ? 0 : model.donePoints / total,
                color: FinchColors.green,
                background: Colors.transparent,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Today: ${model.plannedPointsToday} point${model.plannedPointsToday == 1 ? '' : 's'} planned. $detail',
            style: const TextStyle(fontSize: 13, color: FinchColors.textSecondary, height: 1.35),
          ),
          if (pace == Pace.outOfReach) ...[
            const SizedBox(height: 6),
            const Text(
              'Tip: drop a step or swap a Big one for a Quick one in your plan.',
              style: TextStyle(fontSize: 13, color: Color(0xFFC0487E)),
            ),
          ],
        ],
      ),
    );
  }
}

class GoalSliderCard extends StatelessWidget {
  const GoalSliderCard({required this.model, required this.goal, super.key});

  final WeekModel model;
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final p = goal.palette;
    final min = model.minCount(goal);
    final max = model.maxCount(goal);
    final count = (model.todayCount[goal.id] ?? min).clamp(min, max);
    final planned = model.plannedFor(goal);
    return FinchCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GoalIcon(icon: p.icon, accent: p.accent, tint: p.tint, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(goal.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              Text(
                '$count of $max steps',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: p.accent),
              ),
            ],
          ),
          if (max > min)
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                activeTrackColor: p.accent,
                inactiveTrackColor: p.tint,
                thumbColor: FinchColors.yellow,
                overlayColor: FinchColors.yellow.withValues(alpha: 0.2),
                activeTickMarkColor: Colors.white.withValues(alpha: 0.7),
                inactiveTickMarkColor: p.accent.withValues(alpha: 0.3),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
                showValueIndicator: ShowValueIndicator.never,
              ),
              child: Slider(
                value: count.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: max - min,
                onChanged: (v) => model.setCount(goal, v.round()),
              ),
            ),
          if (planned.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text('Nothing today', style: TextStyle(fontSize: 13, color: FinchColors.textSecondary)),
            ),
          for (final s in planned) _StepLine(step: s, accent: p.accent),
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.step, required this.accent});

  final GoalStep step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            step.done ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 16,
            color: step.done ? accent : FinchColors.borderShadow,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(step.title, style: const TextStyle(fontSize: 14))),
          if (step.carriedFrom != null) ...[
            Pill(
              text: 'from ${dayShort[step.carriedFrom!]}',
              icon: Icons.redo_rounded,
              color: FinchColors.ink,
              tint: FinchColors.blueTint,
            ),
            const SizedBox(width: 6),
          ],
          IgnorePointer(
            child: SizeChip(size: step.size, onTap: () {}),
          ),
        ],
      ),
    );
  }
}

class TodayChecklistCard extends StatelessWidget {
  const TodayChecklistCard({required this.model, required this.goal, super.key});

  final WeekModel model;
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final p = goal.palette;
    final planned = model.plannedFor(goal);
    return FinchCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 4),
              GoalIcon(icon: p.icon, accent: p.accent, tint: p.tint, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(goal.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final s in planned)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => model.toggle(s),
              child: Row(
                children: [
                  Checkbox(
                    value: s.done,
                    activeColor: p.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    onChanged: (_) => model.toggle(s),
                  ),
                  Expanded(
                    child: Text(
                      s.title,
                      style: TextStyle(
                        fontSize: 15,
                        decoration: s.done ? TextDecoration.lineThrough : null,
                        color: s.done ? FinchColors.textSecondary : FinchColors.text,
                      ),
                    ),
                  ),
                  if (s.carriedFrom != null && !s.done) ...[
                    Pill(
                      text: 'from ${dayShort[s.carriedFrom!]}',
                      icon: Icons.redo_rounded,
                      color: FinchColors.ink,
                      tint: FinchColors.blueTint,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    '+${s.size.points}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.accent),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
