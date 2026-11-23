import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';
import 'experience_date_range.dart';
import 'experience_sizes.dart';

/// Data for a single experience entry.
class ExperienceItemData {
  const ExperienceItemData({
    required this.date,
    required this.name,
    required this.description,
    required this.url,
    this.logo,
  });

  final String date;
  /// Company logo. When null, a neutral placeholder is shown (e.g. a stealth
  /// company that can't be named).
  final String? logo;
  final String name;
  final String description;
  final String url;
}

/// A single experience entry.
///
/// Includes the date range, the timeline dot, the company logo, the title as
/// `<h3>` and the description as `<p>`. Typography comes from the global `h3`
/// and `p` styles. The whole row links to the company's site.
class ExperienceItem extends StatelessComponent {
  const ExperienceItem({required this.data, super.key});

  final ExperienceItemData data;

  @override
  Component build(BuildContext context) {
    return a(
      classes: 'experience-item',
      href: data.url,
      target: Target.blank,
      [
        div(classes: 'experience-date', [
          ExperienceDateRange(date: data.date),
        ]),
        div(classes: 'experience-dot', []),
        div(classes: 'experience-logo', [
          if (data.logo case final logo?)
            img(src: logo, alt: '${data.name} logo')
          else
            div(classes: 'experience-logo-placeholder', []),
        ]),
        Column(
          classes: 'experience-text',
          align: AlignItems.start,
          gap: Gap.all(0.25.rem),
          children: [
            h3([Component.text(data.name)]),
            p([Component.text(data.description)]),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience-item').styles(
      height: ExperienceSizes.itemHeight,
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.center,
      gap: Gap.all(ExperienceSizes.gap),
      boxSizing: BoxSizing.borderBox,
      textDecoration: TextDecoration.none,
    ),
    css('.experience-item:hover').styles(
      opacity: 0.7,
    ),
    css('.experience-date').styles(
      width: ExperienceSizes.dateWidth,
      flex: Flex(shrink: 0),
    ),
    css('.experience-date p').styles(
      raw: {'white-space': 'nowrap'},
    ),
    css('.experience-dot').styles(
      position: Position.relative(),
      width: ExperienceSizes.marker,
      height: ExperienceSizes.marker,
      radius: BorderRadius.circular(50.percent),
      flex: Flex(shrink: 0),
      backgroundColor: Color('#9c9c9c'),
    ),
    css('.experience-logo').styles(
      width: ExperienceSizes.logo,
      height: ExperienceSizes.logo,
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      flex: Flex(shrink: 0),
    ),
    css('.experience-logo img').styles(
      maxWidth: 100.percent,
      maxHeight: 100.percent,
      display: Display.block,
    ),
    css('.experience-logo-placeholder').styles(
      width: 100.percent,
      height: 100.percent,
      radius: BorderRadius.circular(0.5.rem),
      border: Border.all(style: BorderStyle.solid, width: 1.px, color: Color('rgba(255, 255, 255, 0.18)')),
      boxSizing: BoxSizing.borderBox,
    ),
    css('.experience-text').styles(
      flex: Flex(grow: 1),
    ),
    css('.experience-text p').styles(
      textAlign: TextAlign.start,
      maxWidth: 100.percent,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.experience-item').styles(
        height: Unit.auto,
      ),
    ]),
  ];
}
