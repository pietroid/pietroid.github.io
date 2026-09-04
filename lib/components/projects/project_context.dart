import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';

/// Available context tag colors.
enum ProjectContextColor { teal, yellow }

/// A colored context tag for a project.
class ProjectContext extends StatelessComponent {
  const ProjectContext({required this.text, required this.color, super.key});

  final String text;
  final ProjectContextColor color;

  @override
  Component build(BuildContext context) {
    return span(
      classes: 'projects-context projects-context-${color.name}',
      [Component.text(text)],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-context').styles(
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: 12.px,
      fontWeight: FontWeight.w400,
      lineHeight: 1.4.em,
    ),
    css('.projects-context-teal').styles(color: Color('#1f7a99')),
    css('.projects-context-yellow').styles(color: Color('#e6ff0d')),
  ];
}
