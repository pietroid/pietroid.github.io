import fs from 'fs';
import path from 'path';
import { processBlogPost } from './processor.js';

/// List blog files
var files = fs.readdirSync('../blog/posts');

/// Create the `compiled/posts` folder
fs.mkdirSync('../compiled/posts', { recursive: true });

/// Read, process and write compiled file for each one of the MDX posts
for (var file of files){
    /// Read the file content
    var content =
            fs.readFileSync(path.join('../blog/posts', file), 'utf8');

    /// Process the content        
    var processedContent = await processBlogPost(content);

    /// Write the processed file to compiled folder
    var filename = file.split('.')[0];
    var renderedFilename = filename + '.html';
    fs.writeFileSync(path.join('../compiled/posts', renderedFilename), processedContent);       
}


