import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// A generic horizontal flex container.
class Row extends StatelessComponent {
  const Row({
    super.key,
    required this.children,
    this.classes,
    this.align = AlignItems.center,
    this.justify,
    this.gap,
  });

  final List<Component> children;
  final String? classes;
  final AlignItems align;
  final JustifyContent? justify;
  final Gap? gap;

  @override
  Component build(BuildContext context) {
    return div(
      classes: classes,
      styles: Styles(
        display: Display.flex,
        boxSizing: BoxSizing.borderBox,
        flexDirection: FlexDirection.row,
        justifyContent: justify,
        alignItems: align,
        gap: gap,
      ),
      children,
    );
  }
}
