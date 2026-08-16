// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    as _zoomable_image;
import 'package:jaspr_content/components/callout.dart' as _callout;
import 'package:jaspr_content/components/image.dart' as _image;
import 'package:pietroid_github_io/components/apps_client_component.dart'
    as _apps_client_component;
import 'package:pietroid_github_io/components/blog_index.dart' as _blog_index;
import 'package:pietroid_github_io/components/home_grid.dart' as _home_grid;
import 'package:pietroid_github_io/components/project_card.dart'
    as _project_card;
import 'package:pietroid_github_io/layouts/site_layout.dart' as _site_layout;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _zoomable_image.ZoomableImage: ClientTarget<_zoomable_image.ZoomableImage>(
      'jaspr_content:zoomable_image',
      params: __zoomable_imageZoomableImage,
    ),
    _apps_client_component.AppsClientComponent:
        ClientTarget<_apps_client_component.AppsClientComponent>(
          'apps_client_component',
        ),
  },
  styles: () => [
    ..._callout.Callout.styles,
    ..._image.Image.styles,
    ..._zoomable_image.ZoomableImage.styles,
    ..._blog_index.BlogIndex.styles,
    ..._home_grid.HomeGrid.styles,
    ..._project_card.ProjectCard.styles,
    ..._site_layout.SiteLayout.styles,
  ],
);

Map<String, Object?> __zoomable_imageZoomableImage(
  _zoomable_image.ZoomableImage c,
) => {'src': c.src, 'alt': c.alt, 'caption': c.caption};
