import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';
import '../../constants/site_styles.dart';

/// The home page bio section.
///
/// A near-black card with a circular avatar centered above the name,
/// subtitle and social icon links.
class Bio extends StatelessComponent {
  const Bio({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'bio', [
      Column(
        align: AlignItems.center,
        gap: Gap.all(SiteDraftSpacings.cardGap),
        children: [
          div(classes: 'bio-avatar', [
            img(src: 'images/bio_avatar.png', alt: 'Photo of Pietro Teruya'),
          ]),
          h1([Component.text('Pietro Teruya')]),
          p([
            Component.text(
              'Senior Software Engineer, building Mobile Experiences for the past 7 years.',
            ),
          ]),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.bio').styles(
      width: 100.percent,
      maxWidth: 44.5625.rem,
      padding: Padding.only(top: 3.rem, bottom: 6.rem),
      boxSizing: BoxSizing.borderBox,
    ),
    css('.bio-avatar').styles(
      width: SiteDraftElementSizes.avatar,
      height: SiteDraftElementSizes.avatar,
      radius: BorderRadius.circular(50.percent),
      overflow: Overflow.hidden,
      flex: Flex(shrink: 0),
    ),
    css('.bio-avatar img').styles(
      display: Display.block,
      width: 100.percent,
      height: 100.percent,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.bio').styles(
        padding: Padding.all(SiteDraftSpacings.bodyPadding),
      ),
    ]),
  ];
}
