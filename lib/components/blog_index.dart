import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../constants/site_palette.dart';
import '../utils/dates.dart';

/// Lists all blog posts (pages under `/posts/`) with their dates,
/// most recent first.
///
/// The dates come from each post's frontmatter `date: yyyy-MM-dd` entry.
/// Requires `eagerlyLoadAllPages: true` on the [ContentApp] so the list
/// of pages is fully available when this component is built.
///
/// Usage in markdown: `<BlogIndex/>`
class BlogIndex extends CustomComponentBase {
  const BlogIndex({this.base = '/'});

  /// The base path the site is served from ('/' for user GitHub Pages sites).
  final String base;

  @override
  Pattern get pattern => 'BlogIndex';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return _BlogIndex(base: base);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-index', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column),
      css('.blog-index-item', [
        css('&').styles(
          display: Display.flex,
          alignItems: AlignItems.baseline,
          gap: Gap.all(1.rem),
          padding: Padding.symmetric(vertical: 0.9.rem),
          border: Border.only(bottom: BorderSide(width: 1.px, color: Color('rgba(255, 255, 255, 0.06)'))),
          textDecoration: TextDecoration.none,
        ),
        css('&:last-child').styles(border: Border.none),
        css('.blog-index-date').styles(
          flex: Flex(shrink: 0),
          minWidth: 7.5.rem,
          color: SitePalette.accent,
          fontSize: 0.85.rem,
          whiteSpace: WhiteSpace.noWrap,
        ),
        css('.blog-index-title').styles(
          color: SitePalette.text,
          transition: Transition('color', duration: 150.ms, curve: Curve.easeInOut),
        ),
        css('&:hover .blog-index-title').styles(color: SitePalette.heading),
      ]),
      css.media(MediaQuery.all(maxWidth: 700.px), [
        css('.blog-index-item', [
          css('&').styles(flexDirection: FlexDirection.column, gap: Gap.all(0.25.rem)),
          css('.blog-index-date').styles(minWidth: Unit.zero),
        ]),
      ]),
    ]),
  ];
}

class _BlogIndex extends StatelessComponent {
  const _BlogIndex({required this.base});

  final String base;

  @override
  Component build(BuildContext context) {
    if (kIsWeb) return Component.fragment([]);

    final posts = context.pages.where((page) => page.url.startsWith('/posts/')).toList()
      ..sort((a, b) {
        final aDate = parsePostDate(a.data.page['date'] as String? ?? '');
        final bDate = parsePostDate(b.data.page['date'] as String? ?? '');
        return bDate.compareTo(aDate);
      });

    return div(classes: 'blog-index', [
      for (final post in posts)
        a(classes: 'blog-index-item', href: '$base${post.url.substring(1)}', [
          span(classes: 'blog-index-date', [
            Component.text(switch (post.data.page['date']) {
              final String date => formatPostDate(date),
              _ => '',
            }),
          ]),
          span(classes: 'blog-index-title', [
            Component.text(switch (post.data.page['title']) {
              final String title => title,
              _ => post.url,
            }),
          ]),
        ]),
    ]);
  }
}
