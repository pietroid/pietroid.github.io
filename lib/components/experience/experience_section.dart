import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';
import '../column.dart';
import 'experience_item.dart';
import 'experience_list.dart';
import 'experience_title.dart';

/// The aggregate experience section.
///
/// Composes only inner components and adds responsive horizontal padding so the
/// timeline never touches the viewport edges on mobile.
class ExperienceSection extends StatelessComponent {
  const ExperienceSection({super.key});

  static const _items = [
    ExperienceItemData(
      date: '2026 - now',
      logo: 'images/lunna.png',
      name: 'Founder - Lunna',
      description: 'Agentic organization for women entrepreneurs. In beta.',
      url: 'https://lunna.pietroteruya.dev',
    ),
    ExperienceItemData(
      date: '2025 - now',
      logo: 'images/vgv.png',
      name: 'Senior Mobile Engineer - Very Good Ventures',
      description: 'Global consultancy expert in Flutter',
      url: 'https://verygood.ventures',
    ),
    ExperienceItemData(
      date: '2025 - 2026',
      name: 'Tech Lead (contract) - Stealth startup',
      description: 'Consumer app with 100K MAU, 8 months',
      url: 'https://pietroid.github.io/projects/delivery_time_optimization',
    ),
    ExperienceItemData(
      date: '2021 - 2024',
      logo: 'images/quintoandar.svg',
      name: 'Mobile Engineer - QuintoAndar',
      description: 'The largest proptech in Brazil',
      url: 'https://grupoquintoandar.com/',
    ),
    ExperienceItemData(
      date: '2020 - 2021',
      logo: 'images/rd.svg',
      name: 'Fullstack Engineer - RaiaDrogasil (RD Saúde)',
      description: 'The largest pharmacy retailer in Brazil',
      url: 'https://rdsaude.com.br/',
    ),
    ExperienceItemData(
      date: '2019 - 2020',
      logo: 'images/indigo.png',
      name: 'Tech Founder - Indigo Labs',
      description: 'Health tech startup I co-founded',
      url: 'https://pietroid.github.io/projects/psiquiatria_paulista_app',
    ),
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'experience-section', [
      Column(
        align: AlignItems.center,
        gap: Gap.all(1.rem),
        children: [
          const ExperienceTitle(),
          ExperienceList(items: _items),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience-section').styles(
      width: 100.percent,
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      padding: Padding.symmetric(horizontal: SiteDraftSpacings.bodyPadding),
      boxSizing: BoxSizing.borderBox,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.experience-section').styles(
        padding: Padding.symmetric(
          horizontal: SiteDraftSpacings.bodyPaddingMobile,
        ),
      ),
    ]),
  ];
}
