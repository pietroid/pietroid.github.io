import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// A generic vertical flex container.
class Column extends StatelessComponent {
  const Column({
    super.key,
    required this.children,
    this.classes,
    this.align = AlignItems.start,
    this.justify,
    this.gap,
    this.width,
    this.padding,
  });

  final List<Component> children;
  final String? classes;
  final AlignItems align;
  final JustifyContent? justify;
  final Gap? gap;
  final Unit? width;
  final Padding? padding;

  @override
  Component build(BuildContext context) {
    return div(
      classes: classes,
      styles: Styles(
        display: Display.flex,
        width: width,
        padding: padding,
        boxSizing: BoxSizing.borderBox,
        flexDirection: FlexDirection.column,
        justifyContent: justify,
        alignItems: align,
        gap: gap,
      ),
      children,
    );
  }
}
