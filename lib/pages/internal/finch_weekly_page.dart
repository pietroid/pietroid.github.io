import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../../components/finch_weekly/finch_weekly_embed.dart';

/// `/internal/finch-weekly`: interactive, mocked concept demo.
class FinchWeeklyPage extends StatelessComponent {
  const FinchWeeklyPage({required this.base});

  final String base;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(
        title: 'Weekly goals demo | pietroid',
        meta: {'robots': 'noindex, nofollow'},
      ),
      div(classes: 'internal-page', [
        main_(classes: 'internal-main internal-demo', [
          div(classes: 'internal-copy', [
            a(classes: 'internal-back', href: '${base}internal', [Component.text('← Internal')]),
            h1([Component.text('Weekly goals, sized by your energy')]),
            p(classes: 'internal-lead', [
              Component.text(
                'A concept for a self-care pet app: set goals for the week, break them into small steps, '
                'and let a one-tap daily check-in decide how much lands on each day.',
              ),
            ]),
            h2([Component.text('Try the three moments')]),
            ol([
              li([
                strong([Component.text('Plan. ')]),
                Component.text('Edit the goals, add your own steps, tap a size (Quick, Medium, Big) to change it.'),
              ]),
              li([
                strong([Component.text('Today. ')]),
                Component.text(
                  'Check in (Low, Okay, Good). Steps are suggested from what is left and how many days remain, '
                  'scaled by your energy. Drag a slider to take more or fewer. Steps left undone move to tomorrow.',
                ),
              ]),
              li([
                strong([Component.text('Retro. ')]),
                Component.text(
                  'Something is always celebrated: a finished week, or your best day, plus this week against last week. '
                  'Before Sunday you can preview it with a simulated partial or perfect week.',
                ),
              ]),
            ]),
            p(classes: 'internal-note', [
              Component.text('Mocked data, nothing is saved. No AI involved. The reset button starts over.'),
            ]),
          ]),
          const FinchWeeklyEmbed(),
        ]),
      ]),
    ]);
  }

  /// Styles for every `/internal` page (CSS is global, so the index uses them too).
  /// The palette follows the demo (sky gradient, ink text), not the site's dark theme.
  @css
  static List<StyleRule> get styles => [
    css('.internal-page').styles(
      minHeight: 100.vh,
      color: const Color('#313131'),
      fontFamily: FontFamily.list([FontFamily('Rubik'), FontFamilies.systemUi, FontFamilies.sansSerif]),
      raw: {'background': 'linear-gradient(#72cafc, #b8dff4 55%, #eaf6ea)'},
    ),
    css('.internal-main').styles(
      maxWidth: 70.rem,
      padding: Padding.symmetric(vertical: 2.5.rem, horizontal: 1.25.rem),
      margin: Margin.symmetric(horizontal: Unit.auto),
      boxSizing: BoxSizing.borderBox,
    ),
    css('.internal-demo').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.start,
      gap: Gap.all(2.5.rem),
    ),
    css('.internal-copy').styles(
      maxWidth: 26.rem,
      flex: Flex(grow: 1, shrink: 1, basis: 20.rem),
    ),
    css('.internal-page p, .internal-page li, .internal-page h1, .internal-page h2').styles(
      color: Color('#313131'),
      textAlign: TextAlign.left,
      fontFamily: FontFamily.list([FontFamily('Rubik'), FontFamilies.systemUi, FontFamilies.sansSerif]),
    ),
    css('.internal-page p, .internal-page li').styles(fontSize: 1.rem),
    css('.internal-page h1').styles(color: Color('#386d84'), fontSize: 2.rem, lineHeight: 1.2.em),
    css('.internal-page h2').styles(
      color: Color('#386d84'),
      fontSize: 1.2.rem,
      margin: Margin.only(top: 1.5.rem),
    ),
    css('.internal-page li').styles(
      margin: Margin.only(bottom: 0.6.rem),
      lineHeight: 1.45.em,
    ),
    css('.internal-page strong').styles(color: Color('#386d84')),
    css('.internal-page a').styles(color: Color('#386d84'), fontWeight: FontWeight.w500),
    css('.internal-lead').styles(fontSize: 1.05.rem, lineHeight: 1.5.em),
    css('.internal-back').styles(fontSize: 0.9.rem, textDecoration: TextDecoration.none),
    css('.internal-note').styles(
      padding: Padding.all(0.75.rem),
      radius: BorderRadius.circular(12.px),
      fontSize: 0.9.rem,
      backgroundColor: Color('#fff8e8'),
    ),
    css('.finch-phone').styles(
      width: finchDemoWidth.px,
      height: finchDemoHeight.px,
      padding: Padding.symmetric(vertical: 18.px),
      overflow: Overflow.hidden,
      border: Border.all(width: 10.px, color: Color('#313131')),
      radius: BorderRadius.circular(44.px),
      flex: Flex(shrink: 0),
      backgroundColor: Color('#ffffff'),
      shadow: BoxShadow(offsetX: 0.px, offsetY: 18.px, blur: 40.px, color: Color('#386d8455')),
    ),
    css.media(MediaQuery.all(maxWidth: 460.px), [
      css('.internal-main').styles(
        padding: Padding.symmetric(vertical: 1.5.rem, horizontal: 0.px),
      ),
      css('.internal-copy').styles(padding: Padding.symmetric(horizontal: 1.25.rem)),
      css('.finch-phone').styles(
        padding: Padding.zero,
        border: Border.none,
        radius: BorderRadius.circular(0.px),
        shadow: BoxShadow.none,
      ),
    ]),
  ];
}
