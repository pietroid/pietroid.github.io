import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/finch_weekly/finch_weekly_embed.dart';
import '../components/site_header.dart';
import '../constants/site_styles.dart';

/// `/internal/finch-missions`: unlisted, mocked concept demo (noindex, not linked).
///
/// Two columns: the write-up scrolls on the left, the phone stays fixed on
/// the right. The page follows the site's style; only the phone uses the
/// demo's own look.
class FinchMissionsPage extends StatelessComponent {
  const FinchMissionsPage({required this.base});

  final String base;

  static const _surveyThread = 'https://www.reddit.com/r/finch/comments/1xa379b/';
  static const _mentalHealthThread = 'https://www.reddit.com/r/finch/comments/1x8n8p0/';
  static const _subGoalsThread = 'https://www.reddit.com/r/finch/comments/1dogjke/';
  static const _energyByMoodThread = 'https://www.reddit.com/r/finch/comments/1y4j33y/';
  static const _oneNotificationThread = 'https://www.reddit.com/r/finch/comments/1xsatfl/';

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(
        title: 'Finch: Missions Demo',
        meta: {'robots': 'noindex, nofollow'},
      ),
      div(classes: 'finch-page', [
        SiteHeader(base: base),
        main_(classes: 'finch-main', [
          div(classes: 'finch-copy', [
            div(classes: 'finch-title', [
              img(classes: 'finch-title-icon', src: '${base}images/finch_icon.png', alt: ''),
              div([
                h1([Component.text('Finch: Missions Demo')]),
                p(classes: 'finch-lead', [
                  Component.text('How I would propose a new feature at Finch. Read it in 5 minutes, then play the demo.'),
                ]),
              ]),
            ]),

            _section('Collected data', [
              p([
                Component.text(
                  'I read r/finch and ranked what users ask for most '
                  '(138 feedback posts and 935 comments, Oct to Nov 2026):',
                ),
              ]),
              ol(classes: 'finch-rank', [
                _rank('Customization and shop', '24 posts'),
                _rank('Reflection rituals', '12 posts'),
                _rank('Mental-health depth', '10 posts'),
                _rank('Goals and planning', '7 posts'),
              ]),
            ]),

            _section('Picked theme: Goals and planning', [
              p([strong([Component.text('Why, if it ranks 4th?')])]),
              ul(classes: 'finch-points', [
                li([
                  strong([Component.text('Loudest in comments. ')]),
                  Component.text('To-do and goal requests: 43 comments, more than any other ask.'),
                ]),
                li([
                  strong([Component.text('It ties into #3. ')]),
                  Component.text('The top post of the period asks for '),
                  _link(_mentalHealthThread, 'suggestions from mood check-ins'),
                  Component.text('.'),
                ]),
                li([
                  strong([Component.text('Engineering-shaped and live. ')]),
                  Component.text('#1 and #2 are art and keep-this requests; Finch is '),
                  _link(_surveyThread, 'reworking goals'),
                  Component.text(' right now.'),
                ]),
              ]),
              p([
                strong([Component.text('Two asks inside it')]),
                Component.text(', also in a '),
                _link(_surveyThread, 'goals survey by a Finch designer'),
                Component.text(':'),
              ]),
              ul(classes: 'finch-points', [
                li([
                  strong([Component.text('Sub-goals. ')]),
                  Component.text('Break a big goal into small steps ('),
                  _link(_subGoalsThread, 'thread'),
                  Component.text(').'),
                ]),
                li([
                  strong([Component.text('Mood shapes the goals. ')]),
                  Component.text('Ask less on a bad day and reward effort more ('),
                  _link(_energyByMoodThread, 'energy by mood'),
                  Component.text(', '),
                  _link(_mentalHealthThread, 'suggestions from check-ins'),
                  Component.text(').'),
                ]),
              ]),
            ]),

            _section('The idea', [
              p(classes: 'finch-callout', [
                strong([Component.text('Missions: ')]),
                Component.text(
                  'a weekly group of goals. Something you want to get done this week that takes several steps.',
                ),
              ]),
            ]),

            // From here on the page splits: text on the left, phone on the
            // right. FinchWeeklyDemo renders both the steps and the phone;
            // `display: contents` lets them land in this grid's columns.
            div(classes: 'finch-split', [
              h2(classes: 'finch-split-title', [Component.text('Try it: three moments')]),
              const FinchWeeklyDemo(),
              _section('Core premises', [
                ol(classes: 'finch-points numbered', [
                  li([
                    strong([Component.text('A new name. ')]),
                    Component.text('"Mission", not "goal": it does not clash with daily goals, and it sounds fun.'),
                  ]),
                  li([
                    strong([Component.text('Weekly. ')]),
                    Component.text('A week is easy to grasp and makes you think in concrete steps.'),
                  ]),
                  li([
                    strong([Component.text('Daily goals stay. ')]),
                    Component.text('They work as they do today. Your mood decides which steps land on which day.'),
                  ]),
                  li([
                    strong([Component.text('Mood in one tap. ')]),
                    Component.text('Three options: low, okay, good. Users push back on being asked too much ('),
                    _link(_mentalHealthThread, 'opt-in, not forced'),
                    Component.text(', '),
                    _link(_oneNotificationThread, 'one nudge a day'),
                    Component.text('), so it stays light and skippable.'),
                  ]),
                ]),
              ]),
              _section('What I would test next', [
                ol(classes: 'finch-points numbered', [
                  li([Component.text('How easy it is to add several goals to a mission.')]),
                  li([Component.text('Changing the start of the week, or how long a mission lasts.')]),
                  li([Component.text('Better mood tracking, and changing plans in the middle of the day.')]),
                ]),
              ]),
              p(classes: 'finch-note', [Component.text('Mocked data, nothing is saved.')]),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  static Component _section(String title, List<Component> children) {
    return section(classes: 'finch-section', [
      h2([Component.text(title)]),
      ...children,
    ]);
  }

  static Component _rank(String theme, String count) {
    return li([
      span(classes: 'finch-rank-theme', [Component.text(theme)]),
      span(classes: 'finch-rank-count', [Component.text(count)]),
    ]);
  }

  static Component _link(String href, String text) {
    return a(href: href, target: Target.blank, [Component.text(text)]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.finch-page').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      minHeight: 100.vh,
      color: SiteDraftColors.white,
      backgroundColor: SiteDraftColors.bioBackground,
    ),
    css('.finch-main').styles(
      width: 100.percent,
      maxWidth: 72.rem,
      padding: Padding.only(
        top: 1.rem,
        bottom: 4.rem,
        left: SiteDraftSpacings.bodyPadding,
        right: SiteDraftSpacings.bodyPadding,
      ),
      boxSizing: BoxSizing.borderBox,
    ),
    css('.finch-title').styles(
      display: Display.flex,
      margin: Margin.only(top: 1.rem),
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
    ),
    // As tall as the title and subtitle together.
    css('.finch-title-icon').styles(
      width: 4.25.rem,
      height: 4.25.rem,
      radius: BorderRadius.circular(22.percent),
      flex: Flex(shrink: 0),
    ),
    css('.finch-page h1').styles(margin: Margin.only(top: 0.px, bottom: 0.4.rem)),
    css('.finch-page p.finch-lead').styles(margin: Margin.zero),
    css('.finch-page h2').styles(
      margin: Margin.only(top: 0.px, bottom: 1.rem),
      color: SiteDraftColors.white,
      fontFamily: SiteDraftFonts.plusJakartaSansStack,
      fontSize: 1.25.rem,
      fontWeight: FontWeight.w600,
    ),
    css('.finch-page p, .finch-page li').styles(
      color: SiteDraftColors.subtitleGray,
      textAlign: TextAlign.left,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.body,
      lineHeight: 1.6.em,
      raw: {'max-width': 'none'},
    ),
    css('.finch-page p').styles(margin: Margin.only(bottom: 0.75.rem)),
    css('.finch-page strong').styles(color: SiteDraftColors.white, fontWeight: FontWeight.w500),
    css('.finch-page a').styles(color: SiteDraftColors.white, raw: {'text-underline-offset': '3px'}),
    css('.finch-page a:hover').styles(opacity: 0.7),
    css('.finch-page p.finch-lead').styles(fontSize: 1.rem),
    css('.finch-section').styles(
      padding: Padding.only(top: 2.rem),
      margin: Margin.only(top: 2.rem),
      border: Border.only(top: BorderSide(width: 1.px, color: Color('#262626'))),
    ),
    css('.finch-rank, .finch-points').styles(
      padding: Padding.zero,
      margin: Margin.only(top: 0.px, bottom: 1.rem),
      raw: {'list-style': 'none'},
    ),
    css('.finch-rank').styles(raw: {'counter-reset': 'rank'}),
    css('.finch-page .finch-rank li').styles(
      display: Display.flex,
      padding: Padding.symmetric(vertical: 0.4.rem),
      border: Border.only(bottom: BorderSide(width: 1.px, color: Color('#1f1f1f'))),
      justifyContent: JustifyContent.spaceBetween,
      gap: Gap.all(1.rem),
      raw: {'counter-increment': 'rank'},
    ),
    css('.finch-rank-theme::before').styles(
      color: SiteDraftColors.subtitleGray,
      raw: {'content': 'counter(rank) ". "'},
    ),
    css('.finch-rank-theme').styles(color: SiteDraftColors.white),
    css('.finch-page .finch-points li').styles(margin: Margin.only(bottom: 0.6.rem)),
    css('.finch-points.numbered').styles(raw: {'counter-reset': 'point'}),
    css('.finch-page .finch-points.numbered li').styles(
      position: Position.relative(),
      padding: Padding.only(left: 1.75.rem),
      raw: {'counter-increment': 'point'},
    ),
    css('.finch-points.numbered li::before').styles(
      position: Position.absolute(left: 0.px),
      color: SiteDraftColors.subtitleGray,
      raw: {'content': 'counter(point) "."'},
    ),
    css('.finch-page ul.finch-points li').styles(
      position: Position.relative(),
      padding: Padding.only(left: 1.25.rem),
    ),
    css('.finch-page ul.finch-points li::before').styles(
      position: Position.absolute(left: 0.px),
      color: SiteDraftColors.subtitleGray,
      raw: {'content': '"–"'},
    ),
    css('.finch-page p.finch-callout').styles(
      padding: Padding.symmetric(vertical: 1.rem, horizontal: 1.25.rem),
      border: Border.only(left: BorderSide(width: 2.px, color: SiteDraftColors.white)),
      color: SiteDraftColors.white,
      fontSize: 1.rem,
      backgroundColor: Color('#171717'),
    ),
    css('.finch-page p.finch-note').styles(
      margin: Margin.only(top: 3.rem),
      fontSize: SiteDraftTextStyles.caption,
    ),

    // Step picker (rendered by FinchWeeklyDemo).
    css('.finch-step-list').styles(
      padding: Padding.zero,
      margin: Margin.zero,
      raw: {'list-style': 'none'},
    ),
    css('.finch-page li.finch-step').styles(
      padding: Padding.symmetric(vertical: 1.rem),
      border: Border.only(bottom: BorderSide(width: 1.px, color: Color('#262626'))),
    ),
    css('.finch-step-title').styles(
      display: Display.flex,
      width: 100.percent,
      padding: Padding.zero,
      border: Border.none,
      alignItems: AlignItems.center,
      gap: Gap.all(0.875.rem),
      cursor: Cursor.pointer,
      color: SiteDraftColors.subtitleGray,
      textAlign: TextAlign.left,
      fontFamily: SiteDraftFonts.plusJakartaSansStack,
      fontSize: 1.125.rem,
      fontWeight: FontWeight.w500,
      backgroundColor: Colors.transparent,
    ),
    css('.finch-step-title:hover, .finch-step.active .finch-step-title').styles(color: SiteDraftColors.white),
    css('.finch-step-number').styles(
      display: Display.inlineFlex,
      width: 1.75.rem,
      height: 1.75.rem,
      border: Border.all(width: 1.px, color: Color('#3a3a3a')),
      radius: BorderRadius.circular(50.percent),
      flex: Flex(shrink: 0),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
    ),
    css('.finch-step.active .finch-step-number').styles(
      border: Border.all(width: 1.px, color: SiteDraftColors.white),
      color: SiteDraftColors.bioBackground,
      backgroundColor: SiteDraftColors.white,
    ),
    css('.finch-page p.finch-step-description').styles(
      margin: Margin.only(top: 0.75.rem, left: 2.625.rem, bottom: 0.px),
    ),
    css('.finch-step-next, .finch-reset').styles(
      padding: Padding.zero,
      border: Border.none,
      cursor: Cursor.pointer,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
      backgroundColor: Colors.transparent,
    ),
    css('.finch-step-next').styles(
      margin: Margin.only(top: 0.75.rem, left: 2.625.rem),
      color: SiteDraftColors.white,
    ),
    css('.finch-reset').styles(
      display: Display.inlineFlex,
      margin: Margin.only(top: 1.25.rem),
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
      color: SiteDraftColors.subtitleGray,
    ),
    css('.finch-reset-icon').styles(fontSize: 1.125.rem, lineHeight: 1.em),
    css('.finch-step-next:hover, .finch-reset:hover').styles(opacity: 0.7),

    // Split area: left column for text, right column for the phone.
    css('.finch-split').styles(
      display: Display.grid,
      padding: Padding.only(top: 2.rem),
      margin: Margin.only(top: 2.rem),
      border: Border.only(top: BorderSide(width: 1.px, color: Color('#262626'))),
      alignItems: AlignItems.start,
      raw: {
        'grid-template-columns': 'minmax(0, 1fr) ${(finchDemoWidth + 20).toInt()}px',
        // Title, steps, premises, next tests, note. The last row takes any extra
        // height so the phone does not stretch the gaps between them.
        'grid-template-rows': 'auto auto auto auto 1fr',
        'column-gap': '4rem',
      },
    ),
    css('.finch-split > *, .finch-steps').styles(raw: {'grid-column': '1'}),
    css('.finch-demo').styles(display: Display.contents),

    // The phone keeps the demo's own look and stays in view while the left
    // column scrolls.
    css('.finch-phone').styles(
      position: Position.sticky(top: 1.5.rem),
      width: (finchDemoWidth + 20).px,
      height: Unit.expression('min(${(finchDemoHeight + 56).toInt()}px, calc(100vh - 3rem))'),
      raw: {'grid-column': '2', 'grid-row': '1 / span 5'},
      padding: Padding.symmetric(vertical: 10.px),
      overflow: Overflow.hidden,
      border: Border.all(width: 10.px, color: Color('#2a2a2a')),
      radius: BorderRadius.circular(44.px),
      boxSizing: BoxSizing.borderBox,
      backgroundColor: Color('#7db65f'),
    ),

    // Narrow screens: one column, the phone sits below the step list.
    css.media(MediaQuery.all(maxWidth: 1000.px), [
      css('.finch-split').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)', 'grid-template-rows': 'none'}),
      css('.finch-phone').styles(
        position: Position.static,
        height: (finchDemoHeight + 56).px,
        margin: Margin.only(top: 1.5.rem, left: Unit.auto, right: Unit.auto),
        raw: {'grid-column': '1', 'grid-row': 'auto'},
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.finch-main').styles(
        padding: Padding.only(
          top: 1.rem,
          bottom: 3.rem,
          left: SiteDraftSpacings.bodyPaddingMobile,
          right: SiteDraftSpacings.bodyPaddingMobile,
        ),
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 460.px), [
      css('.finch-phone').styles(
        width: Unit.expression('calc(100% + 2rem)'),
        height: finchDemoHeight.px,
        margin: Margin.only(top: 1.5.rem, left: (-1).rem, right: (-1).rem),
        padding: Padding.zero,
        border: Border.none,
        radius: BorderRadius.circular(0.px),
      ),
    ]),
  ];
}
