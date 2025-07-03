import { unified } from 'unified';
import rehypeParse from 'rehype-parse';
import { visit } from 'unist-util-visit';

/// Wraps the content with the scaffold.
export function addScaffold(options) {
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

/// Parses the scaffold raw content into a HAST tree.
export async function processScaffold(content) {
    var processed = await unified()
        .use(rehypeParse, { fragment: false })
        .parse(content);

    return processed;
}
