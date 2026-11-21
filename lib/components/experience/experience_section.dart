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
      highlights: [
        'Took Lunna from idea to beta on my own: product vision, design system, Flutter app (iOS, Android and web) and NestJS backend.',
        'Built the AI agent at its core: it reads the day, proposes a plan and waits for a yes, with deliveries and monthly goals tied to the calendar.',
        'Runs on an agentic delivery pipeline: feature requests become planned, mocked-up and built pull requests, so a solo founder ships like a team.',
      ],
    ),
    ExperienceItemData(
      date: '2025 - now',
      logo: 'images/vgv.png',
      name: 'Senior Mobile Engineer - Very Good Ventures',
      description: 'Global consultancy expert in Flutter',
      url: 'https://verygood.ventures',
      highlights: [
        'Led a team of three engineers analysing and optimizing the launch time of a major Brazilian banking app (5M+ MAU), chosen for my depth on both native Android and Flutter. Delivered a prioritized plan the client could act on: Remote Config caching, fewer platform channels, faster JSON loading.',
        'Led engineers to launch three new products for a major US entertainment company (500K MAU), owning the backend and BFF (Scala) end to end and onboarding two engineers who shipped from day one.',
        'Kept delivery on track through client reorganizations, taking ownership from spec to production release.',
      ],
    ),
    ExperienceItemData(
      date: '2025 - 2026',
      name: 'Tech Lead (contract) - Stealth startup',
      description: 'Consumer app with 100K MAU, 8 months',
      url: 'https://pietroid.github.io/projects/delivery_time_optimization',
      highlights: [
        'Cut the release cycle from 3 months to 3 weeks with an automated mobile release pipeline (GitHub Actions) and a clear ownership role for each release.',
        'Helped the company ship more than 10 product experiments in 8 months, aligning delivery with the founders\' vision.',
        'Owned the stack across Flutter and a TypeScript backend, migrating ~20 endpoints from Python to Google Cloud Functions.',
      ],
    ),
    ExperienceItemData(
      date: '2021 - 2024',
      logo: 'images/quintoandar.svg',
      name: 'Mobile Engineer - QuintoAndar',
      description: 'The largest proptech in Brazil',
      url: 'https://grupoquintoandar.com/',
      highlights: [
        'Led a series of product experiments and improvements in the rental and sales apps (1M+ MAU), always at the integration between native and Flutter.',
        'Map Search revamp: a custom native map-pin plugin (Swift/Kotlin) on top of Flutter plus a retuned geospatial search. Experiments lifted conversion by 15%.',
        'Replaced WhatsApp support with an in-app chat on the native Twilio SDKs bridged to Flutter, saving \$1M a year in messaging costs.',
        'Built the server-driven home feed, so product teams could launch and test new content without an app release.',
      ],
    ),
    ExperienceItemData(
      date: '2020 - 2021',
      logo: 'images/rd.svg',
      name: 'Fullstack Engineer - RaiaDrogasil (RD Saúde)',
      description: 'The largest pharmacy retailer in Brazil',
      url: 'https://rdsaude.com.br/',
      highlights: [
        'Led a team of mobile engineers to launch a new loyalty product to the Brazilian market in 8 months, impacting millions of customers. It is still live today.',
        'Ran the team\'s delivery as Scrum Master: scope, estimates and unblocking with product and management, with no time for bureaucracy.',
        'Shipped coupons and offers in the company\'s health app (5M+ MAU) across React Native and Node.js BFFs.',
      ],
    ),
    ExperienceItemData(
      date: '2019 - 2020',
      logo: 'images/indigo.png',
      name: 'Tech Founder - Indigo Labs',
      description: 'Health tech startup I co-founded',
      url: 'https://pietroid.github.io/projects/psiquiatria_paulista_app',
      highlights: [
        'Launched a psychiatric treatment tracking app used by 500 patients and clinicians, built end to end (Android, Node.js, AWS).',
        'The app led to the team being acqui-hired by RaiaDrogasil, the largest pharmacy retailer in Brazil.',
      ],
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
