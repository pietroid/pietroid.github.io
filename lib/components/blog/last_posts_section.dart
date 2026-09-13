import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';
import '../../data/posts_loader.dart';
import '../column.dart';
import 'blog_posts_list.dart';

/// The "latest posts" section shown at the bottom of the home page.
///
/// Reads all posts from `content/posts/` at build time and renders them as
/// linked cards, using the same list component as `/blog`. The surrounding
/// padding matches the blog page so the two lists are visually consistent.
class LastPostsSection extends StatelessComponent {
  LastPostsSection({super.key});

  final List<PostItemData> _items = loadPosts();

  @override
  Component build(BuildContext context) {
    return div(classes: 'last-posts-section', [
      Column(
        align: AlignItems.center,
        gap: Gap.all(2.rem),
        children: [
          h2(
            styles: Styles(textAlign: TextAlign.center),
            [Component.text('Latest Posts')],
          ),
          BlogPostsList(items: _items),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.last-posts-section').styles(
      width: 100.percent,
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      padding: Padding.only(
        top: 3.rem,
        bottom: 6.rem,
        left: SiteDraftSpacings.bodyPadding,
        right: SiteDraftSpacings.bodyPadding,
      ),
      boxSizing: BoxSizing.borderBox,
    ),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.last-posts-section').styles(
        padding: Padding.only(
          top: 3.rem,
          bottom: 6.rem,
          left: SiteDraftSpacings.bodyPaddingMobile,
          right: SiteDraftSpacings.bodyPaddingMobile,
        ),
      ),
    ]),
  ];
}
