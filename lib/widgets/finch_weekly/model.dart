import 'dart:math';

import 'package:flutter/material.dart';

import 'ui.dart';

/// Mocked, in-memory model for the weekly goals demo.
///
/// Nothing is persisted: reloading the page (or tapping reset) starts over.

const dayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const dayLong = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

/// How big a step feels. Points are what the daily plan balances.
enum StepSize {
  quick('Quick', 1),
  medium('Medium', 2),
  big('Big', 3);

  const StepSize(this.label, this.points);

  final String label;
  final int points;

  StepSize get next => StepSize.values[(index + 1) % StepSize.values.length];
}

/// The one-tap daily check-in. It scales today's share of the week.
enum Energy {
  low('Low', 'Gentle plan for today', Icons.battery_2_bar, 0.5),
  ok('Okay', 'A steady plan for today', Icons.battery_5_bar, 1.0),
  good('Good', 'A bigger plan for today', Icons.battery_full, 1.5);

  const Energy(this.label, this.planLabel, this.icon, this.multiplier);

  final String label;
  final String planLabel;
  final IconData icon;
  final double multiplier;
}

enum Pace {
  onTrack('On track', FinchColors.green, FinchColors.greenTint),
  tight('Tight', Color(0xFFB07900), FinchColors.yellowTint),
  outOfReach('Out of reach', Color(0xFFC0487E), FinchColors.pinkTint);

  const Pace(this.label, this.color, this.tint);

  final String label;
  final Color color;
  final Color tint;
}

class GoalStep {
  GoalStep(this.title, this.size) : id = _nextId++;

  static int _nextId = 0;

  final int id;
  String title;
  StepSize size;

  /// Day index (0 = Monday) the step was completed on.
  int? doneDay;

  /// First day the step was planned and left undone (it rolled over).
  int? carriedFrom;

  bool get done => doneDay != null;
}

class GoalPalette {
  const GoalPalette(this.icon, this.accent, this.tint);

  final IconData icon;
  final Color accent;
  final Color tint;
}

const goalPalettes = [
  GoalPalette(Icons.directions_walk_rounded, FinchColors.green, FinchColors.greenTint),
  GoalPalette(Icons.menu_book_rounded, Color(0xFF3D8FC4), FinchColors.blueTint),
  GoalPalette(Icons.spa_rounded, Color(0xFFD96FA0), FinchColors.pinkTint),
  GoalPalette(Icons.star_rounded, Color(0xFFE0A100), FinchColors.yellowTint),
];

class Goal {
  Goal({required this.title, required this.palette, List<GoalStep>? steps}) : steps = steps ?? [], id = _nextId++;

  static int _nextId = 0;

  final int id;
  String title;
  GoalPalette palette;
  final List<GoalStep> steps;

  /// Undone steps, rolled-over ones first.
  List<GoalStep> get remaining {
    final undone = steps.where((s) => !s.done).toList();
    final carried = undone.where((s) => s.carriedFrom != null).toList();
    final fresh = undone.where((s) => s.carriedFrom == null).toList();
    return [...carried, ...fresh];
  }

  int get totalPoints => steps.fold(0, (a, s) => a + s.size.points);
  int get donePoints => steps.where((s) => s.done).fold(0, (a, s) => a + s.size.points);
  int get doneCount => steps.where((s) => s.done).length;
}

/// What the retrospective shows. Built from the real week or simulated.
class RetroData {
  RetroData({
    required this.stepsPerDay,
    required this.goals,
    required this.lastWeek,
    required this.checkInDays,
  });

  final List<int> stepsPerDay;
  final List<({Goal goal, int done, int total})> goals;
  final List<int> lastWeek;
  final int checkInDays;

  int get stepsDone => stepsPerDay.fold(0, (a, b) => a + b);
  int get stepsTotal => goals.fold(0, (a, g) => a + g.total);
  int get lastWeekDone => lastWeek.fold(0, (a, b) => a + b);
  bool get allDone => stepsTotal > 0 && stepsDone >= stepsTotal;
  int get bestCount => stepsPerDay.reduce(max);
  List<int> get bestDays => [
    for (var i = 0; i < 7; i++)
      if (stepsPerDay[i] == bestCount && bestCount > 0) i,
  ];
  int get activeDays => stepsPerDay.where((c) => c > 0).length;
}

class WeekModel extends ChangeNotifier {
  WeekModel() {
    _seed();
  }

  /// Points an "okay" day usually fits. Used only to judge the week's pace.
  static const typicalDayPoints = 4;

  static const _defaultLastWeek = [1, 2, 0, 1, 1, 1, 0];

  late List<Goal> goals;
  int week = 1;
  int day = 0;
  bool started = false;
  Energy? energy;
  bool accepted = false;
  final Set<int> checkInDays = {};
  List<int> lastWeek = List.of(_defaultLastWeek);

  /// Steps planned today per goal id, including the ones already done today.
  final Map<int, int> todayCount = {};

  bool get weekOver => day >= 7;
  int get daysLeft => max(0, 7 - day);

  void _seed() {
    goals = [
      Goal(
        title: 'Move my body',
        palette: goalPalettes[0],
        steps: [
          GoalStep('Walk 20 minutes', StepSize.quick),
          GoalStep('Stretch before bed', StepSize.quick),
          GoalStep('Yoga class', StepSize.medium),
          GoalStep('Long walk in the park', StepSize.big),
        ],
      ),
      Goal(
        title: 'Finish my book',
        palette: goalPalettes[1],
        steps: [
          GoalStep('Read chapter 4', StepSize.medium),
          GoalStep('Read chapter 5', StepSize.medium),
          GoalStep('Read chapter 6', StepSize.medium),
        ],
      ),
      Goal(
        title: 'Calmer home',
        palette: goalPalettes[2],
        steps: [
          GoalStep('Clear my desk', StepSize.quick),
          GoalStep('Do the laundry', StepSize.medium),
          GoalStep('Sort the closet', StepSize.big),
        ],
      ),
    ];
  }

  void reset() {
    _seed();
    week = 1;
    day = 0;
    started = false;
    energy = null;
    accepted = false;
    checkInDays.clear();
    todayCount.clear();
    lastWeek = List.of(_defaultLastWeek);
    notifyListeners();
  }

  // ---------------------------------------------------------------- planning

  void addGoal(String title, GoalPalette palette) {
    goals.add(Goal(title: title, palette: palette));
    notifyListeners();
  }

  void removeGoal(Goal goal) {
    goals.remove(goal);
    todayCount.remove(goal.id);
    notifyListeners();
  }

  void addStep(Goal goal, String title, StepSize size) {
    goal.steps.add(GoalStep(title, size));
    if (energy != null && !accepted) suggest();
    notifyListeners();
  }

  void removeStep(Goal goal, GoalStep step) {
    goal.steps.remove(step);
    notifyListeners();
  }

  void cycleSize(GoalStep step) {
    step.size = step.size.next;
    notifyListeners();
  }

  void startWeek() {
    started = true;
    day = 0;
    energy = null;
    accepted = false;
    todayCount.clear();
    notifyListeners();
  }

  // ------------------------------------------------------------------- daily

  int get totalPoints => goals.fold(0, (a, g) => a + g.totalPoints);
  int get donePoints => goals.fold(0, (a, g) => a + g.donePoints);
  int get remainingPoints => totalPoints - donePoints;

  void checkIn(Energy value) {
    energy = value;
    checkInDays.add(day);
    accepted = false;
    suggest();
    notifyListeners();
  }

  void clearCheckIn() {
    energy = null;
    accepted = false;
    notifyListeners();
  }

  /// Today's share of what's left: the even split over the days left,
  /// scaled by the check-in. Rolled-over steps are part of what's left.
  int targetPoints(Energy value) {
    final left = remainingPoints;
    if (left == 0 || daysLeft == 0) return 0;
    return max(1, (left / daysLeft * value.multiplier).round());
  }

  /// A deliberately simple suggestion: fill today's target one step at a
  /// time. Rolled-over steps go first, then the goal with the fewest steps
  /// planned today (a bit of each goal), then the one with the most left.
  void suggest() {
    todayCount.clear();
    final target = targetPoints(energy ?? Energy.ok);
    final queues = {for (final g in goals) g.id: g.remaining};
    final planned = {for (final g in goals) g.id: 0};
    var total = 0;
    while (total < target) {
      Goal? best;
      (int, int, int)? bestScore;
      for (final g in goals) {
        final queue = queues[g.id]!;
        final n = planned[g.id]!;
        if (n >= queue.length) continue;
        final next = queue[n];
        if (total > 0 && total + next.size.points > target) continue;
        final left = queue.skip(n).fold(0, (a, s) => a + s.size.points);
        final score = (next.carriedFrom != null ? 1 : 0, -n, left);
        if (bestScore == null || _compare(score, bestScore) > 0) {
          best = g;
          bestScore = score;
        }
      }
      if (best == null) break;
      total += queues[best.id]![planned[best.id]!].size.points;
      planned[best.id] = planned[best.id]! + 1;
    }
    for (final g in goals) {
      todayCount[g.id] = planned[g.id]! + doneToday(g).length;
    }
  }

  static int _compare((int, int, int) a, (int, int, int) b) {
    if (a.$1 != b.$1) return a.$1.compareTo(b.$1);
    if (a.$2 != b.$2) return a.$2.compareTo(b.$2);
    return a.$3.compareTo(b.$3);
  }

  List<GoalStep> doneToday(Goal goal) => goal.steps.where((s) => s.doneDay == day).toList();

  /// Steps planned today: the ones done today plus the next undone ones.
  List<GoalStep> plannedFor(Goal goal) {
    final done = doneToday(goal);
    final count = todayCount[goal.id] ?? 0;
    return [...done, ...goal.remaining.take(max(0, count - done.length))];
  }

  int minCount(Goal goal) => doneToday(goal).length;
  int maxCount(Goal goal) => doneToday(goal).length + goal.remaining.length;

  void setCount(Goal goal, int count) {
    todayCount[goal.id] = count.clamp(minCount(goal), maxCount(goal));
    notifyListeners();
  }

  int get plannedPointsToday => goals.fold(0, (a, g) => a + plannedFor(g).fold(0, (b, s) => b + s.size.points));

  int get openPlannedPointsToday =>
      goals.fold(0, (a, g) => a + plannedFor(g).where((s) => !s.done).fold(0, (b, s) => b + s.size.points));

  /// Points still left after today's plan, spread over the days after today.
  int get leftAfterToday => remainingPoints - openPlannedPointsToday;

  Pace get pace {
    final left = energy == null ? remainingPoints : leftAfterToday;
    final days = energy == null ? daysLeft : daysLeft - 1;
    if (left <= 0) return Pace.onTrack;
    if (days <= 0) return Pace.outOfReach;
    final perDay = left / days;
    if (perDay <= typicalDayPoints) return Pace.onTrack;
    if (perDay <= typicalDayPoints * 1.5) return Pace.tight;
    return Pace.outOfReach;
  }

  void accept() {
    accepted = true;
    notifyListeners();
  }

  void adjust() {
    accepted = false;
    notifyListeners();
  }

  void toggle(GoalStep step) {
    step.doneDay = step.done ? null : day;
    notifyListeners();
  }

  /// Closes the day. Planned steps left undone roll over to tomorrow.
  void endDay() {
    for (final g in goals) {
      for (final s in plannedFor(g)) {
        if (!s.done) s.carriedFrom ??= day;
      }
    }
    day++;
    energy = null;
    accepted = false;
    todayCount.clear();
    notifyListeners();
  }

  int get carriedCount => goals.fold(0, (a, g) => a + g.remaining.where((s) => s.carriedFrom != null).length);

  // ------------------------------------------------------------------- retro

  RetroData actualRetro() {
    final perDay = List.filled(7, 0);
    for (final g in goals) {
      for (final s in g.steps) {
        if (s.doneDay != null && s.doneDay! < 7) perDay[s.doneDay!]++;
      }
    }
    return RetroData(
      stepsPerDay: perDay,
      goals: [for (final g in goals) (goal: g, done: g.doneCount, total: g.steps.length)],
      lastWeek: lastWeek,
      checkInDays: checkInDays.length,
    );
  }

  /// A made-up week for previewing the retro before Sunday.
  RetroData simulatedRetro({required bool perfect}) {
    final all = <({Goal goal, GoalStep step})>[];
    final longest = goals.fold(0, (a, g) => max(a, g.steps.length));
    for (var i = 0; i < longest; i++) {
      for (final g in goals) {
        if (i < g.steps.length) all.add((goal: g, step: g.steps[i]));
      }
    }
    final pattern = perfect ? [2, 1, 2, 1, 2, 1, 1] : [1, 2, 3, 0, 2, 0, 1];
    final perDay = List.filled(7, 0);
    final doneByGoal = <int, int>{};
    var index = 0;
    var round = 0;
    while (index < all.length && (perfect || round == 0)) {
      for (var d = 0; d < 7 && index < all.length; d++) {
        for (var k = 0; k < pattern[d] && index < all.length; k++) {
          perDay[d]++;
          final g = all[index].goal;
          doneByGoal[g.id] = (doneByGoal[g.id] ?? 0) + 1;
          index++;
        }
      }
      round++;
    }
    return RetroData(
      stepsPerDay: perDay,
      goals: [for (final g in goals) (goal: g, done: doneByGoal[g.id] ?? 0, total: g.steps.length)],
      lastWeek: lastWeek,
      checkInDays: perfect ? 7 : 5,
    );
  }

  /// Starts the next week with the same goals, all steps open again.
  void planNextWeek() {
    lastWeek = actualRetro().stepsPerDay;
    for (final g in goals) {
      for (final s in g.steps) {
        s.doneDay = null;
        s.carriedFrom = null;
      }
    }
    week++;
    day = 0;
    started = false;
    energy = null;
    accepted = false;
    checkInDays.clear();
    todayCount.clear();
    notifyListeners();
  }
}
