import 'dart:math';

import 'package:flutter/material.dart';

import 'model.dart';
import 'ui.dart';

/// Moment 3, end of the week. It always celebrates something.
///
/// Before Sunday the rest of the week is mocked: goals already done stay,
/// and the days ahead finish open goals at random. Each visit rolls again.
class RetroScreen extends StatefulWidget {
  const RetroScreen({required this.model, required this.onPlanNext, super.key});

  final WeekModel model;
  final VoidCallback onPlanNext;

  @override
  State<RetroScreen> createState() => _RetroScreenState();
}

class _RetroScreenState extends State<RetroScreen> {
  late final WeekResult _result = widget.model.mockedWeek(Random());

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final mocked = !model.weekOver;
    return FinchList(
      children: [
        ScreenTitle(
          label: 'Week ${model.week} · Sunday',
          title: 'Your week',
          subtitle: mocked
              ? (model.started
                    ? 'A peek at Sunday: the days after ${dayLong[model.day]} are made up.'
                    : 'A peek at Sunday: the whole week is made up.')
              : null,
        ),
        const SizedBox(height: 4),
        _Celebration(result: _result),
        _PerDay(result: _result),
        _MissionsDone(result: _result),
        const SizedBox(height: 4),
        FinchButton(
          label: 'Plan next week',
          onTap: () {
            model.planNextWeek(_result);
            widget.onPlanNext();
          },
        ),
      ],
    );
  }
}

class _Celebration extends StatelessWidget {
  const _Celebration({required this.result});

  final WeekResult result;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String title;
    final String text;
    if (result.allDone) {
      icon = Icons.emoji_events_rounded;
      title = 'Every mission done!';
      text = 'All ${result.total} goals across ${result.missions.length} missions. Take a bow.';
    } else if (result.bestCount > 0) {
      final best = result.bestDays.map((d) => dayLong[d]).toList();
      final names = best.length == 1 ? best.first : '${best.sublist(0, best.length - 1).join(', ')} and ${best.last}';
      icon = Icons.star_rounded;
      title = best.length == 1 ? '$names was your best day' : '$names were your best days';
      text =
          '${result.bestCount} goal${result.bestCount == 1 ? '' : 's'} on '
          '${best.length == 1 ? 'that day' : 'each'}, and ${result.done} of ${result.total} in the whole week.';
    } else {
      icon = Icons.favorite_rounded;
      title = 'You made a plan';
      text = '${result.missions.length} missions and ${result.total} goals. Planning is a step too.';
    }
    return WhiteCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: Color(0xFFFFF4D6), shape: BoxShape.circle),
            child: Icon(icon, size: 28, color: FinchColors.yellowShadow),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, height: 1.2)),
                const SizedBox(height: 2),
                Text(text, style: const TextStyle(fontSize: 12.5, color: FinchColors.textSecondary, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Goals done per day, with last week behind, and the comparison.
class _PerDay extends StatelessWidget {
  const _PerDay({required this.result});

  final WeekResult result;

  @override
  Widget build(BuildContext context) {
    final top = [...result.perDay, ...result.lastWeek, 1].reduce(max);
    final now = result.done;
    final before = result.lastWeekDone;
    final diff = now - before;
    final String versus;
    if (diff > 0) {
      versus = '+$diff goal${diff == 1 ? '' : 's'} vs last week ($before → $now)';
    } else if (diff == 0) {
      versus = 'Same as last week: $now goals. Steady counts.';
    } else {
      versus = 'A lighter week: $now vs $before. Rest is part of it.';
    }
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Goals per day', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var d = 0; d < 7; d++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          result.perDay[d] > 0 ? '${result.perDay[d]}' : '',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _bar(result.lastWeek[d] / top, FinchColors.badge),
                            const SizedBox(width: 2),
                            _bar(
                              result.perDay[d] / top,
                              result.bestDays.contains(d) ? FinchColors.yellow : FinchColors.check,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dayShort[d],
                          style: const TextStyle(fontSize: 11, color: FinchColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _legend(FinchColors.check, 'This week'),
              const SizedBox(width: 12),
              _legend(FinchColors.yellow, 'Best day'),
              const SizedBox(width: 12),
              _legend(FinchColors.badge, 'Last week'),
            ],
          ),
          const SizedBox(height: 8),
          Text(versus, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _bar(double value, Color color) => Container(
    width: 10,
    height: max(4, 50 * value),
    decoration: BoxDecoration(
      color: value == 0 ? FinchColors.badge : color,
      borderRadius: BorderRadius.circular(5),
    ),
  );

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

class _MissionsDone extends StatelessWidget {
  const _MissionsDone({required this.result});

  final WeekResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GroupHeader(title: 'Missions'),
        for (final m in result.missions)
          GoalCard(
            title: m.mission.title,
            icon: m.mission.style.icon,
            accent: m.mission.style.accent,
            subtitle: '${m.done} of ${m.total} goals',
            trailing: SizedBox(
              width: 70,
              child: ProgressBar(value: m.total == 0 ? 0 : m.done / m.total, color: m.mission.style.accent),
            ),
          ),
      ],
    );
  }
}
