import {unified} from 'unified';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import rehypeStringify from 'rehype-stringify';
import {visit} from 'unist-util-visit'

export async function processBlogPost (content) {
    var processed = await unified()
    .use(remarkParse)
    .use(remarkRehype)
    .use(addHeaderAndFooter)
    .use(rehypeStringify)
    .process(content);
    return String(processed);
}

function addHeaderAndFooter(){
    return function (tree) {
        tree.children.unshift({
            type: 'element',
            tagName: 'header',
            children: [
                {
                    type: 'text',
                    value: 'This is the header'
                }
            ]
        });
        tree.children.push({
            type: 'element',
            tagName: 'footer',
            children: [
                {
                    type: 'text',
                    value: 'This is the footer'
                }
            ]
        });
    }
}