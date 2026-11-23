---
title: "Lunna"
description: "Agentic organization for women entrepreneurs. In beta."
---

![Lunna](/images/projects/lunna.png)

# Lunna (2026) - Personal project, in beta

**Try it:** [lunna.pietroteruya.dev](https://lunna.pietroteruya.dev). The landing page has the real app running on a sample day: tap, drag and ask.

## The problem

Women who run their own business juggle client deliveries, deadlines, routines and family in one day that never fits. Calendars and to-do apps store all of it, but the work of fitting it together is still theirs.

## The product

Lunna is a calendar you talk to. You write or say what you need, and an AI agent reads your day, builds a plan and waits for your yes before changing anything.

- **The day as a queue:** each thing has its time; when something runs late, the rest of the day moves with it.
- **Deliveries and goals:** what you owe a client, with a deadline and a value, becomes tasks on the same day, and the month's goal shows the hours your deliveries need against the hours your calendar has free.
- **Routines, reminders and voice:** blocks that come back every day, nudges at the start and end of each block, and the microphone to ask out loud.

## What I built

I took Lunna from idea to beta by myself, end to end:

- **Product vision and design system:** one consistent look, specs written before each feature.
- **Flutter app** for iOS, Android and web (BLoC, go_router), including an iOS Live Activity in SwiftUI for the running block.
- **NestJS backend** in TypeScript with Postgres (Drizzle), Better Auth with Google sign-in, and product analytics with PostHog.
- **The agent:** an LLM with tools over the calendar, tasks and deliveries, that answers with a plan the user can see and apply.
- **Delivery:** an agentic pipeline where each feature request becomes a planned, mocked-up and built pull request, deployed as containers to a self-hosted server.
