import 'package:jaspr/dom.dart';

/// Shared colors from the offline draft style guidelines.
///
/// These are used by the presentation card and other components that follow
/// the `offline_draft/index.html` look.
class SiteDraftColors {
  /// Pure black page/card background.
  static const black = Color('#000000');

  /// Primary text on dark backgrounds.
  static const white = Color('#ffffff');

  /// Muted secondary text (e.g. subtitles).
  static const subtitleGray = Color('#a5a5a5');

  /// Bio/home frame background (near-black from the Figma home design).
  static const bioBackground = Color('#0f0f0f');
}

/// Shared font families and fallback stacks from the offline draft style
/// guidelines.
class SiteDraftFonts {
  static const plusJakartaSans = FontFamily('Plus Jakarta Sans');
  static const ibmPlexMono = FontFamily('IBM Plex Mono');

  /// Heading font stack: Plus Jakarta Sans with system fallbacks.
  static final plusJakartaSansStack = FontFamily.list([
    plusJakartaSans,
    FontFamilies.systemUi,
    FontFamily('-apple-system'),
    FontFamily('BlinkMacSystemFont'),
    FontFamily('Segoe UI'),
    FontFamilies.sansSerif,
  ]);

  /// Body/monospace font stack: IBM Plex Mono with system fallbacks.
  static final ibmPlexMonoStack = FontFamily.list([
    ibmPlexMono,
    FontFamilies.uiMonospace,
    FontFamily('SFMono-Regular'),
    FontFamily('SF Mono'),
    FontFamily('Menlo'),
    FontFamily('Consolas'),
    FontFamilies.monospace,
  ]);
}

/// Shared text sizing from the offline draft style guidelines.
class SiteDraftTextStyles {
  static final display = 32.44.px;
  static final heading = 28.83.px;
  static final body = 14.px;
  static final nav = 14.px;
  static final caption = 12.px;
}

/// Shared element sizing from the offline draft style guidelines.
class SiteDraftElementSizes {
  static final avatar = 8.9375.rem;
  static final socialIcon = 1.6875.rem;
}

/// Shared spacing values from the offline draft style guidelines.
class SiteDraftSpacings {
  static final bodyPadding = 2.rem;
  static final cardGap = 1.rem;
  static final infoMarginLeft = 2.rem;
  static final infoGap = 0.5.rem;
  static final socialGap = 0.875.rem;
}
