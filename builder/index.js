import fs from 'fs';
import path from 'path';
import { processBlogPost, processScaffold, processIndex } from './processor.js';

/// Create the `compiled` folder
fs.mkdirSync('../compiled', { recursive: true });

/// Move the index.html file to the compiled folder
fs.copyFileSync('../blog/structure/index.html', '../compiled/index.html');

/// Copy the assets folder to the compiled folder
fs.cpSync('../blog/structure/assets', '../compiled/assets', {
    recursive: true
});

/// Copy the styles folder to the compiled folder
fs.cpSync('../blog/structure/styles', '../compiled/styles', {
    recursive: true
});

/// List blog files
var files = fs.readdirSync('../blog/posts');

/// Create the `compiled/posts` folder
fs.mkdirSync('../compiled/posts', { recursive: true });

/// Read, process and write compiled file for each one of the MDX posts

/// First, read the post scaffold
var scaffoldContent = fs.readFileSync('../blog/structure/post_scaffold/index.html', 'utf8');
var processedScaffold = await processScaffold(scaffoldContent);

var allPostsFrontmatter = [];

for (var file of files) {
    /// Read the file content
    var content =
        fs.readFileSync(path.join('../blog/posts', file), 'utf8');

    /// Extract frontmatter from the content
    var { postContent, postFrontmatter } = await processBlogPost(content, processedScaffold);

    postFrontmatter.filename = file.split('.')[0]; // Store the filename without extension

    /// Store the frontmatter for later use in the index
    allPostsFrontmatter.push(postFrontmatter);

    /// Write the processed file to compiled folder
    var filename = file.split('.')[0];
    var renderedFilename = filename + '.html';
    fs.writeFileSync(path.join('../compiled/posts', renderedFilename), postContent);
}

/// Then, modify the index.html file to include links to the posts
var indexFilePath = '../compiled/index.html';
var indexContent = fs.readFileSync(indexFilePath, 'utf8');

var processedIndexContent = await processIndex(indexContent, allPostsFrontmatter);

/// Write the processed index file to compiled folder
fs.writeFileSync(indexFilePath, processedIndexContent);