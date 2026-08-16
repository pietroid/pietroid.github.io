import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../constants/site_palette.dart';

/// A card for a project: image on top, then title, description, status,
/// date and an optional GitHub link.
///
/// The whole card navigates to the project page ([href]) using the
/// "stretched link" CSS pattern, so the GitHub link stays clickable.
///
/// Usage in markdown:
/// `<ProjectCard image="images/scribe.svg" title="Scribe" description="An app to help me on my studies" status="In progress" date="Started Jul 2026" github="https://github.com/pietroid/scribe" href="projects/scribe"/>`
class ProjectCard extends CustomComponentBase {
  const ProjectCard();

  @override
  Pattern get pattern => 'ProjectCard';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    final image = attributes['image'];
    final title = attributes['title'];
    final description = attributes['description'];
    final status = attributes['status'];
    final date = attributes['date'];
    final href = attributes['href'];
    final github = attributes['github'];
    assert(
      image != null && title != null && description != null && status != null && date != null && href != null,
      'ProjectCard requires "image", "title", "description", "status", "date" and "href" attributes. Found $attributes',
    );

    return div(classes: 'project-card', [
      img(classes: 'project-card-image', src: image!, alt: title!),
      div(classes: 'project-card-body', [
        div(classes: 'project-card-header', [
          h3(classes: 'project-card-title', [
            a(classes: 'project-card-link', href: href!, [Component.text(title)]),
          ]),
          span(classes: 'project-card-status', [Component.text(status!)]),
        ]),
        p(classes: 'project-card-description', [Component.text(description!)]),
        div(classes: 'project-card-footer', [
          span(classes: 'project-card-date', [Component.text(date!)]),
          if (github != null)
            a(classes: 'project-card-github', href: github, target: Target.blank, [Component.text('GitHub')]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.project-card', [
      css('&').styles(
        position: Position.relative(),
        overflow: Overflow.hidden,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        margin: Margin.only(bottom: 1.5.rem),
        backgroundColor: SitePalette.surfaceLight,
        radius: BorderRadius.circular(20.px),
        border: Border.all(width: 1.px, color: Color('rgba(255, 255, 255, 0.06)')),
        transition: Transition('border-color', duration: 150.ms, curve: Curve.easeInOut),
      ),
      css('&:hover').styles(border: Border.all(width: 1.px, color: SitePalette.accent)),
      css('.project-card-image').styles(
        width: 100.percent,
        height: 200.px,
        raw: {'object-fit': 'cover'},
      ),
      css('.project-card-body', [
        css('&').styles(
          display: Display.flex,
          flex: Flex(grow: 1),
          flexDirection: FlexDirection.column,
          gap: Gap.all(0.75.rem),
          padding: Padding.all(1.5.rem),
        ),
        css('.project-card-header', [
          css('&').styles(
            display: Display.flex,
            alignItems: AlignItems.center,
            justifyContent: JustifyContent.spaceBetween,
            flexWrap: FlexWrap.wrap,
            gap: Gap.all(0.75.rem),
          ),
          css('.project-card-title').styles(margin: Margin.zero, fontSize: 1.4.rem),
          css('.project-card-link', [
            css('&').styles(color: SitePalette.heading, textDecoration: TextDecoration.none),
            // The stretched link: makes the whole card clickable.
            css('&::after').styles(
              position: Position.absolute(),
              raw: {'content': "''", 'inset': '0'},
            ),
          ]),
          css('.project-card-status').styles(
            padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.2.rem),
            radius: BorderRadius.circular(999.px),
            backgroundColor: Color('rgba(105, 216, 214, 0.12)'),
            color: SitePalette.accent,
            fontSize: 0.8.rem,
            whiteSpace: WhiteSpace.noWrap,
          ),
        ]),
        css('.project-card-description').styles(margin: Margin.zero, flex: Flex(grow: 1)),
        css('.project-card-footer', [
          css('&').styles(
            display: Display.flex,
            alignItems: AlignItems.center,
            justifyContent: JustifyContent.spaceBetween,
            gap: Gap.all(0.75.rem),
          ),
          css('.project-card-date').styles(color: SitePalette.text, fontSize: 0.85.rem),
          css('.project-card-github').styles(
            position: Position.relative(),
            zIndex: ZIndex(1),
            padding: Padding.symmetric(horizontal: 0.9.rem, vertical: 0.3.rem),
            radius: BorderRadius.circular(999.px),
            border: Border.all(width: 1.px, color: SitePalette.border),
            color: SitePalette.link,
            fontSize: 0.85.rem,
            textDecoration: TextDecoration.none,
          ),
          css('.project-card-github:hover').styles(
            border: Border.all(width: 1.px, color: SitePalette.link),
          ),
        ]),
      ]),
    ]),
  ];
}
