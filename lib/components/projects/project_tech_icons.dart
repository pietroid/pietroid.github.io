import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'project_sizes.dart';

/// A row of technology icons overlaid on a project image.
class ProjectTechIcons extends StatelessComponent {
  const ProjectTechIcons({required this.icons, super.key});

  final List<String> icons;

  @override
  Component build(BuildContext context) {
    return div(classes: 'projects-tech', [
      for (final icon in icons) img(src: icon, alt: ''),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-tech').styles(
      display: Display.flex,
      flexDirection: FlexDirection.row,
      gap: Gap.all(0.5.rem),
      position: Position.absolute(
        right: 0.75.rem,
        bottom: 0.75.rem,
      ),
    ),
    css('.projects-tech img').styles(
      width: ProjectSizes.techIcon,
      height: ProjectSizes.techIcon,
      display: Display.block,
    ),
  ];
}
