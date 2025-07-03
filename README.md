# Pietroid github.io

This is the repository with the configuration of my personal & development blog (https://pietroid.github.io/). 

## Structure

The blog has the following structure:

```
- /blog/posts: where posts are written in MDX format
- /blog/structure: where the HTML pages of the posts and the home page and the CSS are defined.
- /builder: where it compiles the blog posts from MDX to actual HTML pages for the github actions to deploy to github pages.
```

## How to use it

First, go to the `/builder` folder:

```
cd builder
```

Next, install all the dependencies

```
npm install
```

Then run the site locally:

```
npm run dev
```

Congratulations! It should work on `localhost:3000`!

## How it works

The builder is very simple, you can take a look at the index.js and see how it compiles the files to HTML. But I have an article explaining about this on my blog: 

[How I created my blog from scratch with Node.js, MDX Remark and Github Pages](posts/creating_my_blog.html)