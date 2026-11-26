import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

@Import.onWeb('../../widgets/finch_weekly/finch_weekly_app.dart', show: [#FinchWeeklyApp])
import 'finch_weekly_embed.imports.dart' deferred as demo;

/// Phone-sized size of the embedded demo.
const finchDemoWidth = 390.0;
const finchDemoHeight = 800.0;

/// Embeds the Flutter weekly goals demo (`FinchWeeklyApp`) in the page.
@client
class FinchWeeklyEmbed extends StatelessComponent {
  const FinchWeeklyEmbed({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'finch-phone', [
      FlutterEmbedView.deferred(
        constraints: ViewConstraints(
          minWidth: finchDemoWidth,
          minHeight: finchDemoHeight,
          maxWidth: finchDemoWidth,
          maxHeight: finchDemoHeight,
        ),
        loadLibrary: demo.loadLibrary(),
        builder: () => demo.FinchWeeklyApp(),
      ),
    ]);
  }
}
