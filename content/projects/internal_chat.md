---
title: "Internal Chat"
description: "Replacing generic WhatsApp for support with an internal chat system inside the App using Twilio SDK and custom backend."
---

![Internal Chat preview](/images/projects/internalchat.png)

# Internal Chat (2022) - QuintoAndar

After a full year coding with Typescript I had the opportunity to work with Flutter in another company. For many reasons that made sense in my career, I put the bet that Flutter was the future for Cross Platform Mobile Development.

# The problem

QuintoAndar is a Proptech, so the customer support and the chat between tenants and owners ocurred mostly in a WhatsApp business number. 

Besides all the operational costs that the company had to spend with Meta, a WhatsApp experience was not the best, because it's not a dedicated channel where you can control everything.

# The solution

An internal chat built inside the Flutter App, on top of `Twilio SDK`. 

In this project I was responsible for maintaing a Flutter Community Plugin, doing the integration between `Flutter` and the `Native Twilio SDK`, so I had to use extensively `Platform Channels` and integrate to `Swift` and `Kotlin` native Twilio SDK.

The solution was launched succesfully and helped the company to save $1M in WhatsApp costs per year.