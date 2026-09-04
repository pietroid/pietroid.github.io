import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../data/posts_loader.dart';
import '../column.dart';
import 'blog_posts_list.dart';

/// The "latest posts" section shown at the bottom of the home page.
///
/// Reads all posts from `content/posts/` at build time and renders them as
/// linked cards, using the same list component as `/blog`.
class LastPostsSection extends StatelessComponent {
  LastPostsSection({super.key});

  final List<PostItemData> _items = loadPosts();

  @override
  Component build(BuildContext context) {
    return Column(
      align: AlignItems.center,
      gap: Gap.all(2.rem),
      padding: Padding.only(top: 3.rem, bottom: 6.rem),
      children: [
        h2(
          styles: Styles(textAlign: TextAlign.center),
          [Component.text('Latest Posts')],
        ),
        BlogPostsList(items: _items),
      ],
    );
  }
}
