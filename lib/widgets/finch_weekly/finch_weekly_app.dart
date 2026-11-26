import 'package:flutter/material.dart';

import 'model.dart';
import 'plan_screen.dart';
import 'retro_screen.dart';
import 'today_screen.dart';
import 'ui.dart';

/// Concept demo: energy-aware weekly goals, styled after finchcare.com.
///
/// The three steps (0 plan, 1 today, 2 retro) are picked by the host page,
/// outside the phone: it passes [tab] and bumps [resetCount] to start over.
/// When the app moves on by itself (e.g. "Start the week"), it reports the
/// new step through [onTabChanged] so the page can follow.
class FinchWeeklyApp extends StatefulWidget {
  const FinchWeeklyApp({super.key, this.tab = 0, this.resetCount = 0, this.onTabChanged});

  final int tab;
  final int resetCount;
  final ValueChanged<int>? onTabChanged;

  @override
  State<FinchWeeklyApp> createState() => _FinchWeeklyAppState();
}

class _FinchWeeklyAppState extends State<FinchWeeklyApp> {
  final _model = WeekModel();
  late final _tab = ValueNotifier<int>(widget.tab);

  @override
  void didUpdateWidget(FinchWeeklyApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetCount != oldWidget.resetCount) _model.reset();
    _tab.value = widget.tab;
  }

  @override
  void dispose() {
    _tab.dispose();
    _model.dispose();
    super.dispose();
  }

  void _go(int tab) {
    _tab.value = tab;
    widget.onTabChanged?.call(tab);
  }

  @override
  Widget build(BuildContext context) {
    // The shell lives inside the navigator (dialogs need it) and only sees
    // the first `home`, so new tabs reach it through the notifier.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finch: Missions Demo',
      theme: finchTheme(),
      home: _Shell(model: _model, tab: _tab, onGo: _go),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.model, required this.tab, required this.onGo});

  final WeekModel model;
  final ValueNotifier<int> tab;
  final ValueChanged<int> onGo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([model, tab]),
          builder: (context, _) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: KeyedSubtree(
              key: ValueKey('${tab.value}-${model.week}'),
              child: switch (tab.value) {
                0 => PlanScreen(
                  model: model,
                  onStart: () {
                    if (!model.started) model.startWeek();
                    onGo(1);
                  },
                ),
                1 => TodayScreen(model: model, onGoToPlan: () => onGo(0), onGoToRetro: () => onGo(2)),
                _ => RetroScreen(model: model, onPlanNext: () => onGo(0)),
              },
            ),
          ),
        ),
      ),
    );
  }
}
