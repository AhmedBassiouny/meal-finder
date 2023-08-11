## Meal Finder App

### Overview

**Meal Finder** is a mobile app designed for users walking around Helsinki's city center, aiding them in discovering places to eat based on their current location. The app integrates with the Wolt API to fetch and display a list of venues. As a user moves, the app refreshes every 10 seconds to show the venues nearest to their updated location. Additionally, users can mark venues as their favorites, with the app remembering and displaying these preferences on subsequent views.

### Key Features

- **Dynamic Location Tracking**: The app retrieves the user's current location from a given list of coordinates, updating every 10 seconds.
- **Wolt API Integration**: Uses the Wolt API endpoint to fetch venues based on the user's location. Displays up to 15 venues from the server response.
- **Persistent Favoriting**: The app remembers favorite venues and will reflect the favorite state if the venue reappears in future server responses.

## Configuring development environment
* Right after you have cloned the repository, IDE may complain about some unsatisfied dependencies. Fetch all the dependencies by running the following command: ```flutter pub get```
* Project uses several libraries that help us by generating some boilerplate code. To run the code generation, execute this command: ```flutter pub run build_runner build```

---

## 📂 Folder Structure Overview

The **Meal Finder** app adheres to a modular and clean architecture approach, ensuring scalability, maintainability, and a clear separation of concerns. Here's a high-level overview:

### `lib` directory
- 📁 **`application`**: Our domain layer harboring the primary business logic.
    - 📁 **`model`**: Houses essential domain models, like `restaurant.dart`.
    - 📁 **`restaurants`**: Focused on the logic related to restaurant data with components such as BLoC, events, states, and providers.

- 📁 **`infrastructure`**: This data layer handles sourcing, storage, and data transformations.
    - 📁 **Repositories**: Repositories like `favorite`, `geo_location`, and `item` encapsulate specific data operations.
    - 📁 **`model`**: Contains foundational data models like `location.dart` and `wolt_response.dart`.
    - 📁 **`services`**: Dives into:
        - 📁 **`api`**: Manages external service interactions.
        - 📁 **`local_location_service`**: Deals with local geolocation ops.
        - 📁 **`storage`**: Ensures persistent data operations.

- 📄 **`main.dart`**: App's starting point.

- 📁 **`presentation`**: The presentation layer.
    - 📁 **`app`**: Foundational widgets for the app.
    - 📁 **`restaurants`**: Widgets related to restaurant displays.
    - 📁 **`widgets`**: Collection of reusable UI components.

- 📁 **`theme`**: Centralizes visual identity elements.

- 📁 **`utils`**: Houses utility classes like error handlers and log reporters.

---
