import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/row.dart';
import '../constants/site_styles.dart';

/// The shared site header.
///
/// Shows the main navigation links (About me, Projects, Blog) and social
/// icon links (GitHub, LinkedIn). It is used by the home page and intended
/// to be reused by every page once markdown-driven routing is re-enabled.
class SiteHeader extends StatelessComponent {
  const SiteHeader({super.key, required this.base});

  /// The base path the site is served from ('/' for user GitHub Pages sites).
  final String base;

  static const _githubUrl = 'https://github.com/pietroid';
  static const _linkedinUrl = 'https://www.linkedin.com/in/pietroid/';

  @override
  Component build(BuildContext context) {
    return header(classes: 'site-header', [
      div(classes: 'site-header-inner', [
        Row(
          align: AlignItems.center,
          gap: Gap.all(2.rem),
          children: [
            a(
              classes: 'site-header-link',
              href: '${base}',
              [Component.text('About me')],
            ),
            a(
              classes: 'site-header-link',
              href: '${base}projects',
              [Component.text('Projects')],
            ),
            a(
              classes: 'site-header-link',
              href: '${base}blog',
              [Component.text('Blog')],
            ),
          ],
        ),
        Row(
          align: AlignItems.center,
          gap: Gap.all(1.rem),
          children: [
            a(
              classes: 'site-header-social',
              href: _githubUrl,
              target: Target.blank,
              [img(src: 'assets/github.svg', alt: 'GitHub')],
            ),
            a(
              classes: 'site-header-social',
              href: _linkedinUrl,
              target: Target.blank,
              [img(src: 'assets/linkedin.svg', alt: 'LinkedIn')],
            ),
          ],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-header').styles(
      width: 100.percent,
      display: Display.flex,
      justifyContent: JustifyContent.center,
      padding: Padding.symmetric(
        vertical: 1.5.rem,
        horizontal: SiteDraftSpacings.bodyPadding,
      ),
      boxSizing: BoxSizing.borderBox,
    ),
    css('.site-header-inner').styles(
      width: 100.percent,
      maxWidth: 44.5625.rem,
      display: Display.flex,
      flexDirection: FlexDirection.row,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      boxSizing: BoxSizing.borderBox,
    ),
    css('.site-header-link').styles(
      color: SiteDraftColors.white,
      fontFamily: SiteDraftFonts.plusJakartaSansStack,
      fontSize: SiteDraftTextStyles.nav,
      fontWeight: FontWeight.w400,
      textDecoration: TextDecoration.none,
    ),
    css('.site-header-link:hover').styles(
      opacity: 0.7,
    ),
    css('.site-header-social').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      width: 1.5.rem,
      height: 1.5.rem,
    ),
    css('.site-header-social img').styles(
      width: 100.percent,
      height: 100.percent,
      display: Display.block,
    ),
    css('.site-header-social:hover').styles(
      opacity: 0.7,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.site-header').styles(
        padding: Padding.all(SiteDraftSpacings.bodyPadding),
      ),
      css('.site-header-inner').styles(
        flexDirection: FlexDirection.column,
        gap: Gap.all(1.rem),
      ),
    ]),
  ];
}
