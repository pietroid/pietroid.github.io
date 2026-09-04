import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';
import 'project_item.dart';
import 'project_sizes.dart';

/// The list of project cards.
class ProjectsList extends StatelessComponent {
  const ProjectsList({required this.items, super.key});

  final List<ProjectItemData> items;

  @override
  Component build(BuildContext context) {
    return Column(
      classes: 'projects-list',
      align: AlignItems.start,
      gap: Gap.all(ProjectSizes.listGap),
      children: [
        for (final item in items) ProjectItem(data: item),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-list').styles(
      width: 100.percent,
      maxWidth: 44.5625.rem,
      boxSizing: BoxSizing.borderBox,
    ),
  ];
}
