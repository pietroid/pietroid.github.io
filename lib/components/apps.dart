import 'package:pietroid_github_io/components/apps_client_component.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

class Apps extends CustomComponentBase {
  const Apps();

  @override
  Pattern get pattern => 'Apps';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return const AppsClientComponent();
  }
}
