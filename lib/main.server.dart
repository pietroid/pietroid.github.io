/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

// Server-specific Jaspr import.
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

import 'components/apps.dart';
import 'github_pages_base.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

final base = kDebugMode ? '/' : '$githubPagesBase/';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [ContentApp] spins up the content rendering pipeline from jaspr_content to render
  // your markdown files in the content/ directory to a beautiful documentation site.
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
      body: ContentApp(
        // Enables mustache templating inside the markdown files.
        templateEngine: MustacheTemplateEngine(),
        parsers: [
          MarkdownParser(),
        ],
        extensions: [
          // Adds heading anchors to each heading.
          HeadingAnchorsExtension(),
          // Generates a table of contents for each page.
          //TableOfContentsExtension(),
        ],
        components: [
          // The <Info> block and other callouts.
          Callout(),
          // Adds zooming and caption support to images.
          Image(zoom: true),
          // Embeds the Flutter apps grid demo.
          Apps(),
        ],
        layouts: [
          // Out-of-the-box layout for documentation sites.
          DocsLayout(
            header: Header(
              title: 'pietroid',
              logo: '${base}assets/favicon-32x32.png',
              items: [
                a(href: 'https://github.com/pietroid/', [
                  img(src: '${base}assets/github.svg', alt: 'GitHub', width: 24, height: 24),
                ]),
                a(href: 'https://br.linkedin.com/in/pietroid/', [
                  img(src: '${base}assets/linkedin.svg', alt: 'LinkedIn', width: 24, height: 24),
                ]),
              ],
            ),
            sidebar: Sidebar(
              groups: [
                SidebarGroup(
                  title: 'Posts',
                  links: [
                    SidebarLink(
                      text: 'How I created my blog from scratch with Node.js, MDX Remark and Github Pages',
                      href: '${base}posts/creating_my_blog',
                    ),
                    SidebarLink(
                      text: 'Jaspr Announcement',
                      href: '${base}posts/jaspr_announcement',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        theme: ContentTheme(
          background: Color('#010B1B'),
          text: Color('rgb(184, 192, 207)'),
          font: FontFamily('Geist Mono'),
          codeFont: FontFamily('Geist Mono'),
          colors: [
            ContentColors.headings.apply(Color('#FFFFFF')),
            ContentColors.links.apply(Color('rgb(7, 171, 200)')),
            ContentColors.bold.apply(Color('#FFFFFF')),
            ContentColors.code.apply(Color('#69d8d6')),
            ContentColors.preCode.apply(Color('#69d8d6')),
            ContentColors.preBg.apply(Color('#1b2f3e')),
            ContentColors.quotes.apply(Color('rgb(184, 192, 207)')),
            ContentColors.quoteBorders.apply(Color('#3e6e7b')),
            ContentColors.captions.apply(Color('rgb(184, 192, 207)')),
          ],
          typography: ContentTypography.base.apply(
            styles: Styles(
              textAlign: TextAlign.justify,
              lineHeight: Unit.em(1.5),
            ),
            rules: [
              css('h1, h2, h3, h4').styles(fontFamily: FontFamily('Onest')),
            ],
          ),
        ),
      ),
    ),
  );
}
