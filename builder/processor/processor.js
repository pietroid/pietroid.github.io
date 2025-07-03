import { unified } from 'unified';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import rehypeStringify from 'rehype-stringify';
import remarkFrontmatter from 'remark-frontmatter';
import remarkParseFrontmatter from 'remark-parse-frontmatter';
import rehypeParse from 'rehype-parse';
import { addScaffold } from './post_scaffold.js';
import { addPostLinks } from './home_page.js';

/// Transforms each blog post (as MDX) into HTML.
/// Scaffold is a HTML HAST tree that will be used to wrap the content of the post.

export async function processBlogPost(content, scaffold) {
    var processed = await unified()
        .use(remarkParse)
        .use(remarkFrontmatter, ['yaml'])
        .use(remarkParseFrontmatter)
        .use(remarkRehype)
        .use(addScaffold, { scaffold: scaffold })
        .use(rehypeStringify)
        .process(content);

    return { postContent: String(processed), postFrontmatter: processed.data.frontmatter };
}

/// Inserts the links to the posts in the home page.
export async function processHomePage(content, allPostsFrontmatter) {
    var processed = await unified()
        .use(rehypeParse, { fragment: false })
        .use(addPostLinks, { allPostsFrontmatter: allPostsFrontmatter })
        .use(rehypeStringify)
        .process(content);

    return String(processed);
}
