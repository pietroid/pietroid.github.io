import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../column.dart';
import 'experience_item.dart';
import 'experience_list.dart';
import 'experience_title.dart';

/// The aggregate experience section.
///
/// Composes only inner components and has no styles of its own.
class ExperienceSection extends StatelessComponent {
  const ExperienceSection({super.key});

  static const _items = [
    ExperienceItemData(
      date: '2025 - now',
      logo: 'images/vgv.png',
      name: 'Very Good Ventures',
      description: 'Global Flutter expert consultancy',
    ),
    ExperienceItemData(
      date: '2022 - 2025',
      logo: 'images/quintoandar.svg',
      name: 'QuintoAndar',
      description: 'The Largest Proptech from Brazil',
    ),
    ExperienceItemData(
      date: '2020 - 2022',
      logo: 'images/rd.svg',
      name: 'RD Saúde',
      description: 'Largest Pharmacy Retail from Brazil',
    ),
    ExperienceItemData(
      date: '2019 - 2020',
      logo: 'images/indigo.png',
      name: 'Indigo Labs',
      description: 'Health Tech Startup co-founded by me',
    ),
  ];

  @override
  Component build(BuildContext context) {
    return Column(
      align: AlignItems.center,
      gap: Gap.all(1.rem),
      children: [
        const ExperienceTitle(),
        ExperienceList(items: _items),
      ],
    );
  }
}
