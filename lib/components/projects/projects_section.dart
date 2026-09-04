import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';
import 'project_context.dart';
import 'project_item.dart';
import 'project_status.dart';
import 'projects_list.dart';
import 'projects_title.dart';

/// The aggregate projects section.
///
/// Composes only inner components and has no styles of its own.
class ProjectsSection extends StatelessComponent {
  const ProjectsSection({super.key});

  static const _items = [
    ProjectItemData(
      image: 'images/project.png',
      title: 'Android Startup Analysis',
      description: 'Migrating Google Cloud Function Python to Typescript',
      context: 'very good ventures',
      contextColor: ProjectContextColor.teal,
      status: 'done',
      statusColor: ProjectStatusColor.done,
    ),
    ProjectItemData(
      image: 'images/project.png',
      title: 'Scribe',
      description: 'AI-Powered App to help you study what you love.',
      context: 'personal',
      contextColor: ProjectContextColor.yellow,
      status: 'wip',
      statusColor: ProjectStatusColor.wip,
    ),
    ProjectItemData(
      image: 'images/project.png',
      title: 'Python to Typescript Backend',
      description: 'Migrating Google Cloud Function Python to Typescript',
      context: 'freelancing',
      contextColor: ProjectContextColor.teal,
      status: 'done',
      statusColor: ProjectStatusColor.done,
      techIcons: ['images/typescript.png', 'images/python.png'],
    ),
  ];

  @override
  Component build(BuildContext context) {
    return Column(
      align: AlignItems.center,
      gap: Gap.all(2.rem),
      children: [
        const ProjectsTitle(),
        ProjectsList(items: _items),
      ],
    );
  }
}
