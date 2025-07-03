import fs from 'fs';
import path from 'path';
import { processBlogPost, processHomePage } from './processor/processor.js';
import { processScaffold } from './processor/post_scaffold.js';

/// This section is responsible for setting up the /compiled environment for the blog.
/// Create the `compiled` folder
fs.mkdirSync('../compiled', { recursive: true });

/// Move the home page (index.html) to the compiled folder
fs.copyFileSync('../blog/structure/index.html', '../compiled/index.html');

/// Copy the assets folder to the compiled folder
fs.cpSync('../blog/structure/assets', '../compiled/assets', {
    recursive: true
});

/// Copy the styles folder to the compiled folder
fs.cpSync('../blog/structure/styles', '../compiled/styles', {
    recursive: true
});


/// This section is responsible for processing the actual MDX posts and moving them to the /compiled folder.
/// List MDX blog files
var files = fs.readdirSync('../blog/posts');

/// Create the `compiled/posts` folder
fs.mkdirSync('../compiled/posts', { recursive: true });

/// Read, process and write compiled file for each one of the MDX posts
/// First, read the post scaffold, which is the template for each post
var scaffoldContent = fs.readFileSync('../blog/structure/post_scaffold/index.html', 'utf8');
var processedScaffold = await processScaffold(scaffoldContent);

/// This is a list that will be used to store all the titles, dates and other informations from the posts to be used in a later stage.
var allPostsFrontmatter = [];

/// Loop through each MDX file and process it
for (var file of files) {
    /// Read the file content
    var content =
        fs.readFileSync(path.join('../blog/posts', file), 'utf8');

    /// Extract frontmatter and content from the MDX file
    var { postContent, postFrontmatter } = await processBlogPost(content, processedScaffold);

    /// Attach the filename to the object as well
    postFrontmatter.filename = file.split('.')[0];

    /// Store the frontmatter for later use in the index
    allPostsFrontmatter.push(postFrontmatter);

    /// Write the processed file to compiled folder
    var filename = file.split('.')[0];
    var renderedFilename = filename + '.html';
    fs.writeFileSync(path.join('../compiled/posts', renderedFilename), postContent);
}


/// This section is responsible for modifying the home page (index.html) to include links to the posts.
/// Reads the index file
var indexFilePath = '../compiled/index.html';
var indexContent = fs.readFileSync(indexFilePath, 'utf8');

/// Process the home page file to include links to all posts. Here the `allPostsFrontmatter` is used to generate the list of posts.
var processedIndexContent = await processHomePage(indexContent, allPostsFrontmatter);

/// Re-write the processed index file to the `/compiled` folder
fs.writeFileSync(indexFilePath, processedIndexContent);