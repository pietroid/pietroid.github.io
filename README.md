# pietroid.github.io

This is the repository with the configuration of my personal & development blog (https://pietroid.github.io/).

It is built with [Jaspr](https://jaspr.site/) and the [Jaspr with Github Pages](https://github.com/pietroid/jaspr_github_pages) template, and deployed automatically to GitHub Pages.

The site also embeds Flutter widgets (the apps grid demo) via [jaspr_flutter_embed](https://pub.dev/packages/jaspr_flutter_embed).

## Structure

- `/content/index.md:` the homepage (About me: 2×2 grid with bio, experience & education timeline, projects and blog posts).
- `/content/projects.md` + `/content/projects/:` the projects page and one page per project.
- `/content/blog.md` + `/content/posts/:` the blog index and the blog posts in Markdown format.
- `/lib:` Jaspr application code — the site layout (top app bar), the custom Markdown components (`<HomeGrid/>`, `<ProjectCard/>`, `<BlogIndex/>`) and the embedded Flutter apps grid component.
- `/web:` static assets and styles.
- `/assets:` Flutter assets.

See `AGENTS.md` for detailed conventions (how to add posts, projects, experiences, and styling rules).

## How to use it

Make sure you have the [Dart SDK](https://dart.dev/get-dart) and [Flutter](https://docs.flutter.dev/get-started/install) installed, then run:

```
dart pub global activate jaspr_cli
```

To run the site locally:

```
jaspr serve
```

The site should be available on `localhost:8080` (or the port printed in the console).

To build the static site:

```
jaspr build
cp build/flutter/main.dart.js build/jaspr/main.dart.js
```

The generated files will be in `build/jaspr`. The `cp` step is needed because `jaspr_cli` currently doesn't copy the Flutter entrypoint into the static output directory.

## How it works

The site uses [jaspr_content](https://docs.jaspr.site/content) to render Markdown files from the `content/` directory into static HTML. The `/posts/jaspr_announcement` page uses a custom `<Apps>` component that embeds a grid of Flutter widgets on the client.

When a push is made to the `main` branch, a GitHub Action runs `jaspr build`, copies the Flutter entrypoint, and deploys the output to GitHub Pages.
