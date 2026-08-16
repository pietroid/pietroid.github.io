import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../constants/site_palette.dart';

/// The 2×2 grid of the home page: bio (top left), experience & education
/// timeline (top right), projects (bottom left) and blog posts (bottom right).
///
/// On mobile the boxes stack in document order: bio, experience, projects, blog.
///
/// Usage in markdown:
/// ```html
/// <HomeGrid>
///   <HomeBio name="..." image="..." alt="...">bio in markdown</HomeBio>
///   <HomeExperience>
///     <TimelineItem role="..." place="..." [link="..."] start="yyyy-MM" end="yyyy-MM|present"/>
///   </HomeExperience>
///   <HomeProjects>...</HomeProjects>
///   <HomeBlog>...</HomeBlog>
/// </HomeGrid>
/// ```
class HomeGrid extends CustomComponent {
  const HomeGrid() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node is! ElementNode || node.tag != 'HomeGrid') return null;

    Component? bio, experience, projects, blog;
    for (final child in node.children?.whereType<ElementNode>() ?? const <ElementNode>[]) {
      switch (child.tag) {
        case 'HomeBio':
          final name = child.attributes['name'];
          final image = child.attributes['image'];
          assert(
            name != null && image != null,
            'HomeBio requires "name" and "image" attributes. Found ${child.attributes}',
          );
          bio = _HomeBio(
            name: name!,
            image: image!,
            alt: child.attributes['alt'] ?? 'Profile photo',
            child: builder.build(child.children),
          );
        case 'HomeExperience':
          experience = _ExperienceTimeline(
            title: child.attributes['title'] ?? 'Experience & Education',
            items: [
              for (final item in child.children?.whereType<ElementNode>() ?? const <ElementNode>[])
                if (item.tag == 'TimelineItem') _TimelineItem.parse(item.attributes),
            ],
          );
        case 'HomeProjects':
          projects = _HomeBox(
            title: child.attributes['title'] ?? 'Projects',
            area: 'projects',
            child: builder.build(child.children),
          );
        case 'HomeBlog':
          blog = _HomeBox(
            title: child.attributes['title'] ?? 'Blog',
            area: 'blog',
            child: builder.build(child.children),
          );
      }
    }

    return _HomeGrid(bio: bio, experience: experience, projects: projects, blog: blog);
  }

  @css
  static List<StyleRule> get styles => [
    css('.home-grid', [
      css('&').styles(
        display: Display.grid,
        gap: Gap(row: 2.5.rem, column: 2.rem),
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))]),
          areas: GridAreas(['bio experience', 'projects blog']),
        ),
      ),
      css.media(MediaQuery.all(maxWidth: 700.px), [
        css('&').styles(
          gridTemplate: GridTemplate(
            columns: GridTracks([GridTrack(TrackSize.fr(1))]),
            areas: GridAreas(['bio', 'experience', 'projects', 'blog']),
          ),
        ),
      ]),
    ]),
    // Bio box: avatar on the left, name and bio text on the right.
    css('.home-bio', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.start,
        gap: Gap.all(1.25.rem),
        gridPlacement: GridPlacement.area('bio'),
      ),
      css('.home-bio-avatar').styles(
        width: 140.px,
        height: 140.px,
        flex: Flex(shrink: 0),
        // Overrides the vertical margins the content theme gives images.
        margin: Margin.zero,
        radius: BorderRadius.circular(50.percent),
        border: Border.all(width: 3.px, color: SitePalette.accent),
        raw: {'object-fit': 'cover'},
      ),
      // Justified text creates rivers in the narrow bio column.
      css('.home-bio-body').styles(textAlign: TextAlign.start),
      css('.home-bio-name').styles(
        margin: Margin.only(bottom: 0.75.rem),
        color: SitePalette.heading,
        fontFamily: FontFamily('Onest'),
        fontSize: 1.3.rem,
        fontWeight: FontWeight.w700,
      ),
      css('.home-bio-body > p:first-child').styles(margin: Margin.only(top: Unit.zero)),
      css('.home-bio-body > p:last-child').styles(margin: Margin.only(bottom: Unit.zero)),
      // On mobile the bio is all centered, with the name below the avatar.
      css.media(MediaQuery.all(maxWidth: 700.px), [
        css('&').styles(flexDirection: FlexDirection.column, alignItems: AlignItems.center),
        css('.home-bio-body').styles(textAlign: TextAlign.center),
        css('.home-bio-name').styles(margin: Margin.only(top: 0.25.rem, bottom: 0.75.rem)),
      ]),
    ]),
    // A grid box with a title: projects and blog.
    css('.home-box', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column),
      css('.home-box-title').styles(
        margin: Margin.only(top: Unit.zero, bottom: 1.25.rem),
        fontSize: 1.3.rem,
      ),
      css('.home-box-projects').styles(gridPlacement: GridPlacement.area('projects')),
      css('.home-box-blog').styles(gridPlacement: GridPlacement.area('blog')),
    ]),
    ..._ExperienceTimeline.styles,
  ];
}

class _HomeGrid extends StatelessComponent {
  const _HomeGrid({this.bio, this.experience, this.projects, this.blog});

  final Component? bio;
  final Component? experience;
  final Component? projects;
  final Component? blog;

  @override
  Component build(BuildContext context) {
    return div(classes: 'home-grid', [
      ?bio,
      ?experience,
      ?projects,
      ?blog,
    ]);
  }
}

class _HomeBio extends StatelessComponent {
  const _HomeBio({required this.name, required this.image, required this.alt, required this.child});

  final String name;
  final String image;
  final String alt;
  final Component child;

  @override
  Component build(BuildContext context) {
    return section(classes: 'home-bio', [
      img(classes: 'home-bio-avatar', src: image, alt: alt),
      div(classes: 'home-bio-body', [
        div(classes: 'home-bio-name', [Component.text(name)]),
        child,
      ]),
    ]);
  }
}

class _HomeBox extends StatelessComponent {
  const _HomeBox({required this.title, required this.area, required this.child});

  final String title;
  final String area;
  final Component child;

  @override
  Component build(BuildContext context) {
    return section(classes: 'home-box home-box-$area', [
      h2(classes: 'home-box-title', [Component.text(title)]),
      child,
    ]);
  }
}

/// A single entry of the experience & education timeline.
class _TimelineItem {
  const _TimelineItem({
    required this.role,
    required this.place,
    required this.start,
    required this.end,
    this.link,
    this.present = false,
  });

  final String role;
  final String place;
  final String? link;

  /// Month indices (`year * 12 + month - 1`); [end] is inclusive.
  final int start;
  final int end;
  final bool present;

  static _TimelineItem parse(Map<String, String> attributes) {
    final role = attributes['role'];
    final place = attributes['place'];
    final start = attributes['start'];
    final end = attributes['end'];
    assert(
      role != null && place != null && start != null && end != null,
      'TimelineItem requires "role", "place", "start" and "end" attributes. Found $attributes',
    );
    final present = end!.trim().toLowerCase() == 'present';
    return _TimelineItem(
      role: role!,
      place: place!,
      link: attributes['link'],
      start: _parseMonth(start!, endOfPeriod: false),
      end: present ? _currentMonth() : _parseMonth(end, endOfPeriod: true),
      present: present,
    );
  }

  /// Parses `yyyy-MM` or `yyyy` into a month index. A plain year means
  /// January for starts and December for ends (`endOfPeriod`).
  static int _parseMonth(String raw, {required bool endOfPeriod}) {
    final match = RegExp(r'^(\d{4})(?:-(\d{1,2}))?$').firstMatch(raw.trim());
    assert(match != null, 'TimelineItem dates must be "yyyy-MM" or "yyyy". Found "$raw"');
    final year = int.parse(match!.group(1)!);
    final month = int.parse(match.group(2) ?? (endOfPeriod ? '12' : '1'));
    return year * 12 + month - 1;
  }

  static int _currentMonth() {
    final now = DateTime.now();
    return now.year * 12 + now.month - 1;
  }

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static String formatMonth(int monthIndex) => '${_months[monthIndex % 12]} ${monthIndex ~/ 12}';

  String get period => '${formatMonth(start)} — ${present ? 'Present' : formatMonth(end)}';
}

/// The proportional timeline of the experience & education box.
///
/// Every item is a dot and a segment on a vertical track; the vertical
/// position and length of each segment are proportional to the time it
/// represents (3px per month). Overlapping items (e.g. freelancing alongside a
/// full-time job) overlap on the same track.
class _ExperienceTimeline extends StatelessComponent {
  const _ExperienceTimeline({required this.title, required this.items});

  final String title;
  final List<_TimelineItem> items;

  /// The vertical size of a single month.
  static final Unit monthHeight = 3.px;

  @override
  Component build(BuildContext context) {
    if (items.isEmpty) {
      return section(classes: 'home-experience', [h2(classes: 'home-box-title', [Component.text(title)])]);
    }

    final rangeStart = items.map((i) => i.start).reduce((a, b) => a < b ? a : b);
    final rangeEnd = items.map((i) => i.end).reduce((a, b) => a > b ? a : b);
    final totalMonths = rangeEnd - rangeStart + 1;

    int rowOf(int monthIndex) => monthIndex - rangeStart + 1;

    return section(classes: 'home-experience', [
      h2(classes: 'home-box-title', [Component.text(title)]),
      div(
        classes: 'timeline',
        styles: Styles(
          gridTemplate: GridTemplate(
            columns: GridTracks([GridTrack(TrackSize(16.px)), GridTrack(TrackSize.fr(1))]),
            rows: GridTracks([GridTrack.repeat(TrackRepeat(totalMonths), [GridTrack(TrackSize(monthHeight))])]),
          ),
        ),
        [
          // The track connecting all items.
          div(classes: 'timeline-track', [
            div(classes: 'timeline-track-line', []),
          ]),
          for (final item in items) ...[
            // The segment of the track this item spans.
            div(
              classes: 'timeline-segment',
              styles: Styles(
                gridPlacement: GridPlacement(
                  rowStart: LinePlacement(rowOf(item.start)),
                  rowEnd: LinePlacement(rowOf(item.end) + 1),
                  columnStart: const LinePlacement(1),
                  columnEnd: const LinePlacement(2),
                ),
              ),
              [],
            ),
            // The dot marking the start of the item.
            div(
              classes: item.present ? 'timeline-dot timeline-dot-present' : 'timeline-dot',
              styles: Styles(
                gridPlacement: GridPlacement(
                  rowStart: LinePlacement(rowOf(item.start)),
                  rowEnd: LinePlacement(rowOf(item.start) + 1),
                  columnStart: const LinePlacement(1),
                  columnEnd: const LinePlacement(2),
                ),
              ),
              [],
            ),
            // The label, placed to the right of the track at the item's start row.
            div(
              classes: 'timeline-label',
              styles: Styles(
                gridPlacement: GridPlacement(
                  rowStart: LinePlacement(rowOf(item.start)),
                  rowEnd: LinePlacement(rowOf(item.end) + 1),
                  columnStart: const LinePlacement(2),
                  columnEnd: const LinePlacement(3),
                ),
              ),
              [
                div(classes: 'timeline-label-role', [Component.text(item.role)]),
                div(classes: 'timeline-label-line', [
                  if (item.link case final link?)
                    a(classes: 'timeline-label-place', href: link, target: Target.blank, [Component.text(item.place)])
                  else
                    span(classes: 'timeline-label-place', [Component.text(item.place)]),
                  span(classes: 'timeline-label-separator', [Component.text(' · ')]),
                  span(classes: 'timeline-label-period', [Component.text(item.period)]),
                ]),
              ],
            ),
          ],
        ],
      ),
    ]);
  }

  static List<StyleRule> get styles => [
    css('.home-experience', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gridPlacement: GridPlacement.area('experience'),
      ),
      css('.timeline', [
        css('&').styles(display: Display.grid, flex: Flex(grow: 1), gap: Gap.column(0.75.rem)),
        css('.timeline-track', [
          css('&').styles(
            display: Display.flex,
            justifyContent: JustifyContent.center,
            gridPlacement: GridPlacement(
              rowStart: const LinePlacement(1),
              rowEnd: const LinePlacement(-1),
              columnStart: const LinePlacement(1),
              columnEnd: const LinePlacement(2),
            ),
          ),
          css('.timeline-track-line').styles(
            width: 2.px,
            radius: BorderRadius.circular(1.px),
            backgroundColor: SitePalette.border,
          ),
        ]),
        css('.timeline-segment').styles(
          width: 3.px,
          justifySelf: JustifySelf.center,
          radius: BorderRadius.circular(2.px),
          backgroundColor: Color('rgba(105, 216, 214, 0.45)'),
        ),
        css('.timeline-dot', [
          css('&').styles(
            width: 9.px,
            height: 9.px,
            justifySelf: JustifySelf.center,
            alignSelf: AlignSelf.start,
            radius: BorderRadius.circular(50.percent),
            border: Border.all(width: 2.px, color: SitePalette.accent),
            backgroundColor: SitePalette.surface,
            raw: {'transform': 'translateY(-2.5px)', 'box-sizing': 'border-box'},
          ),
          // Ongoing items get a filled dot.
          css('&.timeline-dot-present').styles(backgroundColor: SitePalette.accent),
        ]),
        css('.timeline-label', [
          css('&').styles(
            display: Display.flex,
            minWidth: Unit.zero,
            flexDirection: FlexDirection.column,
            gap: Gap.all(0.1.rem),
            raw: {'transform': 'translateY(-0.45rem)'},
          ),
          css('.timeline-label-role').styles(
            color: SitePalette.heading,
            fontFamily: FontFamily('Onest'),
            fontSize: 0.85.rem,
            fontWeight: FontWeight.w600,
            lineHeight: Unit.em(1.3),
          ),
          css('.timeline-label-line').styles(color: SitePalette.text, fontSize: 0.78.rem, lineHeight: Unit.em(1.3)),
          css('a.timeline-label-place').styles(color: SitePalette.link, textDecoration: TextDecoration.none),
          css('a.timeline-label-place:hover').styles(
            textDecoration: TextDecoration(line: TextDecorationLine.underline),
          ),
          css('.timeline-label-separator').styles(margin: Margin.symmetric(horizontal: 0.1.rem)),
          css('.timeline-label-period').styles(color: SitePalette.accent),
        ]),
        css.media(MediaQuery.all(maxWidth: 700.px), [
          css('.timeline-label-role').styles(fontSize: 0.8.rem),
          css('.timeline-label-line').styles(fontSize: 0.75.rem),
        ]),
      ]),
    ]),
  ];
}
