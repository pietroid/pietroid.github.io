import 'dart:math';

import 'package:flutter/material.dart';

/// Mocked, in-memory model for the missions demo.
///
/// A mission is a weekly group of goals. Progress is the number of goals
/// done, nothing else. Nothing is persisted: reloading the page (or starting
/// over) resets it.

const dayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const dayLong = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

/// The one-tap daily check-in. It scales today's share of the week.
enum Mood {
  low('Low', Icons.sentiment_dissatisfied_rounded, 0.5),
  ok('Okay', Icons.sentiment_neutral_rounded, 1.0),
  good('Good', Icons.sentiment_very_satisfied_rounded, 1.5);

  const Mood(this.label, this.icon, this.multiplier);

  final String label;
  final IconData icon;
  final double multiplier;
}

class Goal {
  Goal(this.title) : id = _nextId++;

  static int _nextId = 0;

  final int id;
  String title;

  /// Day index (0 = Monday) the goal was completed on.
  int? doneDay;

  /// First day the goal was planned and left undone (it rolled over).
  int? carriedFrom;

  bool get done => doneDay != null;
}

class MissionStyle {
  const MissionStyle(this.icon, this.accent);

  final IconData icon;
  final Color accent;
}

const missionStyles = [
  MissionStyle(Icons.directions_walk_rounded, Color(0xFF3EA44E)),
  MissionStyle(Icons.spa_rounded, Color(0xFFD96FA0)),
  MissionStyle(Icons.menu_book_rounded, Color(0xFF3D8FC4)),
  MissionStyle(Icons.star_rounded, Color(0xFFE0A100)),
];

class Mission {
  Mission({required this.title, required this.style, List<Goal>? goals}) : goals = goals ?? [], id = _nextId++;

  static int _nextId = 0;

  final int id;
  String title;
  MissionStyle style;
  final List<Goal> goals;

  /// Undone goals, rolled-over ones first.
  List<Goal> get remaining {
    final undone = goals.where((g) => !g.done).toList();
    return [
      ...undone.where((g) => g.carriedFrom != null),
      ...undone.where((g) => g.carriedFrom == null),
    ];
  }

  int get doneCount => goals.where((g) => g.done).length;
}

/// What the end of the week shows.
class WeekResult {
  WeekResult({required this.perDay, required this.missions, required this.lastWeek});

  /// Goals done per day, Monday first.
  final List<int> perDay;
  final List<({Mission mission, int done, int total})> missions;
  final List<int> lastWeek;

  int get done => perDay.fold(0, (a, b) => a + b);
  int get total => missions.fold(0, (a, m) => a + m.total);
  int get lastWeekDone => lastWeek.fold(0, (a, b) => a + b);
  bool get allDone => total > 0 && done >= total;
  int get bestCount => perDay.reduce(max);
  List<int> get bestDays => [
    for (var i = 0; i < 7; i++)
      if (perDay[i] == bestCount && bestCount > 0) i,
  ];
  int get activeDays => perDay.where((c) => c > 0).length;
}

class WeekModel extends ChangeNotifier {
  WeekModel() {
    _seed();
  }

  static const _defaultLastWeek = [1, 0, 1, 1, 0, 1, 0];

  late List<Mission> missions;
  int week = 1;
  int day = 0;
  bool started = false;
  Mood? mood;

  /// Whether today's plan was accepted (planning done, now doing).
  bool accepted = false;
  List<int> lastWeek = List.of(_defaultLastWeek);

  /// Goals planned today per mission id, including the ones done today.
  final Map<int, int> todayCount = {};

  bool get weekOver => day >= 7;
  int get daysLeft => max(0, 7 - day);

  void _seed() {
    missions = [
      Mission(
        title: 'Move my body',
        style: missionStyles[0],
        goals: [
          Goal('Walk 20 minutes'),
          Goal('Stretch before bed'),
          Goal('Go to a yoga class'),
          Goal('Long walk in the park'),
        ],
      ),
      Mission(
        title: 'Calmer home',
        style: missionStyles[1],
        goals: [
          Goal('Clear my desk'),
          Goal('Do the laundry'),
          Goal('Sort the closet'),
        ],
      ),
    ];
  }

  void reset() {
    _seed();
    week = 1;
    day = 0;
    started = false;
    mood = null;
    accepted = false;
    todayCount.clear();
    lastWeek = List.of(_defaultLastWeek);
    notifyListeners();
  }

  // ---------------------------------------------------------------- planning

  int get totalGoals => missions.fold(0, (a, m) => a + m.goals.length);
  int get doneGoals => missions.fold(0, (a, m) => a + m.doneCount);
  int get remainingGoals => totalGoals - doneGoals;

  void addMission(String title, MissionStyle style) {
    missions.add(Mission(title: title, style: style));
    notifyListeners();
  }

  void removeMission(Mission mission) {
    missions.remove(mission);
    todayCount.remove(mission.id);
    notifyListeners();
  }

  void addGoal(Mission mission, String title) {
    mission.goals.add(Goal(title));
    notifyListeners();
  }

  void removeGoal(Mission mission, Goal goal) {
    mission.goals.remove(goal);
    notifyListeners();
  }

  void startWeek() {
    started = true;
    day = 0;
    mood = null;
    accepted = false;
    todayCount.clear();
    notifyListeners();
  }

  // ------------------------------------------------------------------- daily

  void checkIn(Mood value) {
    mood = value;
    accepted = false;
    suggest();
    notifyListeners();
  }

  void clearCheckIn() {
    mood = null;
    accepted = false;
    notifyListeners();
  }

  void accept() {
    accepted = true;
    notifyListeners();
  }

  void adjust() {
    accepted = false;
    notifyListeners();
  }

  /// Today's share of what is left: an even split over the days left,
  /// scaled by the mood. Rolled-over goals are part of what is left.
  int target(Mood value) {
    final left = remainingGoals;
    if (left == 0 || daysLeft == 0) return 0;
    return max(1, (left / daysLeft * value.multiplier).round());
  }

  /// Fills today's target one goal at a time: rolled-over goals first, then
  /// the mission with the fewest goals planned today, then the one with the
  /// most left.
  void suggest() {
    todayCount.clear();
    final goalTarget = target(mood ?? Mood.ok);
    final planned = {for (final m in missions) m.id: 0};
    for (var n = 0; n < goalTarget; n++) {
      Mission? best;
      (int, int, int)? bestScore;
      for (final m in missions) {
        final queue = m.remaining;
        final k = planned[m.id]!;
        if (k >= queue.length) continue;
        final score = (queue[k].carriedFrom != null ? 1 : 0, -k, queue.length - k);
        if (bestScore == null || _compare(score, bestScore) > 0) {
          best = m;
          bestScore = score;
        }
      }
      if (best == null) break;
      planned[best.id] = planned[best.id]! + 1;
    }
    for (final m in missions) {
      todayCount[m.id] = planned[m.id]! + doneToday(m).length;
    }
  }

  static int _compare((int, int, int) a, (int, int, int) b) {
    if (a.$1 != b.$1) return a.$1.compareTo(b.$1);
    if (a.$2 != b.$2) return a.$2.compareTo(b.$2);
    return a.$3.compareTo(b.$3);
  }

  List<Goal> doneToday(Mission mission) => mission.goals.where((g) => g.doneDay == day).toList();

  /// Goals planned today: the ones done today plus the next undone ones.
  List<Goal> plannedFor(Mission mission) {
    final done = doneToday(mission);
    final count = todayCount[mission.id] ?? 0;
    return [...done, ...mission.remaining.take(max(0, count - done.length))];
  }

  bool canTakeMore(Mission mission) =>
      plannedFor(mission).length < doneToday(mission).length + mission.remaining.length;
  bool canTakeFewer(Mission mission) => plannedFor(mission).length > doneToday(mission).length;

  void takeMore(Mission mission) {
    if (!canTakeMore(mission)) return;
    todayCount[mission.id] = plannedFor(mission).length + 1;
    notifyListeners();
  }

  void takeFewer(Mission mission) {
    if (!canTakeFewer(mission)) return;
    todayCount[mission.id] = plannedFor(mission).length - 1;
    notifyListeners();
  }

  int get plannedToday => missions.fold(0, (a, m) => a + plannedFor(m).length);
  int get leftToday => missions.fold(0, (a, m) => a + plannedFor(m).where((g) => !g.done).length);

  void toggle(Goal goal) {
    goal.doneDay = goal.done ? null : day;
    notifyListeners();
  }

  /// Closes the day. Planned goals left undone roll over to tomorrow.
  void endDay() {
    for (final m in missions) {
      for (final g in plannedFor(m)) {
        if (!g.done) g.carriedFrom ??= day;
      }
    }
    day++;
    mood = null;
    accepted = false;
    todayCount.clear();
    notifyListeners();
  }

  int get carriedCount => missions.fold(0, (a, m) => a + m.remaining.where((g) => g.carriedFrom != null).length);

  // ------------------------------------------------------------- end of week

  /// The week as it would end: what is already done stays, and the days
  /// still ahead are made up, finishing each open goal with some chance.
  WeekResult mockedWeek(Random random) {
    final perDay = List.filled(7, 0);
    final doneByMission = <int, int>{};
    for (final m in missions) {
      for (final g in m.goals) {
        if (g.doneDay != null && g.doneDay! < 7) {
          perDay[g.doneDay!]++;
          doneByMission[m.id] = (doneByMission[m.id] ?? 0) + 1;
        }
      }
    }
    final firstMockDay = !started ? 0 : day + 1;
    if (firstMockDay < 7) {
      for (final m in missions) {
        for (final _ in m.remaining) {
          if (random.nextDouble() < 0.75) {
            perDay[firstMockDay + random.nextInt(7 - firstMockDay)]++;
            doneByMission[m.id] = (doneByMission[m.id] ?? 0) + 1;
          }
        }
      }
    }
    return WeekResult(
      perDay: perDay,
      missions: [for (final m in missions) (mission: m, done: doneByMission[m.id] ?? 0, total: m.goals.length)],
      lastWeek: lastWeek,
    );
  }

  /// Starts the next week with the same missions, all goals open again.
  void planNextWeek(WeekResult result) {
    lastWeek = result.perDay;
    for (final m in missions) {
      for (final g in m.goals) {
        g.doneDay = null;
        g.carriedFrom = null;
      }
    }
    week++;
    day = 0;
    started = false;
    mood = null;
    accepted = false;
    todayCount.clear();
    notifyListeners();
  }
}
