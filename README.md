# Remindify

Get notified on your tasks. This is a flutter+firebase sample project that shows how to use bloc architecture and unit/widget/driver testing in a maintainable and efficient way.

## Project structure (lib)
### Entities
Data structures and logic that modify that data go here. A good entity knows how to marshal and unmarshal itself. It is handy to keep collection keys as static members of each entity.

### Views
Contains screens of the app. A screen is a top level widget that is composed using feature-specific widgets. It is usually where you place your Scaffold widget. Views should not have any presentation logic.

### Features
This directory contains all the use-cases of your app. Each feature has its own directory and inside it you place its widgets and blocs.

#### Feature/widgets
Here you place all the widgets that implement your feature. There might be some widgets that are shared across different features. Those can be placed in a "core" or "common" package, but be careful on what you put there as this directory could grow too much.

#### Feature/bloc
Contains blocs to manage the feature widgets.

### Dependency Injection
This project uses GetIt as dependency injection. This is very useful for testing as you can replace your services with mocks to test what matters. The key place where dependencies should be injected is in cubits.

### Interfaces
To properly do DI, all services and repositories (data access) must be abstract. This is extremely important to allow changing backend implementations without impacting the rest of the app.

### Firebase
All firebase implementations go here. The reason to keep firebase in a directory of its own is because you will most likely want to get rid of it as soon as your app scales up.

### Services
Classes that use third-party packages, API wrappers and everything that provides functionality to the app is placed here.

### Util
Handy classes used across the project.


## Good practices

### Bloc architecture
Your widgets should not have any presentation logic. All communication and logic go in blocs that will emit a stream of states that widgets consume.
Bloc is a great state management package but it is dangerous!! :skull: If not used properly, you will quickly find yourself in a war field of events firing from all places against you (PTSD guaranteed).
To avoid losing your soul and mind, I strongly encourage the use of cubits rather than blocs. Cubits only emit a stream of events from the bloc to the widgets, and take requests using functions. That makes events management 50% easier since we eliminated the incoming events. There is a catch tho: you lose event traceability (which sounds cool but then nobody actually uses it).
Cubits are also easier to test, which is nice considering that testing event-driven architectures takes time.

### The Result monad
[Burritos]{https://emorehouse.wescreates.wesleyan.edu/silliness/burrito_monads.pdf} are great! The result monad enforces error management by wrapping a result in a class that takes two required callbacks: onSuccess and onError. By making those required, developers have no other choice than handle those errors. This functional programming feature is suitable when calling any outsider (API, Firestore, etc) or when performing risky operations (compressing an image or accessing the filesystem). This wrapper will prevent the app from exploding and will keep try/catch structures well organized.

### How to do bloc, widget, and integration tests
This project contains an example of how to do it taking advantage of the abstractions. Uses Mocktail for mocks.