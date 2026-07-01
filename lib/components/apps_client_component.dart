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
        label: 'Todo list app',
        builder: () => widget.ThirdAppWidget(),
      ),
      (
        label: 'Text editor app',
        builder: () => widget.FourthAppWidget(),
      ),
      (
        label: 'E-commerce app',
        builder: () => widget.FirstAppWidget(),
      ),
      (
        label: 'Social network app',
        builder: () => widget.SecondAppWidget(),
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
                  display: Display.flex,
                  width: 100.percent,
                  height: 100.percent,
                  boxSizing: BoxSizing.borderBox,
                  border: Border.all(style: BorderStyle.solid, color: primaryColor),
                  radius: BorderRadius.circular(cardBorderRadius.px),
                  overflow: Overflow.hidden,
                  flexDirection: FlexDirection.column,
                ),
                [
                  div(
                    styles: Styles(
                      padding: Padding.all(8.px),
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      backgroundColor: primaryColor,
                    ),
                    [Component.text(item.label)],
                  ),
                  div(
                    styles: Styles(
                      width: cardWidth.px,
                      height: cardHeight.px,
                      alignSelf: AlignSelf.center,
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
