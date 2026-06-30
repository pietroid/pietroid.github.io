// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    deferred as _zoomable_image;
import 'package:jaspr_content/components/sidebar_toggle_button.dart'
    deferred as _sidebar_toggle_button;
import 'package:pietroid_github_io/components/apps_client_component.dart'
    deferred as _apps_client_component;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'jaspr_content:zoomable_image': ClientLoader(
      (p) => _zoomable_image.ZoomableImage(
        src: p['src'] as String,
        alt: p['alt'] as String?,
        caption: p['caption'] as String?,
      ),
      loader: _zoomable_image.loadLibrary,
    ),
    'jaspr_content:sidebar_toggle_button': ClientLoader(
      (p) => _sidebar_toggle_button.SidebarToggleButton(),
      loader: _sidebar_toggle_button.loadLibrary,
    ),
    'apps_client_component': ClientLoader(
      (p) => _apps_client_component.AppsClientComponent(),
      loader: _apps_client_component.loadLibrary,
    ),
  },
);
