/// Date helpers used to show and sort post dates.
///
/// Post dates are declared in the frontmatter as `date: yyyy-MM-dd`.
/// The legacy `dd-MM-yyyy` format is also understood when parsing.
library;

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// Parses a date string in `yyyy-MM-dd` or legacy `dd-MM-yyyy` format.
///
/// Returns [DateTime.fromMillisecondsSinceEpoch(0)] when unparseable,
/// so undated posts sort to the bottom.
DateTime parsePostDate(String raw) {
  final iso = DateTime.tryParse(raw.trim());
  if (iso != null) return iso;

  final legacy = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(raw.trim());
  if (legacy != null) {
    return DateTime(
      int.parse(legacy.group(3)!),
      int.parse(legacy.group(2)!),
      int.parse(legacy.group(1)!),
    );
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}

/// Formats a raw frontmatter date as `Mar 7, 2025`.
///
/// Returns the raw string unchanged when it cannot be parsed.
String formatPostDate(String raw) {
  final date = parsePostDate(raw);
  if (date.millisecondsSinceEpoch == 0) return raw;
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}
