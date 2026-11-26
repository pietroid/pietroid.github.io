import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

/// `/internal`: unlisted demos and proposals. Not linked from the site.
class InternalIndexPage extends StatelessComponent {
  const InternalIndexPage({required this.base});

  final String base;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(title: 'Internal | pietroid', meta: {'robots': 'noindex, nofollow'}),
      div(classes: 'internal-page', [
        main_(classes: 'internal-main', [
          h1([Component.text('Internal')]),
          p(classes: 'internal-lead', [Component.text('Unlisted demos and product proposals.')]),
          ul(classes: 'internal-list', [
            li([
              a(href: '${base}internal/finch-weekly', [Component.text('Weekly goals, sized by your energy')]),
              Component.text(' · a Flutter concept demo in a self-care app style'),
            ]),
          ]),
        ]),
      ]),
    ]);
  }
}
