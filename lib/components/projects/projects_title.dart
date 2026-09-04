import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The centered "Projects" section title.
class ProjectsTitle extends StatelessComponent {
  const ProjectsTitle({super.key});

  @override
  Component build(BuildContext context) {
    return h2(
      styles: Styles(textAlign: TextAlign.center),
      [Component.text('Projects')],
    );
  }
}
