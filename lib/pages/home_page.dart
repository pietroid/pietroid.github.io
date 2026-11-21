import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/bio/bio.dart';
import '../components/blog/last_posts_section.dart';
import '../components/education/education_section.dart';
import '../components/experience/experience_section.dart';
import '../components/home_footer.dart';
import '../components/projects/projects_section.dart';
import '../components/site_header.dart';
import '../constants/site_styles.dart';

/// The standalone home page.
///
/// Renders the [Bio], [ExperienceSection] and [ProjectsSection] sections stacked vertically.
class HomePage extends StatelessComponent {
  const HomePage({required this.base});

  /// The base path the site is served from ('/' for user GitHub Pages sites).
  final String base;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(
        title: 'Pietro Teruya Domingues',
        meta: {
          'description':
              'Senior Mobile Engineer and tech lead: Flutter, native iOS/Android and backend, leading launches for apps with millions of users.',
        },
      ),
      div(classes: 'home-page', [
        SiteHeader(base: base, isHome: true),
        const Bio(),
        const ExperienceSection(),
        const EducationSection(),
        ProjectsSection(),
        LastPostsSection(),
        const HomeFooter(),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.home-page').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      minHeight: 100.vh,
      color: SiteDraftColors.white,
      backgroundColor: SiteDraftColors.bioBackground,
    ),
  ];
}
