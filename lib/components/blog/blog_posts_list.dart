import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../data/posts_loader.dart';
import '../column.dart';
import 'blog_post_item.dart';

/// A vertical list of blog post cards.
class BlogPostsList extends StatelessComponent {
  const BlogPostsList({required this.items, super.key});

  final List<PostItemData> items;

  @override
  Component build(BuildContext context) {
    return Column(
      classes: 'blog-posts-list',
      align: AlignItems.start,
      gap: Gap.all(Unit.zero),
      children: [
        for (final item in items) BlogPostItem(data: item),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-posts-list').styles(
      width: 100.percent,
      maxWidth: 44.5625.rem,
      boxSizing: BoxSizing.borderBox,
    ),
  ];
}
