import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

@Import.onWeb('../../widgets/finch_weekly/finch_weekly_app.dart', show: [#FinchWeeklyApp])
import 'finch_weekly_embed.imports.dart' deferred as demo;

/// Phone size of the embedded demo. The page may shrink the height to fit
/// the window, down to [finchDemoMinHeight].
const finchDemoWidth = 390.0;
const finchDemoHeight = 800.0;
const finchDemoMinHeight = 560.0;

/// The three moments of the week, picked from outside the phone.
const _steps = [
  (
    title: 'Start of the week',
    description:
        'Set this week\'s missions and break each one into small goals. '
        'Add or remove goals and missions, then start the week.',
  ),
  (
    title: 'Daily',
    description:
        'One tap tells the app your mood: low, okay or good. It picks today\'s goals from what is left '
        'and the days remaining, and − / + take fewer or more. Unfinished goals move to tomorrow.',
  ),
  (
    title: 'End of the week',
    description:
        'A peek at Sunday that always finds something to celebrate: a finished week, or your best day, '
        'next to last week. Days still ahead are made up from your progress, so each visit differs.',
  ),
];

/// The step picker plus the embedded Flutter demo (`FinchWeeklyApp`).
///
/// The page owns the current step: picking one here switches the phone, and
/// when the app moves on by itself it reports back so the list follows.
@client
class FinchWeeklyDemo extends StatefulComponent {
  const FinchWeeklyDemo({super.key});

  @override
  State<FinchWeeklyDemo> createState() => _FinchWeeklyDemoState();
}

class _FinchWeeklyDemoState extends State<FinchWeeklyDemo> {
  int _step = 0;
  int _resetCount = 0;

  void _go(int step) {
    if (step != _step) setState(() => _step = step);
  }

  void _reset() => setState(() {
    _step = 0;
    _resetCount++;
  });

  @override
  Component build(BuildContext context) {
    final step = _step;
    final resetCount = _resetCount;
    return div(classes: 'finch-demo', [
      div(classes: 'finch-steps', [
        ol(classes: 'finch-step-list', [
          for (var i = 0; i < _steps.length; i++)
            li(classes: i == step ? 'finch-step active' : 'finch-step', [
              button(
                classes: 'finch-step-title',
                onClick: () => _go(i),
                [
                  span(classes: 'finch-step-number', [Component.text('${i + 1}')]),
                  Component.text(_steps[i].title),
                ],
              ),
              if (i == step) ...[
                p(classes: 'finch-step-description', [Component.text(_steps[i].description)]),
                if (i + 1 < _steps.length)
                  button(
                    classes: 'finch-step-next',
                    onClick: () => _go(i + 1),
                    [Component.text('Next: ${_steps[i + 1].title} →')],
                  ),
              ],
            ]),
        ]),
        button(classes: 'finch-reset', onClick: _reset, [
          span(classes: 'finch-reset-icon', attributes: {'aria-hidden': 'true'}, [Component.text('↺')]),
          Component.text('Start over'),
        ]),
      ]),
      div(classes: 'finch-phone', [
        FlutterEmbedView.deferred(
          styles: Styles(height: 100.percent),
          constraints: ViewConstraints(
            minWidth: finchDemoWidth,
            minHeight: finchDemoMinHeight,
            maxWidth: finchDemoWidth,
            maxHeight: finchDemoHeight,
          ),
          loadLibrary: demo.loadLibrary(),
          builder: () => demo.FinchWeeklyApp(tab: step, resetCount: resetCount, onTabChanged: _go),
        ),
      ]),
    ]);
  }
}
