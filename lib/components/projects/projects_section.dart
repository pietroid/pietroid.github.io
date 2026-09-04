import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../data/projects_loader.dart';
import '../column.dart';
import 'project_item.dart';
import 'projects_list.dart';
import 'projects_title.dart';

/// The aggregate projects section.
///
/// Composes only inner components and has no styles of its own.
/// Project entries are read from `content/_data/projects.yaml` at build time.
class ProjectsSection extends StatelessComponent {
  ProjectsSection({super.key});

  final List<ProjectItemData> _items = loadProjects();

  @override
  Component build(BuildContext context) {
    return Column(
      align: AlignItems.center,
      gap: Gap.all(2.rem),
      padding: Padding.only(top: 3.rem, bottom: 6.rem),
      children: [
        const ProjectsTitle(),
        ProjectsList(items: _items),
      ],
    );
  }
}
