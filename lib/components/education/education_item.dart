import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';

/// Data for a single education or certification entry.
class EducationItemData {
  const EducationItemData({
    required this.date,
    required this.title,
    this.subtitle,
    this.url,
    this.logo,
    this.invertLogo = false,
  });

  final String date;
  final String title;
  final String? subtitle;
  final String? url;
  final String? logo;
  final bool invertLogo;
}

/// A single education or certification entry.
///
/// Renders the date, an optional logo and the title/subtitle. If a URL is
/// provided the whole row links out in a new tab.
class EducationItem extends StatelessComponent {
  const EducationItem({required this.data, super.key});

  final EducationItemData data;

  @override
  Component build(BuildContext context) {
    final children = [
      div(classes: 'education-date', [
        p([Component.text(data.date)]),
      ]),
      div(classes: 'education-logo', [
        if (data.logo != null)
          img(
            classes: data.invertLogo ? 'education-logo-invert' : null,
            src: data.logo!,
            alt: '${data.title} logo',
          ),
      ]),
      Column(
        classes: 'education-text',
        align: AlignItems.start,
        gap: Gap.all(0.25.rem),
        children: [
          h3([Component.text(data.title)]),
          if (data.subtitle != null) p([Component.text(data.subtitle!)]),
        ],
      ),
    ];

    if (data.url case final url?) {
      return a(
        classes: 'education-item',
        href: url,
        target: Target.blank,
        children,
      );
    }

    return div(classes: 'education-item', children);
  }

  @css
  static List<StyleRule> get styles => [
    css('.education-item').styles(
      width: 100.percent,
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.center,
      gap: Gap.all(0.875.rem),
      minHeight: 4.5.rem,
      boxSizing: BoxSizing.borderBox,
      textDecoration: TextDecoration.none,
    ),
    css('.education-item:hover').styles(
      opacity: 0.7,
    ),
    css('.education-date').styles(
      width: 9.rem,
      flex: Flex(shrink: 0),
    ),
    css('.education-date p').styles(
      raw: {'white-space': 'nowrap', 'text-align': 'right'},
    ),
    css('.education-logo').styles(
      width: 2.5.rem,
      height: 2.5.rem,
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      flex: Flex(shrink: 0),
    ),
    css('.education-logo img').styles(
      maxWidth: 100.percent,
      maxHeight: 100.percent,
      display: Display.block,
    ),
    css('.education-logo-invert').styles(
      raw: {'filter': 'invert(1)'},
    ),
    css('.education-text').styles(
      flex: Flex(grow: 1),
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.education-item').styles(
        minHeight: Unit.auto,
      ),
    ]),
  ];
}
