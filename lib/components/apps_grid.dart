import 'package:pietroid_github_io/constants/theme.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class AppsGrid extends StatelessComponent {
  const AppsGrid({required this.children, super.key});

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize(cardWidth.px)),
            GridTrack(TrackSize(cardWidth.px)),
          ]),
          rows: GridTracks([
            GridTrack(TrackSize((cardHeight + 40).px)),
            GridTrack(TrackSize((cardHeight + 40).px)),
          ]),
        ),
        gap: Gap.all(16.px),
        margin: .only(top: 20.px),
      ),
      children,
    );
  }
}
