import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';

/// Available status pill colors.
enum ProjectStatusColor { done, wip }

/// A status pill for a project.
class ProjectStatus extends StatelessComponent {
  const ProjectStatus({required this.status, required this.color, super.key});

  final String status;
  final ProjectStatusColor color;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'projects-status-pill projects-status-${color.name}',
      [Component.text(status)],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-status-pill').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      padding: Padding.symmetric(horizontal: 0.4.rem, vertical: 0.15.rem),
      radius: BorderRadius.circular(4.px),
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: 12.px,
      fontWeight: FontWeight.w400,
      color: SiteDraftColors.black,
      lineHeight: 1.em,
    ),
    css('.projects-status-done').styles(backgroundColor: Color('#33c900')),
    css('.projects-status-wip').styles(backgroundColor: Color('#ffd200')),
  ];
}
