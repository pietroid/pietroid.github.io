---
title: "I migrated my Blog publishing tool to a Dart Web Framework - here's Why"
date: 07-03-2025
---

Welcome back! My first ever post in this blog was how [I created my own blogging tool](posts/creating_my_blog) from scracth with JS, a MDX parser, and how I used Github pages to publish it.

And after more than a year, I'm again reintroducing a new blogging tool to this site 😂

But now for a good reason. I was researching how I could publish my Flutter work to the world, and then by my ecosystem, I gravitated naturally to Jaspr - It's a native web framework in Dart. What?
<Image src="images/jaspr.png" width="0.2" caption="I never thought I would see Dart for Web 🤔"/>

Let me explain, while Flutter Web is a reality and works good, Jaspr comes to solve the other part: how would you do web development in Dart?

Well but the question would be first, why using Jaspr if I could use any other mainstream Javascript/Typescript solution (React, Angular, Vue, Svelte, etc.)?

## Why I wanted to explore Jaspr

Jaspr is becoming increasingly popular to the Flutter community, mainly after the migration of [Flutter Docs to Jaspr announcement](https://blog.flutter.dev/we-rebuilt-flutters-websites-with-dart-and-jaspr-317c00e8b400). So I wanted to give it a try.

Also, I figured out three hypotheses I wanted to verify:

1. Coming from the same community of Dart & Flutter the Jaspr tools and SDK should be as fast, easy and intuitive.
2. It has a first class support for Flutter Widgets, so we can embedded Flutter Web and integrate it to a web page very easily.
3. It has first class support for mdx content, for blog posts and documentation, so I don't need to worry about how to parse and render markdown content.

## Final result

Well, what you are just seeing is the final result.
