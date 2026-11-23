import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'experience_sizes.dart';

/// The vertical timeline line.
///
/// Drawn once across the whole list, aligned to the dot in each item. It starts
/// at the center of the first item's dot and ends at the center of the last
/// item's dot.
class ExperienceTimeline extends StatelessComponent {
  const ExperienceTimeline({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'experience-timeline', []);
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience-timeline').styles(
      position: Position.absolute(
        left: ExperienceSizes.lineLeft,
        top: ExperienceSizes.lineTop,
        bottom: ExperienceSizes.lineTop,
      ),
      width: 1.px,
      backgroundColor: Color('rgba(255, 255, 255, 0.18)'),
    ),
  ];
}
