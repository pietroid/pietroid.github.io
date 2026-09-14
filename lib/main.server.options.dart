// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    as _zoomable_image;
import 'package:jaspr_content/components/image.dart' as _image;
import 'package:pietroid_github_io/components/bio/bio.dart' as _bio;
import 'package:pietroid_github_io/components/bio/bio_stack.dart' as _bio_stack;
import 'package:pietroid_github_io/components/blog/blog_post_item.dart'
    as _blog_post_item;
import 'package:pietroid_github_io/components/blog/blog_posts_list.dart'
    as _blog_posts_list;
import 'package:pietroid_github_io/components/blog/last_posts_section.dart'
    as _last_posts_section;
import 'package:pietroid_github_io/components/education/education_item.dart'
    as _education_item;
import 'package:pietroid_github_io/components/education/education_section.dart'
    as _education_section;
import 'package:pietroid_github_io/components/experience/experience_item.dart'
    as _experience_item;
import 'package:pietroid_github_io/components/experience/experience_list.dart'
    as _experience_list;
import 'package:pietroid_github_io/components/experience/experience_section.dart'
    as _experience_section;
import 'package:pietroid_github_io/components/experience/experience_timeline.dart'
    as _experience_timeline;
import 'package:pietroid_github_io/components/projects/project_context.dart'
    as _project_context;
import 'package:pietroid_github_io/components/projects/project_image.dart'
    as _project_image;
import 'package:pietroid_github_io/components/projects/project_item.dart'
    as _project_item;
import 'package:pietroid_github_io/components/projects/project_status.dart'
    as _project_status;
import 'package:pietroid_github_io/components/projects/project_tech_icons.dart'
    as _project_tech_icons;
import 'package:pietroid_github_io/components/projects/projects_list.dart'
    as _projects_list;
import 'package:pietroid_github_io/components/projects/projects_section.dart'
    as _projects_section;
import 'package:pietroid_github_io/components/apps_client_component.dart'
    as _apps_client_component;
import 'package:pietroid_github_io/components/home_footer.dart' as _home_footer;
import 'package:pietroid_github_io/components/site_header.dart' as _site_header;
import 'package:pietroid_github_io/layouts/site_layout.dart' as _site_layout;
import 'package:pietroid_github_io/pages/home_page.dart' as _home_page;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _zoomable_image.ZoomableImage: ClientTarget<_zoomable_image.ZoomableImage>(
      'jaspr_content:zoomable_image',
      params: __zoomable_imageZoomableImage,
    ),
    _apps_client_component.AppsClientComponent:
        ClientTarget<_apps_client_component.AppsClientComponent>(
          'apps_client_component',
        ),
  },
  styles: () => [
    ..._image.Image.styles,
    ..._zoomable_image.ZoomableImage.styles,
    ..._home_footer.HomeFooter.styles,
    ..._site_header.SiteHeader.styles,
    ..._bio.Bio.styles,
    ..._bio_stack.BioStack.styles,
    ..._blog_post_item.BlogPostItem.styles,
    ..._blog_posts_list.BlogPostsList.styles,
    ..._last_posts_section.LastPostsSection.styles,
    ..._education_item.EducationItem.styles,
    ..._education_section.EducationSection.styles,
    ..._experience_item.ExperienceItem.styles,
    ..._experience_list.ExperienceList.styles,
    ..._experience_section.ExperienceSection.styles,
    ..._experience_timeline.ExperienceTimeline.styles,
    ..._project_context.ProjectContext.styles,
    ..._project_image.ProjectImage.styles,
    ..._project_item.ProjectItem.styles,
    ..._project_status.ProjectStatus.styles,
    ..._project_tech_icons.ProjectTechIcons.styles,
    ..._projects_list.ProjectsList.styles,
    ..._projects_section.ProjectsSection.styles,
    ..._site_layout.SiteLayout.styles,
    ..._home_page.HomePage.styles,
  ],
);

Map<String, Object?> __zoomable_imageZoomableImage(
  _zoomable_image.ZoomableImage c,
) => {'src': c.src, 'alt': c.alt, 'caption': c.caption};
