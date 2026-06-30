# pietroid.github.io

This is the repository with the configuration of my personal & development blog (https://pietroid.github.io/).

It is built with [Jaspr](https://jaspr.site/) and the [Jaspr with Github Pages](https://github.com/pietroid/jaspr_github_pages) template, and deployed automatically to GitHub Pages.

## Structure

- `/content/posts:` where posts are written in Markdown format.
- `/content/index.md:` the homepage content.
- `/lib:` Jaspr application code.
- `/web:` static assets and styles.

## How to use it

Make sure you have the [Dart SDK](https://dart.dev/get-dart) installed, then run:

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
```

The generated files will be in `build/jaspr`.

## How it works

The site uses [jaspr_content](https://docs.jaspr.site/content) to render Markdown files from the `content/` directory into static HTML. When a push is made to the `main` branch, a GitHub Action runs `jaspr build` and deploys the output to GitHub Pages.
