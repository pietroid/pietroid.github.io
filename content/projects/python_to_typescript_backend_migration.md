---
title: "Python to Typescript Backend Migration"
description: "Migrating over 20 endpoints to a structured, modern Typescript project, on top of Google Cloud Functions, inspired on Nest.js structure."
---

![Python to Typescript Backend Migration preview](/images/projects/pythontots.png)

# Python to Typescript Backend Migration (2026) - Freelancing

Working since 2025 also as Freelancer, this is one of the Opportunities that I find worth listing as a project. 

I was contracted to solve structural problems in a very early Stage Stealth Startup - a Niche Dating App. It had around 100k Monthly Active Users and had around 4 Tech Employees by the time.

## The problem

The company Backend lacked structure and a pattern - it were mainly coded and maintained by one person - the Tech Founder. 

Whenever the team needed to add more features and in a faster way, it had a series of problems: lack of type structure, lack of understanding if the change affected an unrelated endpoint, lack of deployment process.

## The solution

My call was simple: adopt a modern, widely known and used backend language, with native type support and a tight support from `Google Cloud Functions` - which was the underlying infrastructure by the time.

So I created the new project with `Typescript`, introducing layered clean architecture (`Controller`, `Service` and `Repository`), inspired by `Nest.js` architecture, built on top of `Google Cloud Functions Typescript API` - also fully optimized for AI Agents.

With that the team could migrate some of endpoints and create fully new endpoints - totaling around 20 in a timeframe of 4 months.