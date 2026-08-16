# Revamp Site

I want to revamp the blog to be more attractive for recruiters and clients.

## Pages

There should be three pages, with a app bar at the top where I can navigate in each one of them: 

- Home (About Me)
- Projects
- Blog

### Home

- Should contain a circular photo at the center (my photo), and a text box below with a brief description of who I am.
- Should contain a list of previous experiences

#### Previous experiences

Take just the date of each one and the role with the link to the place. You can make a simple card component with a image of the left of the place.

### Senior Mobile Engineer · [Very Good Ventures](https://verygood.ventures/) *Jan 2025 — Present*

- **Stack:** Flutter, Native Android & iOS, Scala (Backend)
- Led and delivered multiple short-term consulting projects for high-profile clients in fintech and entertainment/cruise industries.
- Diagnosed Android Native startup performance issues, planned native-to-Flutter migration, and shipped end-to-end features across Flutter, BFF & Scala backend.

### Fullstack Engineer · Freelancing *Jan 2025 — Present*

- **Stack:** Flutter, Node.js/TypeScript, Firebase Cloud Functions, Firestore, PostgreSQL
- Core contributor to a relationship/social network App over 8 months.
- Automated the App release pipeline, built a custom push notification campaign system (Amplitude + Databricks + FCM), and architected a new TypeScript + Node.js + Firebase Cloud Functions backend to replace legacy Python backend.

### Mobile Engineer · [QuintoAndar](https://www.linkedin.com/company/grupo-quintoandar/) *Nov 2021 — Dec 2024*

- **Stack:** Flutter, Google Maps SDK (Native iOS & Android), FCM (Native iOS), Python, Node.js
- Lead Engineer on the team building key native experiences at LatAm's largest proptech — delivered a personalized home feed, highly customized map search UI, and an internal chat replacing WhatsApp.
- Go-to engineer for backend fixes and changes across Python and Node.js services because no dedicated backend engineer was available in the team.

### Fullstack Software Developer · [RaiaDrogasil](https://en.wikipedia.org/wiki/RD_S.A.) *Jan 2020 — Nov 2021*

- **Stack:** Node.js, React Native, TypeScript, MongoDB
- Built coupons & loyalty features at Brazil's largest retail health company. Served as Scrum Master for a short period, helping to ship a new product to market in 8 months.

### Tech Founder · Indigo Labs *Jan 2019 — Jan 2020*

- **Stack:** Node.js, MySQL, AWS, Android (Java) — sole owner of architecture & implementation.
- Built a psychiatric treatment tracking app (daily mood questionnaires, educational content, appointment notifications) used by patients and doctors.

### Intern & Research · Various *Jan 2018 — Jan 2020*

- University lab: built a remote EEG device, blood sample analyzer (Raspberry Pi + Computer Vision), and needle counter with IR sensors.
- Proptech startup intern: web-crawled real estate data with Python, built a Raspberry Pi pedestrian-flow detector.

## Education

### Mechatronics Engineering (B.Eng.) · [Universidade de São Paulo](https://www5.usp.br/english/institutional/) *2014 — 2019*

- Selected as Data Structures & Algorithms class monitor (top-grade students only); lectured a pre-final test class with didatic and fun story-telling for students to understand complex concepts. Received positive feedbacks from students and from teacher.

### Projects

- Should contain a text above where you can put something as "nice projects etc"
- Each project should be a card with a image and a title and description, status, date, and a github link (if suitable). When clicking on card should go to the project page.

Just leave one project now:

Scribe

An app to help me on my studies
github https://github.com/pietroid/scribe
status: in progress
started: july/2026
placeholder image: invent something just for placeholder
link to the page: create a new page just for this project and I will fill exactly the details.

### Blog

It's exactly the same thing we have currently. 

Just make the presentation on the home page about myself (pietroid, etc) a first blog post because its more personal.

- Also when going to the blog page you should show the list of the posts
- Figure out how to show dates and put some placeholder date to it so we can have this on the page. (just fill in the dates with whatever you invent, I will put that later)

## General considerations

- Stick to MD wherever possible.
- Just create custom components when needed. Even so, prefer to create them and embbed on a MD like <Object>
- Prefer to use custom jaspr objects instead of inventing new MD parsers.
- Stick to the style as much possible but feel free to create new style definitions if they are not enough for what you need. Just make the extra explicit before you start creating.
- Add a Agents.MD or something like this so OpenCode can be perfectly aligned with those instructions in the next sessions.