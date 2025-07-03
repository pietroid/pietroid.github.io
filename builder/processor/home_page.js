import { visit } from 'unist-util-visit';

/// Add links to the posts in the home page.
/// The links will be added to the node with the id 'post-links'.
export function addPostLinks(options) {
    /// Gets all the posts frontmatter, which contains the title and date of each post.
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