import { unified } from 'unified';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import rehypeStringify from 'rehype-stringify';
import remarkFrontmatter from 'remark-frontmatter';
import remarkParseFrontmatter from 'remark-parse-frontmatter';
import rehypeParse from 'rehype-parse';
import { visit } from 'unist-util-visit';

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

export async function processIndex(content, allPostsFrontmatter) {
    var processed = await unified()
        .use(rehypeParse, { fragment: false })
        .use(addPostLinks, { allPostsFrontmatter: allPostsFrontmatter })
        .use(rehypeStringify)
        .process(content);

    return String(processed);
}


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

export async function processScaffold(content) {
    var processed = await unified()
        .use(rehypeParse, { fragment: false })
        .parse(content);

    return processed;
}

function addScaffold(options) {
    const { scaffold } = options;

    return function (tree, file) {
        var contentTree = {};

        // Replace all properties of the existing tree with those from `newTree`
        for (const key of Object.keys(tree)) {
            contentTree[key] = tree[key];
            delete tree[key]
        }

        for (const key of Object.keys(scaffold)) {
            tree[key] = scaffold[key]
        }

        // Find the node with the id 'content' inside the 
        visit(tree, 'element', (node) => {
            if (node.properties && node.properties.id === 'post-content') {
                node.children = contentTree.children

                // Adding title 
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
