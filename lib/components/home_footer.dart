import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/site_styles.dart';

/// A small footer shown at the bottom of the home page.
///
/// Links to the site's source repository and shows a blue heart next to the
/// Jaspr mention.
class HomeFooter extends StatelessComponent {
  const HomeFooter({super.key});

  static const _repositoryUrl = 'https://github.com/pietroid/pietroid.github.io';

  @override
  Component build(BuildContext context) {
    return footer(classes: 'home-footer', [
      a(
        classes: 'home-footer-link',
        href: _repositoryUrl,
        target: Target.blank,
        [
          Component.text('Made with Jaspr '),
          span(classes: 'home-footer-heart', [Component.text('♥')]),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.home-footer').styles(
      width: 100.percent,
      display: Display.flex,
      justifyContent: JustifyContent.center,
      padding: Padding.symmetric(vertical: 2.rem),
    ),
    css('.home-footer-link').styles(
      color: SiteDraftColors.subtitleGray,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
      textDecoration: TextDecoration.none,
    ),
    css('.home-footer-link:hover').styles(
      color: SiteDraftColors.white,
    ),
    css('.home-footer-heart').styles(
      color: SiteDraftColors.jasprBlue,
    ),
  ];
}
