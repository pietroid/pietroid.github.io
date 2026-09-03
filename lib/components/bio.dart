import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/site_styles.dart';

/// The home page bio section, matching the Figma frame at node `62:28`.
///
/// A near-black full-viewport card with a circular avatar, name, subtitle
/// and social icon links arranged in a compact horizontal layout.
class Bio extends StatelessComponent {
  const Bio({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'bio', [
      div(classes: 'bio-card', [
        div(classes: 'bio-avatar', [
          img(src: 'images/bio_avatar.png', alt: 'Photo of Pietro Teruya'),
        ]),
        div(classes: 'bio-info', [
          h1(classes: 'bio-name', [Component.text('Pietro Teruya')]),
          p(classes: 'bio-subtitle', [
            Component.text(
              'Software Engineer, building Mobile Experiences for the past 7 years.',
            ),
          ]),
          div(classes: 'bio-social', [
            a(
              classes: 'bio-social-link',
              href: 'https://br.linkedin.com/in/pietroid/',
              attributes: {'aria-label': 'LinkedIn', 'target': '_blank'},
              [img(src: 'assets/linkedin.svg', alt: 'LinkedIn')],
            ),
            a(
              classes: 'bio-social-link bio-social-link-github',
              href: 'https://github.com/pietroid/',
              attributes: {'aria-label': 'GitHub', 'target': '_blank'},
              [img(src: 'assets/github.svg', alt: 'GitHub')],
            ),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.bio').styles(
      display: Display.flex,
      minHeight: 100.vh,
      backgroundColor: SiteDraftColors.bioBackground,
      color: SiteDraftColors.white,
      fontFamily: SiteDraftFonts.plusJakartaSansStack,
    ),
    css('.bio-card').styles(
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.start,
      gap: Gap.all(2.125.rem),
      width: 100.percent,
      padding: Padding.only(left: 8.875.rem, top: 8.125.rem),
    ),
    css('.bio-avatar').styles(
      width: 8.9375.rem,
      height: 8.9375.rem,
      radius: BorderRadius.circular(50.percent),
      overflow: Overflow.hidden,
      flex: Flex(shrink: 0),
    ),
    css('.bio-avatar img').styles(
      width: 100.percent,
      height: 100.percent,
      display: Display.block,
    ),
    css('.bio-info').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.start,
      gap: Gap.all(0.5.rem),
      padding: Padding.only(top: 0.25.rem),
    ),
    css('.bio-name').styles(
      margin: Spacing.zero,
      fontSize: 32.44.px,
      fontWeight: FontWeight.w600,
      lineHeight: 1.26.em,
    ),
    css('.bio-subtitle').styles(
      margin: Spacing.zero,
      maxWidth: 18.rem,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: 14.px,
      fontWeight: FontWeight.w400,
      color: SiteDraftColors.subtitleGray,
      lineHeight: 1.57.em,
      raw: {'letter-spacing': '-0.03em'},
    ),
    css('.bio-social').styles(
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.center,
      gap: Gap.all(0.875.rem),
      margin: Margin.only(top: 0.875.rem),
    ),
    css('.bio-social-link').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      width: 1.6875.rem,
      height: 1.6875.rem,
      color: SiteDraftColors.white,
      textDecoration: TextDecoration.none,
      opacity: 1,
    ),
    css('.bio-social-link:hover').styles(opacity: 0.75),
    css('.bio-social-link.bio-social-link-github').styles(
      width: 1.625.rem,
      height: 1.625.rem,
    ),
    css('.bio-social-link img').styles(
      width: 100.percent,
      height: 100.percent,
      display: Display.block,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.bio-card').styles(
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.start,
        padding: Padding.all(2.rem),
        gap: Gap.all(1.5.rem),
      ),
      css('.bio-info').styles(padding: Padding.zero),
    ]),
  ];
}
