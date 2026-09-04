import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/site_header.dart';
import '../constants/site_styles.dart';

/// The shared layout for all markdown-driven pages.
///
/// Unlike the built-in [PageLayoutBase], this layout does not create its own
/// [Document]; it is meant to be rendered inside the global [Document] created
/// by [main.server.dart]. It injects the page title into the shared head and
/// wraps the content with the site header and a centered content column.
class SiteLayout implements PageLayout {
  const SiteLayout({required this.base});

  /// The base path the site is served from.
  final String base;

  @override
  Pattern get name => RegExp(r'^site$');

  @override
  Component buildLayout(Page page, Component child) {
    final pageData = page.data.page;
    final title = pageData['title'] as String?;
    final description = pageData['description'] as String?;
    final isPost = page.path.startsWith('posts/');

    return Component.fragment([
      Document.head(
        title: title != null ? '$title | pietroid' : 'pietroid',
        meta: {if (description != null) 'description': description},
      ),
      div(classes: 'site-page', [
        SiteHeader(base: base),
        main_(classes: 'site-main', [
          if (isPost && title != null)
            div(classes: 'post-header', [
              h1([Component.text(title)]),
            ]),
          child,
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-page').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      minHeight: 100.vh,
      color: SiteDraftColors.white,
      backgroundColor: SiteDraftColors.bioBackground,
      boxSizing: BoxSizing.borderBox,
    ),
    css('.site-main').styles(
      width: 100.percent,
      maxWidth: 44.5625.rem,
      padding: Padding.symmetric(
        vertical: 2.rem,
        horizontal: SiteDraftSpacings.bodyPadding,
      ),
      boxSizing: BoxSizing.borderBox,
    ),
  ];
}
