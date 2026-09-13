import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';
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
    required this.date,
    this.stack,
    this.users,
    required this.url,
    this.techIcons = const [],
  });

  final String image;
  final String title;
  final String description;
  final String context;
  final ProjectContextColor contextColor;
  final String status;
  final ProjectStatusColor statusColor;
  final String date;
  final String? stack;
  final String? users;
  final String url;
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
    return a(
      classes: 'projects-item',
      href: data.url,
      [
        ProjectImage(
          image: data.image,
          title: data.title,
          techIcons: const [],
        ),
        Column(
          classes: 'projects-info',
          align: AlignItems.start,
          gap: Gap.all(0.75.rem),
          children: [
            h3([Component.text(data.title)]),
            p([Component.text(data.description)]),
            if (data.stack != null || data.users != null)
              div(classes: 'projects-details', [
                if (data.stack != null)
                  span(classes: 'projects-detail', [
                    span(classes: 'projects-detail-label', [Component.text('Stack: ')]),
                    span(classes: 'projects-detail-value projects-detail-stack', [
                      Component.text(data.stack!),
                    ]),
                  ]),
                if (data.users != null)
                  span(classes: 'projects-detail', [
                    span(classes: 'projects-detail-label', [Component.text('Users: ')]),
                    span(classes: 'projects-detail-value projects-detail-users', [
                      Component.text(data.users!),
                    ]),
                  ]),
              ]),
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
                span(
                  classes: 'projects-date',
                  [Component.text(data.date)],
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
      width: 100.percent,
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.start,
      gap: Gap.all(ProjectSizes.gap),
      boxSizing: BoxSizing.borderBox,
      textDecoration: TextDecoration.none,
      color: SiteDraftColors.white,
    ),
    css('.projects-item:hover').styles(
      opacity: 0.7,
    ),
    css('.projects-info').styles(
      flex: Flex(grow: 1),
      padding: Padding.only(top: 0.125.rem),
    ),
    css('.projects-info p').styles(
      textAlign: TextAlign.start,
      maxWidth: 100.percent,
    ),
    css('.projects-details').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.25.rem),
      margin: Margin.only(bottom: 0.25.rem),
    ),
    css('.projects-detail').styles(
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
      fontWeight: FontWeight.w400,
      lineHeight: 1.4.em,
    ),
    css('.projects-detail-label').styles(
      color: SiteDraftColors.subtitleGray,
    ),
    css('.projects-detail-stack').styles(
      color: Color('#1f7a99'),
    ),
    css('.projects-detail-users').styles(
      color: Color('#e6ff0d'),
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.projects-item').styles(
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.start,
        gap: Gap.all(1.rem),
      ),
      css('.projects-image').styles(
        width: 100.percent,
        raw: {'height': 'auto', 'aspect-ratio': '1 / 1'},
      ),
      css('.projects-info').styles(
        width: 100.percent,
      ),
    ]),
    css('.projects-meta').styles(
      raw: {'flex-wrap': 'wrap'},
    ),
    css('.projects-date').styles(
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: 12.px,
      fontWeight: FontWeight.w400,
      color: SiteDraftColors.subtitleGray,
      lineHeight: 1.4.em,
    ),
  ];
}
