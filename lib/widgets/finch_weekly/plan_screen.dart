import 'package:flutter/material.dart';

import 'model.dart';
import 'ui.dart';

/// Scenario 1, beginning of the week: goals and the user's own steps.
class PlanScreen extends StatelessWidget {
  const PlanScreen({required this.model, required this.onStart, super.key});

  final WeekModel model;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final total = model.totalPoints;
    final perDay = (total / 7).toStringAsFixed(1);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        SkyHeader(
          label: 'Week ${model.week} · Monday',
          title: 'Plan your week',
          subtitle: 'Pick a few goals and break them into small steps you can do on any day.',
        ),
        const SizedBox(height: 12),
        const SectionLabel('Goals for the week'),
        for (final goal in model.goals) ...[
          GoalPlanCard(key: ValueKey(goal.id), model: model, goal: goal),
          const SizedBox(height: 12),
        ],
        FinchButton(
          label: 'Add a goal',
          icon: Icons.add_rounded,
          primary: false,
          onTap: () => _addGoal(context),
        ),
        const SizedBox(height: 16),
        FinchCard(
          color: FinchColors.yellowTint,
          borderColor: FinchColors.yellowBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$total points this week · about $perDay a day',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Quick = 1, Medium = 2, Big = 3 points. Tap a size to change it. '
                'Each day a short check-in decides how much of this lands on that day.',
                style: TextStyle(fontSize: 13, color: FinchColors.textSecondary, height: 1.35),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FinchButton(
          label: model.started ? 'Back to today' : 'Start my week',
          icon: Icons.wb_sunny_rounded,
          onTap: total == 0 ? null : onStart,
        ),
      ],
    );
  }

  Future<void> _addGoal(BuildContext context) async {
    final controller = TextEditingController();
    var palette = goalPalettes[3];
    final result = await showDialog<(String, GoalPalette)>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: FinchColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinchRadius.card)),
          title: const Text('New goal', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: _inputDecoration('e.g. Sleep before midnight'),
                onSubmitted: (v) => Navigator.pop(context, (v, palette)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (final p in goalPalettes)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => palette = p),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: p == palette ? p.accent : Colors.transparent, width: 2),
                          ),
                          child: GoalIcon(icon: p.icon, accent: p.accent, tint: p.tint),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: FinchColors.yellow,
                foregroundColor: FinchColors.text,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinchRadius.button)),
              ),
              onPressed: () => Navigator.pop(context, (controller.text, palette)),
              child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
    if (result != null && result.$1.trim().isNotEmpty) {
      model.addGoal(result.$1.trim(), result.$2);
    }
  }
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
  hintText: hint,
  isDense: true,
  filled: true,
  fillColor: FinchColors.surfaceHigh,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(FinchRadius.button),
    borderSide: const BorderSide(color: FinchColors.border),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(FinchRadius.button),
    borderSide: const BorderSide(color: FinchColors.border),
  ),
);

class GoalPlanCard extends StatefulWidget {
  const GoalPlanCard({required this.model, required this.goal, super.key});

  final WeekModel model;
  final Goal goal;

  @override
  State<GoalPlanCard> createState() => _GoalPlanCardState();
}

class _GoalPlanCardState extends State<GoalPlanCard> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  StepSize _size = StepSize.medium;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.model.addStep(widget.goal, text, _size);
    _controller.clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final p = goal.palette;
    return FinchCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GoalIcon(icon: p.icon, accent: p.accent, tint: p.tint),
              const SizedBox(width: 10),
              Expanded(
                child: Text(goal.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              ),
              Text(
                '${goal.totalPoints} pts',
                style: const TextStyle(fontSize: 13, color: FinchColors.textSecondary),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Remove goal',
                icon: const Icon(Icons.close_rounded, size: 18, color: FinchColors.textSecondary),
                onPressed: () => widget.model.removeGoal(goal),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final step in goal.steps)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(
                    step.done ? Icons.check_circle_rounded : Icons.circle_outlined,
                    size: 18,
                    color: step.done ? p.accent : FinchColors.borderShadow,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(step.title, style: const TextStyle(fontSize: 14))),
                  SizeChip(size: step.size, onTap: () => widget.model.cycleSize(step)),
                  GestureDetector(
                    onTap: () => widget.model.removeStep(goal, step),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.remove_circle_outline_rounded, size: 18, color: FinchColors.borderShadow),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  style: const TextStyle(fontSize: 14),
                  decoration: _inputDecoration('Add a step…'),
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: 6),
              SizeChip(size: _size, onTap: () => setState(() => _size = _size.next)),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Add step',
                icon: Icon(Icons.add_circle_rounded, color: p.accent),
                onPressed: _add,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SizeChip extends StatelessWidget {
  const SizeChip({required this.size, required this.onTap, super.key});

  final StepSize size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = switch (size) {
      StepSize.quick => (FinchColors.greenTint, FinchColors.green),
      StepSize.medium => (FinchColors.blueTint, const Color(0xFF3D8FC4)),
      StepSize.big => (FinchColors.pinkTint, const Color(0xFFC0487E)),
    };
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Pill(text: size.label, color: colors.$2, tint: colors.$1, onTap: onTap),
    );
  }
}
