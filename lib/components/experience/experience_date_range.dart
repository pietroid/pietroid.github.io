import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The date range for an experience item.
///
/// Rendered as a plain `<p>` so the global paragraph styles apply.
class ExperienceDateRange extends StatelessComponent {
  const ExperienceDateRange({required this.date, super.key});

  final String date;

  @override
  Component build(BuildContext context) {
    return p([Component.text(date)]);
  }
}
