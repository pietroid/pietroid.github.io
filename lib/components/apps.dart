import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'apps_client_component.dart';

/// Embeds the Flutter apps grid demo in a markdown page.
class Apps extends CustomComponentBase {
  const Apps();

  @override
  Pattern get pattern => 'Apps';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return const AppsClientComponent();
  }
}
