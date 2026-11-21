import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';
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
    this.highlights = const [],
  });

  final String date;

  /// Company logo. When null, a neutral placeholder is shown (e.g. a stealth
  /// company that can't be named).
  final String? logo;
  final String name;
  final String description;
  final String url;

  /// What was achieved in the role, one sentence each, business impact first.
  final List<String> highlights;
}

/// A single experience entry.
///
/// Includes the date range, the timeline dot, the company logo, the title as
/// `<h3>`, the description as `<p>` and the highlights as a list. Typography
/// comes from the global `h3`, `p` and `li` styles. The whole row links to the
/// company's site.
///
/// Each item draws its own timeline segment, from its dot down to the next
/// item's dot, so items can have different heights.
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
            p(classes: 'experience-date-inline', [Component.text(data.date)]),
            if (data.highlights.isNotEmpty)
              ul(classes: 'experience-highlights', [
                for (final highlight in data.highlights)
                  li([Component.text(highlight)]),
              ]),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience-item').styles(
      position: Position.relative(),
      minHeight: ExperienceSizes.itemHeight,
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.start,
      gap: Gap.all(ExperienceSizes.gap),
      padding: Padding.only(bottom: 1.25.rem),
      boxSizing: BoxSizing.borderBox,
      textDecoration: TextDecoration.none,
    ),
    // The timeline segment from this dot to the next item's dot.
    css('.experience-item:not(:last-child)::after').styles(
      content: '',
      position: Position.absolute(
        left: ExperienceSizes.lineLeft,
        top: ExperienceSizes.lineTop,
        bottom: ExperienceSizes.lineBottom,
      ),
      width: 1.px,
      backgroundColor: Color('rgba(255, 255, 255, 0.18)'),
    ),
    css('.experience-item:hover').styles(
      opacity: 0.7,
    ),
    css('.experience-date').styles(
      width: ExperienceSizes.dateWidth,
      flex: Flex(shrink: 0),
      margin: Margin.only(top: ExperienceSizes.dateTop),
    ),
    css('.experience-date-inline').styles(display: Display.none),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.experience-date-inline').styles(display: Display.block),
    ]),
    css('.experience-date p').styles(
      raw: {'white-space': 'nowrap'},
    ),
    css('.experience-dot').styles(
      position: Position.relative(),
      width: ExperienceSizes.marker,
      height: ExperienceSizes.marker,
      radius: BorderRadius.circular(50.percent),
      flex: Flex(shrink: 0),
      margin: Margin.only(top: ExperienceSizes.dotTop),
      backgroundColor: Color('#9c9c9c'),
    ),
    css('.experience-logo').styles(
      width: ExperienceSizes.logo,
      height: ExperienceSizes.logo,
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      flex: Flex(shrink: 0),
      margin: Margin.only(top: ExperienceSizes.logoTop),
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
      padding: Padding.only(top: ExperienceSizes.logoTop),
    ),
    css('.experience-text p').styles(
      textAlign: TextAlign.start,
      maxWidth: 100.percent,
    ),
    css('.experience-highlights').styles(
      margin: Margin.only(top: 0.5.rem, bottom: Unit.zero),
      padding: Padding.only(left: 1.rem),
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
      lineHeight: 1.6.em,
    ),
    css('.experience-highlights li').styles(
      margin: Margin.only(bottom: 0.375.rem),
    ),
    // On narrow screens the date moves under the title and the line follows
    // the dot, which becomes the first column.
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.experience-date').styles(display: Display.none),
      css('.experience-item:not(:last-child)::after').styles(
        position: Position.absolute(
          left: ExperienceSizes.lineLeftMobile,
          top: ExperienceSizes.lineTop,
          bottom: ExperienceSizes.lineBottom,
        ),
      ),
    ]),
  ];
}
