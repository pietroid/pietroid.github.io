import 'package:flutter/material.dart';

import 'model.dart';
import 'ui.dart';

/// Moment 2, daily: a one-tap mood check-in sizes today's goals.
class TodayScreen extends StatelessWidget {
  const TodayScreen({required this.model, required this.onGoToPlan, required this.onGoToRetro, super.key});

  final WeekModel model;
  final VoidCallback onGoToPlan;
  final VoidCallback onGoToRetro;

  @override
  Widget build(BuildContext context) {
    if (!model.started) {
      return FinchList(
        children: [
          const ScreenTitle(
            title: 'Plan your week first',
            subtitle: 'Set your missions and their goals, then come back here each day.',
          ),
          const SizedBox(height: 8),
          FinchButton(label: 'Go to missions', onTap: onGoToPlan),
        ],
      );
    }
    if (model.weekOver) {
      return FinchList(
        children: [
          const ScreenTitle(title: 'Your week is done', subtitle: 'Time to look back at what you did.'),
          const SizedBox(height: 8),
          FinchButton(label: 'See my week', onTap: onGoToRetro),
        ],
      );
    }

    final mood = model.mood;
    final left = model.leftToday;
    final String title;
    if (mood == null) {
      final week = model.remainingGoals;
      title = '$week goal${week == 1 ? '' : 's'} left this week';
    } else if (!model.accepted) {
      final n = model.plannedToday;
      title = 'Plan today: $n goal${n == 1 ? '' : 's'}';
    } else if (model.plannedToday == 0) {
      title = 'A rest day today';
    } else if (left == 0) {
      title = 'All done for today!';
    } else {
      title = '$left goal${left == 1 ? '' : 's'} left for today!';
    }

    final body = FinchList(
      children: [
        ScreenTitle(label: '${dayLong[model.day]} · day ${model.day + 1} of 7', title: title),
        const SizedBox(height: 2),
        WeekStrip(model: model),
        const SizedBox(height: 8),
        if (mood == null)
          CheckInCard(model: model)
        else ...[
          _MoodRow(model: model, mood: mood),
          if (model.remainingGoals == 0 && model.missions.every((m) => model.doneToday(m).isEmpty)) ...[
            const SizedBox(height: 12),
            const WhiteCard(
              child: Text(
                'Every goal of the week is done. Enjoy the rest of it.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.35),
              ),
            ),
            FinchButton(label: 'See my week', onTap: onGoToRetro),
          ] else if (!model.accepted) ...[
            // Planning the day: adjust the suggestion, then start the day.
            for (final mission in model.missions)
              if (model.plannedFor(mission).isNotEmpty || mission.remaining.isNotEmpty)
                _MissionToday(model: model, mission: mission, planning: true),
            const SizedBox(height: 8),
            FinchButton(label: 'Start my day', onTap: model.accept),
            const _Hint('Suggested from what is left and your mood. Use − / + to change it.'),
          ] else ...[
            // Doing the day: tick goals off.
            for (final mission in model.missions)
              if (model.plannedFor(mission).isNotEmpty) _MissionToday(model: model, mission: mission, planning: false),
            if (model.plannedToday == 0)
              const WhiteCard(
                child: Text('Nothing planned today, and that is fine.', style: TextStyle(fontSize: 14)),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FinchButton(label: 'Adjust plan', light: true, onTap: model.adjust),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FinchButton(
                    label: model.day < 6 ? 'End the day' : 'End the week',
                    onTap: () {
                      final last = model.day == 6;
                      model.endDay();
                      if (last) onGoToRetro();
                    },
                  ),
                ),
              ],
            ),
            const _Hint('Goals you don\'t finish move to tomorrow.'),
          ],
        ],
      ],
    );
    if (mood != null) return body;

    // Before the check-in, a way to the end of the week, pinned at the
    // bottom so the next moment is easy to find.
    return Column(
      children: [
        Expanded(child: body),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
          child: FinchButton(label: 'End the week', light: true, onTap: onGoToRetro),
        ),
      ],
    );
  }
}

/// Mon–Sun row: goals done each day, today highlighted.
class WeekStrip extends StatelessWidget {
  const WeekStrip({required this.model, super.key});

  final WeekModel model;

  @override
  Widget build(BuildContext context) {
    final perDay = List.filled(7, 0);
    for (final m in model.missions) {
      for (final g in m.goals) {
        if (g.doneDay != null && g.doneDay! < 7) perDay[g.doneDay!]++;
      }
    }
    return Row(
      children: [
        for (var d = 0; d < 7; d++)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: d == model.day ? FinchColors.card : FinchColors.ghost,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    dayShort[d],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: d == model.day ? FinchColors.text : FinchColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    perDay[d] > 0 ? '${perDay[d]}' : (d < model.day ? '0' : '·'),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: d == model.day ? FinchColors.check : FinchColors.onBackground,
                    ),
                  ),
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
    final carried = model.carriedCount;
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How are you feeling?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'One tap. It only decides how many goals land on today.',
            style: TextStyle(fontSize: 12.5, color: FinchColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final m in Mood.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _MoodTile(mood: m, onTap: () => model.checkIn(m)),
                  ),
                ),
            ],
          ),
          if (carried > 0) ...[
            const SizedBox(height: 14),
            Tag('$carried goal${carried == 1 ? '' : 's'} carried from yesterday'),
          ],
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () => model.checkIn(Mood.ok),
              child: const Text('Skip, plan a normal day', style: TextStyle(color: FinchColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodTile extends StatelessWidget {
  const _MoodTile({required this.mood, required this.onTap});

  final Mood mood;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: FinchColors.button,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: FinchColors.buttonShadow, offset: Offset(0, 4))],
          ),
          child: Column(
            children: [
              Icon(mood.icon, color: FinchColors.check, size: 26),
              const SizedBox(height: 4),
              Text(mood.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodRow extends StatelessWidget {
  const _MoodRow({required this.model, required this.mood});

  final WeekModel model;
  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(mood.icon, color: FinchColors.onBackground, size: 20),
          const SizedBox(width: 6),
          Text(
            'Feeling ${mood.label.toLowerCase()}',
            style: const TextStyle(color: FinchColors.onBackground, fontSize: 13.5, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: model.clearCheckIn,
              child: const Text(
                'Change',
                style: TextStyle(
                  color: FinchColors.onBackgroundMuted,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: FinchColors.onBackgroundMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: FinchColors.onBackgroundMuted),
      ),
    );
  }
}

/// A mission's goals for today. While planning: − / + to take fewer or
/// more. While doing: a check button per goal.
class _MissionToday extends StatelessWidget {
  const _MissionToday({required this.model, required this.mission, required this.planning});

  final WeekModel model;
  final Mission mission;
  final bool planning;

  @override
  Widget build(BuildContext context) {
    final s = mission.style;
    final planned = model.plannedFor(mission);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GroupHeader(
          title: mission.title,
          trailing: planning
              ? [
                  GhostIconButton(
                    icon: Icons.remove_rounded,
                    tooltip: 'Fewer today',
                    onTap: model.canTakeFewer(mission) ? () => model.takeFewer(mission) : null,
                  ),
                  GhostIconButton(
                    icon: Icons.add_rounded,
                    tooltip: 'More today',
                    onTap: model.canTakeMore(mission) ? () => model.takeMore(mission) : null,
                  ),
                ]
              : const [],
        ),
        if (planned.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 4),
            child: Text(
              'Nothing today. Tap + to take one.',
              style: TextStyle(color: FinchColors.onBackgroundMuted, fontSize: 13),
            ),
          ),
        for (final goal in planned)
          GoalCard(
            title: goal.title,
            icon: s.icon,
            accent: s.accent,
            muted: goal.done,
            subtitle: goal.carriedFrom != null && !goal.done ? 'From ${dayLong[goal.carriedFrom!]}' : null,
            trailing: planning
                ? (goal.done ? const Tag('Done') : null)
                : ChunkyIconButton(
                    icon: Icons.check_rounded,
                    filled: goal.done,
                    tooltip: goal.done ? 'Undo' : 'Done',
                    onTap: () => model.toggle(goal),
                  ),
          ),
      ],
    );
  }
}
