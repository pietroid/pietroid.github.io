import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Data for a single blog post loaded from `content/posts/`.
class PostItemData {
  const PostItemData({
    required this.slug,
    required this.title,
    required this.date,
    required this.url,
  });

  /// The URL-friendly post filename without extension.
  final String slug;

  /// The post title from frontmatter.
  final String title;

  /// The post date from frontmatter, as an ISO-8601 string when available.
  final String date;

  /// The site-relative URL for the post.
  final String url;
}

/// Loads blog posts from `content/posts/` and maps them to [PostItemData].
///
/// Files are read synchronously so the list can be consumed by Jaspr
/// components during static site generation. Posts are returned sorted by
/// date descending (newest first).
List<PostItemData> loadPosts() {
  final dir = Directory('content/posts');
  if (!dir.existsSync()) return [];

  final posts = <PostItemData>[];

  for (final file in dir.listSync().whereType<File>()) {
    if (p.extension(file.path) != '.md') continue;

    final content = file.readAsStringSync();
    final frontmatter = _parseFrontmatter(content);

    final slug = p.basenameWithoutExtension(file.path);
    final title = frontmatter['title'] as String? ?? slug;
    final date = frontmatter['date']?.toString() ?? '';

    posts.add(
      PostItemData(
        slug: slug,
        title: title,
        date: date,
        url: '/posts/$slug',
      ),
    );
  }

  posts.sort((a, b) => b.date.compareTo(a.date));
  return posts;
}

Map<String, Object?> _parseFrontmatter(String content) {
  final trimmed = content.trimLeft();
  if (!trimmed.startsWith('---')) return {};

  final end = trimmed.indexOf('---', 3);
  if (end == -1) return {};

  final yamlContent = trimmed.substring(3, end).trim();
  final doc = loadYaml(yamlContent);

  if (doc is! Map) return {};
  return doc.cast<String, Object?>();
}
