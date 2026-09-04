import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The centered "Experience" section title.
class ExperienceTitle extends StatelessComponent {
  const ExperienceTitle({super.key});

  @override
  Component build(BuildContext context) {
    return h2(
      styles: Styles(textAlign: TextAlign.center),
      [Component.text('Experience')],
    );
  }
}
