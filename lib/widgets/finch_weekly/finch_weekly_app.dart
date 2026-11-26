import 'package:flutter/material.dart';

import 'model.dart';
import 'plan_screen.dart';
import 'retro_screen.dart';
import 'today_screen.dart';
import 'ui.dart';

/// Concept demo: energy-aware weekly goals, styled after finchcare.com.
///
/// Three scenarios, switchable from the demo bar at the top:
/// 1. Plan: goals and user-made steps at the start of the week.
/// 2. Today: daily check-in, suggested steps, drag to adjust, carry-over.
/// 3. Retro: end-of-week celebration and comparison with last week.
class FinchWeeklyApp extends StatelessWidget {
  const FinchWeeklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weekly goals demo',
      theme: finchTheme(),
      home: const _Shell(),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  final _model = WeekModel();
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _model.addListener(_changed);
  }

  @override
  void dispose() {
    _model.removeListener(_changed);
    _model.dispose();
    super.dispose();
  }

  void _changed() => setState(() {});

  void _go(int tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _DemoBar(
              tab: _tab,
              onTab: _go,
              onReset: () {
                _model.reset();
                _go(0);
              },
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: KeyedSubtree(
                  key: ValueKey('$_tab-${_model.week}'),
                  child: switch (_tab) {
                    0 => PlanScreen(
                      model: _model,
                      onStart: () {
                        if (!_model.started) _model.startWeek();
                        _go(1);
                      },
                    ),
                    1 => TodayScreen(model: _model, onGoToPlan: () => _go(0), onGoToRetro: () => _go(2)),
                    _ => RetroScreen(model: _model, onPlanNext: () => _go(0)),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoBar extends StatelessWidget {
  const _DemoBar({required this.tab, required this.onTab, required this.onReset});

  final int tab;
  final ValueChanged<int> onTab;
  final VoidCallback onReset;

  static const _tabs = [
    (Icons.edit_calendar_rounded, 'Plan'),
    (Icons.wb_sunny_rounded, 'Today'),
    (Icons.celebration_rounded, 'Retro'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: const BoxDecoration(
        color: FinchColors.surface,
        border: Border(bottom: BorderSide(color: FinchColors.border, width: 2)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onTab(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: i == tab ? FinchColors.yellow : FinchColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(FinchRadius.button),
                      border: Border.all(color: i == tab ? FinchColors.yellowShadow : FinchColors.border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(_tabs[i].$1, size: 16, color: FinchColors.text),
                        const SizedBox(width: 6),
                        Text(
                          '${i + 1}. ${_tabs[i].$2}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          IconButton(
            tooltip: 'Reset demo',
            icon: const Icon(Icons.restart_alt_rounded, color: FinchColors.textSecondary),
            onPressed: onReset,
          ),
        ],
      ),
    );
  }
}
