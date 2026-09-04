import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'project_sizes.dart';
import 'project_tech_icons.dart';

/// The project preview image with optional technology icons.
class ProjectImage extends StatelessComponent {
  const ProjectImage({
    required this.image,
    required this.title,
    this.techIcons = const [],
    super.key,
  });

  final String image;
  final String title;
  final List<String> techIcons;

  @override
  Component build(BuildContext context) {
    return div(classes: 'projects-image', [
      img(src: image, alt: '$title preview'),
      if (techIcons.isNotEmpty) ProjectTechIcons(icons: techIcons),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-image').styles(
      position: Position.relative(),
      width: ProjectSizes.imageWidth,
      height: ProjectSizes.imageHeight,
      radius: BorderRadius.circular(8.px),
      overflow: Overflow.hidden,
      flex: Flex(shrink: 0),
    ),
    css('.projects-image img').styles(
      width: 100.percent,
      height: 100.percent,
      display: Display.block,
      raw: {'object-fit': 'cover'},
    ),
  ];
}
