---
title: "I migrated my Blog publishing tool to a Dart Web Framework - here's Why"
date: 07-03-2025
---

Welcome back! My first ever post in this blog was how [I created my own blogging tool](posts/creating_my_blog) from scracth with JS, a MDX parser, and how I used Github pages to publish it.

And after more than a year, I'm again reintroducing a new blogging tool to this site 😂

But now for a good reason. I was researching how I could publish my Flutter work to the world, and then by my ecosystem, I gravitated naturally to Jaspr - It's a native web framework in Dart. What?

<Image src="images/jaspr.png" caption="I never thought I would see Dart for Web 🤔"/>

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

Four completely different Flutter Apps, completely different contexts, all running here, in real time, as you would run in your own device!

<Apps/>

## Was it worth it?

I should write a full post about this, but in a couple of words I would say "Totally Worth it!". Some highlights:

- Jaspr can be initiated as a simple MDX blog in a matter of minutes, using the https://docs.jaspr.site/content. Also, there is one easy command `jaspr serve` that makes your site works locally in the famous http://localhost:8080/. No other configs needed.
- Embedding Flutter requires only [three things](https://docs.jaspr.site/going_further/flutter_embedding). There are in fact some other tweaks I needed to do, but after figuring out it worked pretty well.
- Publishing to Github pPges was also a bit tricky mainly because of some things I needed to mind about base paths and assets, for that I made a [working template](https://github.com/pietroid/jaspr_github_pages).
- The weakest point: Some details are still missing in the documentation, and there isn't much reference on the community.
- The strongest point: Integrated Flutter development with a Web Page. Once you create your own Jaspr Component, it can be called simply with a tag <NameYourApp/> and you can edit all the contents of your Flutter App in the same project, meaning hot reload, Dart Analyzer, etc. Also all constants, variables and even state on the Jaspr Website structure can be used inside the Flutter App transparently and vice-versa.

The final result can be seen at https://github.com/pietroid/pietroid.github.io.