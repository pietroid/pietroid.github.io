import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../constants/site_styles.dart';
import '../../data/posts_loader.dart';

/// A single blog post card linking to the post page.
class BlogPostItem extends StatelessComponent {
  const BlogPostItem({required this.data, super.key});

  final PostItemData data;

  @override
  Component build(BuildContext context) {
    return a(
      classes: 'blog-post-item',
      href: data.url,
      [
        div(classes: 'blog-post-info', [
          h3([Component.text(data.title)]),
          span(classes: 'blog-post-date', [Component.text(data.date)]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-post-item').styles(
      width: 100.percent,
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.spaceBetween,
      textDecoration: TextDecoration.none,
      boxSizing: BoxSizing.borderBox,
      padding: Padding.symmetric(vertical: 0.4.rem),
    ),
    css('.blog-post-item:hover h3').styles(
      opacity: 0.7,
    ),
    css('.blog-post-info').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.125.rem),
    ),
    css('.blog-post-date').styles(
      color: SiteDraftColors.subtitleGray,
      fontFamily: SiteDraftFonts.ibmPlexMonoStack,
      fontSize: SiteDraftTextStyles.caption,
      fontWeight: FontWeight.w400,
    ),
  ];
}
