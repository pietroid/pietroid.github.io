---
title: "Map Search Revamp"
description: "Total revamp of the Map search feature, introducing new map interactions, new pins look and feel on top of Google Maps Flutter. Remodeled geographical based backend search."
---

![Map Search Revamp preview](/images/projects/mapoverhaul.png)

# Map Search Revamp (2023)

My drive for detailed user experiences and amazing interface details led me to this project, where we taken a considerable laggy and broken legacy map search experience and totally revamped it.

# The problem

As a proptech, search by map is a core experience for the user who is looking for a new place to buy or to rent. The existing search codebase, besides being increasingly unmaintanable and hard to read, produced a laggy and buggy experience for the user, mainly affecting those with low end `Android` Devices.

# The solution

I lead a series of initiatives:

1. Reconstructed all the logic of the Map Search by migrating from `MVVM + ChangeNotifier` to `Flutter Bloc` + Clean Architecture Pattern, improving significantly the performance and fixing all major bugs in the process.
2. Created a new look and feel for the pins that represent the prices of the houses on the map. Maintained this on Native Side (a fork of `Google Maps Flutter` + custom `Swift` and `Kotlin` code) because of performance constraints.
3. Rethink the Search Fetch logic, talking to Product and Design team to find a balance on when to refetch houses when map moved, how much is the appropriate density based on screen size and number of houses found. Implemented this both on client side and made the necessary adjustments on the backend (`Python` + `Elastic Search` with `Geospatial` logic)
4. Decision and separation of initiatives via series of Feature Toggles (using `Firebase Remote Config`) to make experiments and Phased Rollouts (around 10 experiments were launched in a timeframe of 6 months).

With all experiments compound, we reached a total of 15% in increase of conversion in offers from tenants and buyers who look for houses.