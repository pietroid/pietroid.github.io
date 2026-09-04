import 'package:jaspr/dom.dart';

/// Sizing constants shared across the experience section components.
class ExperienceSizes {
  static final itemHeight = 4.5.rem;
  static final dateWidth = 9.rem;
  static final marker = 0.625.rem;
  static final logo = 2.5.rem;
  static final gap = 0.875.rem;

  /// Vertical offset from the list edges to the first/last dot center.
  static final lineTop = (4.5 / 2).rem;

  /// Horizontal position of the timeline line (centered on the dot column).
  static final lineLeft = (9 + 0.875 + 0.625 / 2).rem;
}
