import 'package:jaspr/dom.dart';

/// Sizing constants shared across the experience section components.
///
/// Items are top-aligned so they can grow with their highlights; the date, dot
/// and logo get top margins that put their centers on [lineTop].
class ExperienceSizes {
  static final itemHeight = 4.5.rem;
  static final dateWidth = 9.rem;
  static final marker = 0.625.rem;
  static final logo = 2.5.rem;
  static final gap = 0.875.rem;

  /// Distance from the item top to the dot center (where the line starts).
  static final lineTop = (4.5 / 2).rem;

  /// Offset below the item bottom where the next item's dot center sits.
  static final lineBottom = (-4.5 / 2).rem;

  /// Top margins that center each column on [lineTop].
  static final dotTop = (4.5 / 2 - 0.625 / 2).rem;
  static final logoTop = (4.5 / 2 - 2.5 / 2).rem;
  static final dateTop = (4.5 / 2 - 0.6125).rem;

  /// Horizontal position of the timeline line (centered on the dot column).
  static final lineLeft = (9 + 0.875 + 0.625 / 2).rem;

  /// Line position on narrow screens, where the date column is hidden.
  static final lineLeftMobile = (0.625 / 2).rem;
}
