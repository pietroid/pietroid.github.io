import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../constants/site_palette.dart';
import '../utils/dates.dart';

/// The main layout of the site.
///
/// Renders an app bar on top with the site brand, the main navigation
/// (Home, Projects, Blog) and the social links, followed by the page
/// content inside a centered card.
class SiteLayout extends PageLayoutBase {
  const SiteLayout({required this.base});

  /// The base path the site is served from ('/' for user GitHub Pages sites).
  final String base;

  @override
  String get name => 'site';

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final url = page.url;
    // Pages can set `hideTitle: true` to keep the h1 only for screen readers
    // (e.g. the home page, where the name is part of the content itself),
    // and `wide: true` for a wider content area (e.g. the home grid).
    final hideTitle = pageData['hideTitle'] == true;
    final wide = pageData['wide'] == true;

    return div(classes: 'site', [
      header(classes: 'site-header', [
        div(classes: 'site-header-inner', [
          a(classes: 'site-brand', href: base, [
            img(src: '${base}assets/favicon-32x32.png', alt: 'pietroid logo'),
            span([Component.text('pietroid')]),
          ]),
          nav(classes: 'site-nav', [
            _navItem(label: 'Home', href: base, active: url == '/'),
            _navItem(label: 'Projects', href: '${base}projects', active: url.startsWith('/projects')),
            _navItem(label: 'Blog', href: '${base}blog', active: url == '/blog' || url.startsWith('/posts/')),
          ]),
          div(classes: 'site-social', [
            a(href: 'https://github.com/pietroid/', attributes: {'aria-label': 'GitHub'}, [
              img(src: '${base}assets/github.svg', alt: 'GitHub', width: 22, height: 22),
            ]),
            a(href: 'https://br.linkedin.com/in/pietroid/', attributes: {'aria-label': 'LinkedIn'}, [
              img(src: '${base}assets/linkedin.svg', alt: 'LinkedIn', width: 22, height: 22),
            ]),
          ]),
        ]),
      ]),
      main_(classes: wide ? 'site-main site-main-wide' : 'site-main', [
        div(classes: 'site-content', [
          if (pageData['title'] case final String title)
            h1(classes: hideTitle ? 'page-title page-title-sr' : 'page-title', [Component.text(title)]),
          if (pageData['date'] case final String date)
            p(classes: 'page-date', [Component.text(formatPostDate(date))]),
          child,
        ]),
      ]),
    ]);
  }

  Component _navItem({required String label, required String href, required bool active}) {
    return a(classes: active ? 'active' : null, href: href, [Component.text(label)]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site').styles(
      minHeight: 100.vh,
      display: Display.flex,
      flexDirection: FlexDirection.column,
    ),
    css('.site-header', [
      css('&').styles(
        position: Position.sticky(top: Unit.zero),
        zIndex: ZIndex(10),
        backgroundColor: Color('rgba(1, 11, 27, 0.85)'),
        border: Border.only(bottom: BorderSide(width: 1.px, color: Color('rgba(255, 255, 255, 0.07)'))),
        raw: {'backdrop-filter': 'blur(8px)'},
      ),
      css('.site-header-inner', [
        css('&').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          flexWrap: FlexWrap.wrap,
          gap: Gap.all(1.rem),
          maxWidth: 64.rem,
          padding: Padding.symmetric(horizontal: 1.5.rem, vertical: 0.75.rem),
          margin: Margin.symmetric(horizontal: Unit.auto),
        ),
        css('.site-brand', [
          css('&').styles(
            display: Display.flex,
            alignItems: AlignItems.center,
            gap: Gap.all(0.6.rem),
            color: SitePalette.heading,
            fontFamily: FontFamily('Onest'),
            fontSize: 1.25.rem,
            fontWeight: FontWeight.w700,
            textDecoration: TextDecoration.none,
          ),
          css('img').styles(height: 1.5.rem, width: Unit.auto),
        ]),
        css('.site-nav', [
          css('&').styles(
            display: Display.flex,
            flex: Flex(grow: 1),
            gap: Gap.all(0.25.rem),
          ),
          css('a').styles(
            padding: Padding.symmetric(horizontal: 0.9.rem, vertical: 0.35.rem),
            radius: BorderRadius.circular(999.px),
            color: SitePalette.text,
            fontSize: 0.95.rem,
            textDecoration: TextDecoration.none,
          ),
          css('a:hover').styles(color: SitePalette.heading, backgroundColor: Color('rgba(255, 255, 255, 0.06)')),
          css('a.active').styles(color: SitePalette.accent, backgroundColor: Color('rgba(105, 216, 214, 0.12)')),
        ]),
        css('.site-social', [
          css('&').styles(display: Display.flex, alignItems: AlignItems.center, gap: Gap.all(1.rem)),
          css('a').styles(display: Display.flex, opacity: 0.8),
          css('a:hover').styles(opacity: 1),
        ]),
      ]),
    ]),
    css('.site-main', [
      css('&').styles(
        flex: Flex(grow: 1),
        width: 100.percent,
        maxWidth: 52.rem,
        padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 2.5.rem),
        margin: Margin.symmetric(horizontal: Unit.auto),
        boxSizing: BoxSizing.borderBox,
      ),
      // Wider content area for pages with `wide: true` (e.g. the home grid).
      css('&.site-main-wide').styles(maxWidth: 64.rem),
      css('.site-content').styles(
        backgroundColor: SitePalette.surface,
        padding: Padding.all(3.rem),
        radius: BorderRadius.circular(30.px),
      ),
      css.media(MediaQuery.all(maxWidth: 700.px), [
        css('.site-content').styles(
          padding: Padding.all(1.5.rem),
          radius: BorderRadius.circular(20.px),
        ),
      ]),
      css('.page-title').styles(
        margin: Margin.only(top: Unit.zero),
        lineHeight: Unit.em(1.2),
      ),
      // Visually hidden h1 for pages with `hideTitle: true`
      // (kept for screen readers and SEO).
      css('.page-title-sr').styles(
        position: Position.absolute(),
        width: 1.px,
        height: 1.px,
        padding: Padding.zero,
        margin: Margin.all(Unit.pixels(-1)),
        overflow: Overflow.hidden,
        border: Border.none,
        raw: {'clip': 'rect(0 0 0 0)', 'white-space': 'nowrap'},
      ),
      css('.page-date').styles(
        margin: Margin.only(top: Unit.zero),
        color: SitePalette.accent,
        fontSize: 0.9.rem,
      ),
    ]),
  ];
}
