import 'package:jaspr/server.dart';

import '../components/bio.dart';

/// The standalone home page.
///
/// Renders the [Bio] component full-screen.
class HomePage extends StatelessComponent {
  const HomePage({required this.base});

  /// The base path the site is served from ('/' for user GitHub Pages sites).
  final String base;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(
        title: 'Pietro Teruya Domingues',
        meta: {
          'description':
              'Software Engineer specialized in Flutter & mobile development, with a mechatronics background.',
        },
      ),
      const Bio(),
    ]);
  }
}
