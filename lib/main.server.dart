/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'github_pages_base.dart';
import 'pages/home_page.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

final base = kDebugMode ? '/' : '$githubPagesBase/';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultServerOptions);

  // Starts the app.
  //
  // The home page ('/') is rendered by [HomePage], a standalone Jaspr
  // component. Markdown-driven pages are currently disabled while the site
  // is being rebuilt.
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
      body: HomePage(base: base),
    ),
  );
}
