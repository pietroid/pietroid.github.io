import 'package:flutter/material.dart';

import 'model.dart';
import 'ui.dart';

/// Moment 1, start of the week: missions and the goals inside them.
class PlanScreen extends StatelessWidget {
  const PlanScreen({required this.model, required this.onStart, super.key});

  final WeekModel model;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final total = model.totalGoals;
    return FinchList(
      children: [
        ScreenTitle(
          label: 'Week ${model.week} · Monday',
          title: 'Missions for this week',
          subtitle: 'What do you want to get done this week? Break each mission into goals.',
        ),
        for (final mission in model.missions) MissionPlan(key: ValueKey(mission.id), model: model, mission: mission),
        const SizedBox(height: 6),
        FinchButton(label: '+ Add a mission', light: true, onTap: () => _addMission(context)),
        FinchButton(
          label: model.started ? 'Back to today' : 'Start my week · $total goals',
          onTap: total == 0 ? null : onStart,
        ),
      ],
    );
  }

  Future<void> _addMission(BuildContext context) async {
    final controller = TextEditingController();
    var style = missionStyles[2];
    final result = await showDialog<(String, MissionStyle)>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: FinchColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: const Text('New mission', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: FinchColors.badge, borderRadius: BorderRadius.circular(18)),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: pillInput('e.g. Finish my book'),
                  onSubmitted: (v) => Navigator.pop(context, (v, style)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (final s in missionStyles)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => style = s),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: s == style ? s.accent : Colors.transparent, width: 2),
                          ),
                          child: IconBadge(icon: s.icon, accent: s.accent, size: 38),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: FinchColors.textSecondary)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: FinchColors.yellow,
                foregroundColor: FinchColors.text,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinchRadius.button)),
              ),
              onPressed: () => Navigator.pop(context, (controller.text, style)),
              child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
    if (result != null && result.$1.trim().isNotEmpty) {
      model.addMission(result.$1.trim(), result.$2);
    }
  }
}

/// One mission: its header and goals, plus a pill to add another goal.
class MissionPlan extends StatefulWidget {
  const MissionPlan({required this.model, required this.mission, super.key});

  final WeekModel model;
  final Mission mission;

  @override
  State<MissionPlan> createState() => _MissionPlanState();
}

class _MissionPlanState extends State<MissionPlan> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _focus.requestFocus();
      return;
    }
    widget.model.addGoal(widget.mission, text);
    _controller.clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    final s = mission.style;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GroupHeader(
          title: mission.title,
          trailing: [
            GhostIconButton(icon: Icons.add_rounded, tooltip: 'Add a goal', onTap: _add),
            GhostIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Remove mission',
              onTap: () => widget.model.removeMission(mission),
            ),
          ],
        ),
        for (final goal in mission.goals)
          GoalCard(
            title: goal.title,
            icon: s.icon,
            accent: s.accent,
            muted: goal.done,
            trailing: ChunkyIconButton(
              icon: Icons.remove_rounded,
              color: FinchColors.textSecondary,
              tooltip: 'Remove goal',
              onTap: () => widget.model.removeGoal(mission, goal),
            ),
          ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
          decoration: BoxDecoration(
            color: FinchColors.ghost,
            borderRadius: BorderRadius.circular(FinchRadius.card),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  style: const TextStyle(fontSize: 14, color: FinchColors.onBackground, fontWeight: FontWeight.w500),
                  cursorColor: FinchColors.onBackground,
                  decoration: pillInput('Add a goal…').copyWith(
                    hintStyle: const TextStyle(color: FinchColors.onBackgroundMuted, fontWeight: FontWeight.w500),
                  ),
                  onSubmitted: (_) => _add(),
                ),
              ),
              GhostIconButton(icon: Icons.add_rounded, tooltip: 'Add goal', onTap: _add),
            ],
          ),
        ),
      ],
    );
  }
}
