import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';
import 'experience_item.dart';

/// The list of experience entries.
///
/// Each item supplies its own dot, date, content and timeline segment.
class ExperienceList extends StatelessComponent {
  const ExperienceList({required this.items, super.key});

  final List<ExperienceItemData> items;

  @override
  Component build(BuildContext context) {
    return div(classes: 'experience-list', [
      Column(
        classes: 'experience-items',
        align: AlignItems.start,
        children: [
          for (final item in items) ExperienceItem(data: item),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience-list').styles(
      position: Position.relative(),
      width: 100.percent,
      maxWidth: 44.5625.rem,
      boxSizing: BoxSizing.borderBox,
    ),
  ];
}
