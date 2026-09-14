import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';
import '../column.dart';
import 'education_item.dart';

/// The aggregate Certifications & Education section.
///
/// Shows diplomas and certifications below the Experience section.
class EducationSection extends StatelessComponent {
  const EducationSection({super.key});

  static const _items = [
    EducationItemData(
      date: '2026',
      title: 'Claude Certified Architect – Foundations',
      subtitle: 'Anthropic',
      url: 'https://www.credly.com/badges/6973c0f4-6b30-4d2d-acd2-3153efaeef99',
      logo: 'images/claude.svg',
    ),
    EducationItemData(
      date: '2014 - 2019',
      title: 'Mechatronics Engineering Bachelor Degree',
      subtitle: 'University of São Paulo',
      url: 'https://www5.usp.br/english/institutional/',
      logo: 'images/usp.svg',
      invertLogo: true,
    ),
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'education-section', [
      Column(
        align: AlignItems.center,
        gap: Gap.all(1.rem),
        children: [
          h2(
            styles: Styles(textAlign: TextAlign.center),
            [Component.text('Certifications & Education')],
          ),
          Column(
            classes: 'education-list',
            align: AlignItems.start,
            gap: Gap.all(Unit.zero),
            children: [
              for (final item in _items) EducationItem(data: item),
            ],
          ),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.education-section').styles(
      width: 100.percent,
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      padding: Padding.symmetric(
        vertical: 3.rem,
        horizontal: SiteDraftSpacings.bodyPadding,
      ),
      boxSizing: BoxSizing.borderBox,
    ),
    css('.education-list').styles(
      width: 100.percent,
      maxWidth: 44.5625.rem,
      boxSizing: BoxSizing.borderBox,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.education-section').styles(
        padding: Padding.symmetric(
          vertical: 3.rem,
          horizontal: SiteDraftSpacings.bodyPaddingMobile,
        ),
      ),
    ]),
  ];
}
