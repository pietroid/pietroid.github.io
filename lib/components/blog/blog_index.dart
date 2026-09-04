import 'package:jaspr/jaspr.dart';

import '../../data/posts_loader.dart';
import 'blog_posts_list.dart';

/// Renders the list of posts for the `/blog` page.
///
/// This component is invoked from `content/blog.md` through the `<BlogIndex/>`
/// custom tag and reads the same posts used by the home page.
class BlogIndex extends StatelessComponent {
  const BlogIndex({super.key});

  @override
  Component build(BuildContext context) {
    final items = loadPosts();

    return BlogPostsList(items: items);
  }
}
