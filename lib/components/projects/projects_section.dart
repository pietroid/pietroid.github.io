import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';
import '../../data/projects_loader.dart';
import '../column.dart';
import 'project_item.dart';
import 'projects_list.dart';
import 'projects_title.dart';

/// The aggregate projects section.
///
/// Composes only inner components and adds responsive horizontal padding so the
/// project cards never touch the viewport edges on mobile.
class ProjectsSection extends StatelessComponent {
  ProjectsSection({super.key});

  final List<ProjectItemData> _items = loadProjects();

  @override
  Component build(BuildContext context) {
    return div(classes: 'projects-section', [
      Column(
        align: AlignItems.center,
        gap: Gap.all(2.rem),
        padding: Padding.only(top: 3.rem, bottom: 6.rem),
        children: [
          const ProjectsTitle(),
          ProjectsList(items: _items),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-section').styles(
      width: 100.percent,
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      padding: Padding.symmetric(horizontal: SiteDraftSpacings.bodyPadding),
      boxSizing: BoxSizing.borderBox,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.projects-section').styles(
        padding: Padding.symmetric(
          horizontal: SiteDraftSpacings.bodyPaddingMobile,
        ),
      ),
    ]),
  ];
}
