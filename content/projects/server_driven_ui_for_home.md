---
title: "Server-Driven UI for Home"
description: "Established the foundations for server-driven UI experience on the frontend layer, integrating JSON payloads to our Design System."
---

![Server-Driven UI for Home preview](/images/projects/sduihome.png)

# Server-Driven UI for Home (2024) - QuintoAndar

This is what can be done with a mature Design System when it meets the needs of a highly flexibe Home Page.

# The problem

Having multipe types of possible experiences for multiple types of users (Tenants, Owners, Buyers, Sellers), the QuintoAndar App needed a more tailored home considering which point of the journey the user was in. 

The default home page was always a Search one, which for a lot of users didn't really made sense and made them have more friction to really understand what they needed to do.

# The solution

Our team chose to provide a list of cards with actionables. It could be a card saying about a visit and a call to action to confirm it, or a card saying about your upcoming bill. The simplification here is that for each theme you have, you have a very clear action.

Because of so many options, we decided to render content dynamically: based on each type of component coming from the Backend, the Frontend would know exactly what to render, with which information.

I created all the abstractions for parsing the `JSON` payload from the Backend, which included both dynamic content (title, subtitle), but also pre-defined actions. It also considered versioning both in the folder structure and while fetching the `Remote Config`.