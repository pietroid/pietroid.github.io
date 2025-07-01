import fs from 'fs';
import path from 'path';
import { processBlogPost, processScaffold } from './processor.js';

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

for (var file of files) {
    /// Read the file content
    var content =
        fs.readFileSync(path.join('../blog/posts', file), 'utf8');

    /// Process the content        
    var processedContent = await processBlogPost(content, processedScaffold);

    /// Write the processed file to compiled folder
    var filename = file.split('.')[0];
    var renderedFilename = filename + '.html';
    fs.writeFileSync(path.join('../compiled/posts', renderedFilename), processedContent);
}


