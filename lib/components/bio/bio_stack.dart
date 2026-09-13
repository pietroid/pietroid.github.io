import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';

/// The technology stack row shown below the bio description.
///
/// Renders each technology as an icon + label pair, separated by a small dot.
class BioStack extends StatelessComponent {
  const BioStack({super.key});

  static const _items = [
    ('Flutter', 'images/flutter.svg'),
    ('Swift', 'images/swift.svg'),
    ('Kotlin', 'images/kotlin.svg'),
    ('TypeScript', 'images/typescript.svg'),
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'bio-stack', [
      for (var i = 0; i < _items.length; i++) ...[
        div(classes: 'bio-stack-item', [
          img(src: _items[i].$2, alt: _items[i].$1),
          span([Component.text(_items[i].$1)]),
        ]),
        if (i < _items.length - 1)
          span(classes: 'bio-stack-separator', [Component.text('•')]),
      ],
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.bio-stack').styles(
      display: Display.flex,
      flexDirection: FlexDirection.row,
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
      margin: Margin.only(top: 0.75.rem),
    ),
    css('.bio-stack-item').styles(
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.center,
      gap: Gap.all(0.375.rem),
    ),
    css('.bio-stack-item img').styles(
      width: 1.rem,
      height: 1.rem,
      display: Display.block,
    ),
    css('.bio-stack-item span').styles(
      color: SiteDraftColors.subtitleGray,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
      fontWeight: FontWeight.w400,
    ),
    css('.bio-stack-separator').styles(
      color: SiteDraftColors.subtitleGray,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
      fontWeight: FontWeight.w400,
    ),
  ];
}
