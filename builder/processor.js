import { unified } from 'unified';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import rehypeStringify from 'rehype-stringify';
import remarkFrontmatter from 'remark-frontmatter';
import remarkParseFrontmatter from 'remark-parse-frontmatter';
import rehypeParse from 'rehype-parse';
import { visit } from 'unist-util-visit';

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


/// Inserts the links to the posts in the index page.

export async function processIndex(content, allPostsFrontmatter) {
    var processed = await unified()
        .use(rehypeParse, { fragment: false })
        .use(addPostLinks, { allPostsFrontmatter: allPostsFrontmatter })
        .use(rehypeStringify)
        .process(content);

    return String(processed);
}

/// Add links to the posts in the index page.
/// The links will be added to the node with the id 'post-links'.

function addPostLinks(options) {
    const { allPostsFrontmatter } = options;

    return function (tree) {
        // Find the node with the id 'post-links'
        visit(tree, 'element', (node) => {
            if (node.properties && node.properties.id === 'post-links') {
                // Clear existing children
                node.children = [];
                // Add links to each post
                allPostsFrontmatter.forEach(post => {
                    node.children.push({
                        type: 'element',
                        tagName: 'a',
                        properties: {
                            href: `posts/${post.filename}.html`
                        },
                        children: [
                            {
                                type: 'text',
                                value: `${post.date} - ${post.title}`
                            }
                        ]
                    });
                    node.children.push({
                        type: 'element',
                        tagName: 'br',
                        properties: {}
                    });
                    node.children.push({
                        type: 'element',
                        tagName: 'br',
                        properties: {}
                    });
                });
            }
        });
    }
}

/// Parses the scaffold raw content into a HAST tree.

export async function processScaffold(content) {
    var processed = await unified()
        .use(rehypeParse, { fragment: false })
        .parse(content);

    return processed;
}

/// Wraps the content with the scaffold.
function addScaffold(options) {
    const { scaffold } = options;

    return function (tree, file) {
        var contentTree = {};

        /// Move properties from the original tree to contentTree
        Object.assign(contentTree, tree);

        /// Delete all properties from the original tree
        Object.keys(tree).forEach(key => delete tree[key]);

        /// Add the scaffold to the tree
        Object.assign(tree, scaffold);

        // Find the node with the id 'post-content' inside the 
        visit(tree, 'element', (node) => {
            if (node.properties && node.properties.id === 'post-content') {

                /// Adds the contentTree to the whole post tree
                node.children = contentTree.children

                // Adds the title 
                node.children.unshift({
                    type: 'element',
                    tagName: 'h1',
                    properties: {
                        'id': 'title',
                    },
                    children: [
                        {
                            type: 'text',
                            value: file.data.frontmatter.title || 'No title provided'
                        }
                    ]
                });
            }
        })
    }
}
