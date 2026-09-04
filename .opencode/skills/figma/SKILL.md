---
name: figma
description: Use when the user wants to implement a design from a Figma file, prototype, or share link. Triggers for "Figma", "figma", "implement this design", or when a Figma URL is pasted.
---

# Figma-to-code workflow

This project has a Figma MCP server configured (`@tmegit/figma-developer-mcp`). It exposes tools that fetch Figma files and convert nodes into CSS-aligned, LLM-optimized data optimized for UI implementation.

## Before reading Figma

1. The Figma file must be accessible with the configured personal access token (`FIGMA_API_KEY`).
2. Extract the **file key** from the Figma URL:
   - `https://www.figma.com/design/ABC123/...` → file key is `ABC123`
   - `https://www.figma.com/file/ABC123/...` → file key is `ABC123`
   - Frame/node URLs contain `?node-id=123%3A456` — note the node ID too.

## Tool usage

Use the Figma MCP tools in this order:

1. **Get the file metadata and top-level frames**
   - Tool: `get_file`
   - Args: `{ "fileKey": "ABC123" }`
   - This returns the document tree. Identify the page/frame you want to implement.

2. **Get the specific node(s)**
   - Tool: `get_file_nodes`
   - Args: `{ "fileKey": "ABC123", "nodeIds": ["123:456"] }`
   - Returns CSS-aligned nodes with inline styles (`backgroundColor`, `flexDirection`, `fontSize`, etc.).

3. **Export images / icons**
   - Tool: `get_image`
   - Args: `{ "fileKey": "ABC123", "ids": ["123:456"], "format": "png" }`
   - Save exported assets to `web/images/` and reference them in components.

## Implementation rules for this project

This site is built with **Jaspr** (Dart) in static mode. Follow the conventions in `AGENTS.md`:

- Use `lib/constants/site_palette.dart` and `lib/constants/site_styles.dart` for colors/typography; do not hardcode values.
- Prefer Markdown content in `content/`. Only create custom Jaspr components when Markdown cannot express the layout.
- Component/layout styles should be `@css` rules in the owning `.dart` file, not in `web/styles.css`.
- Keep the home page (`/`) implementation in `lib/pages/home_page.dart`.
- For new pages, use `SiteLayout` in `lib/layouts/site_layout.dart` unless there is a strong reason not to.

## Mapping Figma to Jaspr

- Frames with Auto Layout → Jaspr `div`/`Flex` with `display: Display.flex`, `flexDirection`, `justifyContent`, `alignItems`, `gap`.
- Fixed-size frames → set explicit `width`/`height`.
- Text layers → use the typography stack from `site_styles.dart` (`SiteStyles.bodyFont`, `SiteStyles.headingFont`).
- Colors → map to `SitePalette` values when close; add new palette constants only when needed and call it out.
- Images → export from Figma, place in `web/images/`, reference in components.
- Buttons / cards → reuse existing components like `ProjectCard` when the design matches; otherwise create a new component in `lib/components/`.

## Workflow

1. Ask the user for the Figma link (or extract it from their message).
2. Fetch the file and relevant node(s).
3. Summarize the design structure, colors, typography, and assets needed.
4. Ask the user which page/component they want implemented, or propose one.
5. Implement incrementally: structure → styles → assets → content.
6. Run `jaspr build` to verify the static build passes.
