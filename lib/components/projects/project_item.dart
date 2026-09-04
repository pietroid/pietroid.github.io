import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';
import '../row.dart';
import 'project_context.dart';
import 'project_image.dart';
import 'project_sizes.dart';
import 'project_status.dart';

/// Data for a single project entry.
class ProjectItemData {
  const ProjectItemData({
    required this.image,
    required this.title,
    required this.description,
    required this.context,
    required this.contextColor,
    required this.status,
    required this.statusColor,
    this.techIcons = const [],
  });

  final String image;
  final String title;
  final String description;
  final String context;
  final ProjectContextColor contextColor;
  final String status;
  final ProjectStatusColor statusColor;
  final List<String> techIcons;
}

/// A single project card.
///
/// Uses the global `h3` style for the title and the global `p` style for the
/// description. Only layout and color accents remain component-specific.
class ProjectItem extends StatelessComponent {
  const ProjectItem({required this.data, super.key});

  final ProjectItemData data;

  @override
  Component build(BuildContext context) {
    return Row(
      classes: 'projects-item',
      align: AlignItems.start,
      gap: Gap.all(ProjectSizes.gap),
      children: [
        ProjectImage(image: data.image, title: data.title, techIcons: data.techIcons),
        Column(
          classes: 'projects-info',
          align: AlignItems.start,
          gap: Gap.all(0.25.rem),
          children: [
            h3([Component.text(data.title)]),
            p([Component.text(data.description)]),
            Row(
              classes: 'projects-meta',
              align: AlignItems.center,
              gap: Gap.all(0.75.rem),
              children: [
                ProjectContext(
                  text: data.context,
                  color: data.contextColor,
                ),
                ProjectStatus(
                  status: data.status,
                  color: data.statusColor,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-item').styles(
      boxSizing: BoxSizing.borderBox,
    ),
    css('.projects-info').styles(
      flex: Flex(grow: 1),
      padding: Padding.only(top: 0.125.rem),
    ),
    css('.projects-info p').styles(
      textAlign: TextAlign.start,
    ),
  ];
}
