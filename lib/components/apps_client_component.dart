import 'package:pietroid_github_io/components/apps_grid.dart';
import 'package:pietroid_github_io/constants/theme.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

@Import.onWeb(
  '../widgets/apps.dart',
  show: [
    #FirstAppWidget,
    #SecondAppWidget,
    #ThirdAppWidget,
    #FourthAppWidget,
  ],
)
import 'apps_client_component.imports.dart' deferred as widget;

@client
class AppsClientComponent extends StatelessComponent {
  const AppsClientComponent({super.key});

  @override
  Component build(BuildContext context) {
    final List<({String label, Widget Function() builder})> items = [
      (
        label: 'E-commerce app',
        builder: () => widget.FirstAppWidget(),
      ),
      (
        label: 'Social network app',
        builder: () => widget.SecondAppWidget(),
      ),
      (
        label: 'Todo list app',
        builder: () => widget.ThirdAppWidget(),
      ),
      (
        label: 'Text editor app',
        builder: () => widget.FourthAppWidget(),
      ),
    ];

    return div(
      styles: Styles(
        display: Display.flex,
        justifyContent: JustifyContent.center,
      ),
      [
        AppsGrid(
          children: [
            for (final item in items)
              div(
                styles: Styles(
                  boxSizing: BoxSizing.borderBox,
                  width: 100.percent,
                  height: 100.percent,
                  border: Border.all(style: BorderStyle.solid, color: primaryColor),
                  radius: BorderRadius.circular(cardBorderRadius.px),
                  overflow: Overflow.hidden,
                  display: Display.flex,
                  flexDirection: FlexDirection.column,
                ),
                [
                  div(
                    styles: Styles(
                      padding: Padding.all(8.px),
                      backgroundColor: primaryColor,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    [Component.text(item.label)],
                  ),
                  div(
                    styles: Styles(
                      width: cardWidth.px,
                      height: cardHeight.px,
                    ),
                    [
                      FlutterEmbedView.deferred(
                        constraints: ViewConstraints(
                          minWidth: cardWidth,
                          minHeight: cardHeight,
                          maxWidth: cardWidth,
                          maxHeight: cardHeight,
                        ),
                        loadLibrary: widget.loadLibrary(),
                        builder: item.builder,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
