import 'package:jaspr_content/jaspr_content.dart';

/// Shifts every heading inside the markdown content down by one level.
///
/// This makes the page title (rendered by the layout as an `<h1>`) the only
/// top-level heading, while markdown `#` headings become `<h2>` section
/// headings.
class DemoteHeadingsExtension extends PageExtension {
  DemoteHeadingsExtension();

  static const _shift = {
    'h1': 'h2',
    'h2': 'h3',
    'h3': 'h4',
    'h4': 'h5',
    'h5': 'h6',
  };

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async {
    return _demote(nodes);
  }

  List<Node> _demote(List<Node> nodes) {
    return [
      for (final node in nodes)
        switch (node) {
          ElementNode(:final tag, :final attributes, :final children) =>
            ElementNode(
              _shift[tag] ?? tag,
              attributes,
              children != null ? _demote(children) : null,
            ),
          _ => node,
        },
    ];
  }
}
