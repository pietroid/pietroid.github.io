/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/blog/blog_index.dart';
import 'extensions/demote_headings_extension.dart';
import 'github_pages_base.dart';
import 'layouts/site_layout.dart';
import 'pages/home_page.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

final base = kDebugMode ? '/' : '$githubPagesBase/';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultServerOptions);

  // Starts the app.
  //
  // The home page ('/') is rendered by [HomePage]. Markdown-driven pages under
  // `content/` (blog, posts) are loaded by [ContentApp] and wrapped with the
  // shared [SiteLayout].
  runApp(
    Document(
      base: base,
      meta: {
        'description': 'The internet is not dead. There are still people out there, and I am one of them.',
        'keywords': 'pietro, software engineering, flutter, blog, philosophy',
        'og:title': 'pietroid',
        'og:description': 'The internet is not dead. There are still people out there, and I am one of them.',
        'og:image': '${base}assets/android-chrome-192x192.png',
      },
      head: [
        link(rel: 'stylesheet', href: '${base}styles.css'),
        link(rel: 'apple-touch-icon', href: '${base}assets/apple-touch-icon.png', attributes: {'sizes': '180x180'}),
        link(rel: 'icon', type: 'image/png', href: '${base}assets/favicon-32x32.png', attributes: {'sizes': '32x32'}),
        link(rel: 'icon', type: 'image/png', href: '${base}assets/favicon-16x16.png', attributes: {'sizes': '16x16'}),
        link(rel: 'manifest', href: '${base}assets/site.webmanifest'),
        script(src: '${base}flutter_bootstrap.js', async: true),
      ],
      body: ContentApp.custom(
        loaders: [FilesystemLoader('content', filterExtensions: {'.md'})],
        configResolver: (_) => PageConfig(
          enableFrontmatter: true,
          dataLoaders: [FilesystemDataLoader('content/_data')],
          parsers: [MarkdownParser()],
          extensions: [DemoteHeadingsExtension()],
          components: [
            CustomComponent(
              pattern: RegExp(r'^BlogIndex$'),
              builder: (name, attributes, child) => const BlogIndex(),
            ),
          ],
          layouts: [SiteLayout(base: base)],
          theme: ContentTheme.none(),
        ),
        routerBuilder: (routes) => Router(
          routes: [
            Route(path: '/', builder: (_, __) => HomePage(base: base)),
            for (final route in routes) ...route,
          ],
        ),
      ),
    ),
  );
}
