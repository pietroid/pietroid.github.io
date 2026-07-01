import 'package:pietroid_github_io/constants/theme.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

const _gridGap = 16.0;
const _maxGridWidth = cardWidth * 2 + _gridGap;

class AppsGrid extends StatelessComponent {
  const AppsGrid({required this.children, super.key});

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        display: Display.grid,
        width: 100.percent,
        maxWidth: _maxGridWidth.px,
        margin: .only(top: 20.px),
        justifyContent: JustifyContent.center,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack.repeat(
              TrackRepeat.autoFit,
              [
                GridTrack(
                  TrackSize.minmax(
                    TrackSize(Unit.expression('min(${cardWidth.px.value}, 100%)')),
                    TrackSize(cardWidth.px),
                  ),
                ),
              ],
            ),
          ]),
        ),
        gap: Gap.all(_gridGap.px),
      ),
      children,
    );
  }
}
