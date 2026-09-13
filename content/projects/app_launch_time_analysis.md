---
title: "App Launch Time Analysis"
description: "Launch time was a critical user metric for a big banking application. I lead the analysis on both Android and Flutter Layer."
---

![App Launch Time Analysis preview](/images/projects/startuptracing.png)

# App Launch Time Analysis (2025) - Very Good Ventures

My first project at Very Good Ventures, we had a call from the one of the largest banking insitutions in Latin America: to understand how to optimize the App Launch, specially for its Android Users.

## The problem

The time that users taps the App Icon from the time everything is loaded and running is called App Launch or App Startup.
 
In any application, but more importantly in a banking one, where user wants to take actions quickly for day to day purchases and decisions, this time is very critical. 

Specially for clients with low end Android Devices, where resources are scarce and processing is demanding, any % in optimization would improve significantly the user experience.

## The solution

I conducted an Android Launch Analysis in an App that had both stacks mixed: `Kotlin` and `Flutter`. Because of legacy reasons, many of the critical features in this App were still Native. 

At the same time, the `Flutter` App had already lots of core features (Feature Toggle fetching, User Data Initialization, Navigation Configuration), that forced the analysis to be done both ways equally: one in `Flutter` and one in `Native Kotlin`.

For conducting this Analysis I used [perfetto.dev](https://perfetto.dev/) which is a tracing tool for Native Android and [Flutter Dev Tools](https://docs.flutter.dev/tools/devtools) for Flutter. I ran a series of experiments locally with both physical devices and emulators to identify processes timings, and matched with actual function calls in the code. I crossed that with already existing remote prodution tracings from a varied range of devices and conditions.

With that in hand, I gave a list of priorities and recommendations of what needed to be done with each of processes, including caching `RemoteConfig` fetching, removal of `Platform Channels`, optimization of `JSON` loading for language keys, just to cite a couple of examples.