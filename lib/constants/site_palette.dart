import 'package:jaspr/dom.dart';

/// The color palette of the site, shared by the layout and custom components.
///
/// These mirror the colors already used in `web/styles.css` and the
/// [ContentTheme] defined in `main.server.dart`.
class SitePalette {
  /// Page background (deep navy).
  static const background = Color('#010B1B');

  /// Card / content surface.
  static const surface = Color('#0B1224');

  /// Slightly lighter surface for inner cards.
  static const surfaceLight = Color('#101A33');

  /// Main body text color.
  static const text = Color('rgb(184, 192, 207)');

  /// Headings / emphasis.
  static const heading = Color('#FFFFFF');

  /// Links.
  static const link = Color('rgb(7, 171, 200)');

  /// Accent (code, highlights, active states).
  static const accent = Color('#69d8d6');

  /// Subtle borders.
  static const border = Color('#3e6e7b');

  /// Code block background.
  static const codeBackground = Color('#1b2f3e');
}
