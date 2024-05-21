## Movies-TCA

This project explores the concepts behind "The Composable Architecture" (TCA) using The Movie Database (TMDB) API. The focus is on building a modular and predictable application architecture for iOS development.

### The Composable Architecture (TCA)

[The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) is a unidirectional and state management framework for iOS development. It emphasizes building applications from small, reusable, and testable pieces. TCA applications are built around a central state type, an action type that describes user interactions and events, and a reducer function that updates the state based on dispatched actions. This architecture promotes modularity, maintainability, and easier testing of your application logic.

**This project is constantly updated to stay compatible with the latest releases of TCA.** 

### Getting Started

**Prerequisites:**

* macOS with Xcode 14 or later
* Basic understanding of Swift development
* Familiarity with The Composable Architecture framework

**Running the App:**

1. Clone the repository using Git:
   
   ```bash
   git clone https://github.com/telemtobi/Movies-TCA.git
   ```

3. Open the `Movies-TCA.xcodeproj` file in Xcode.

4. (Optional) Configure your TMDB API access token in `Release.xcconfig`.<br/>
   You can get an API access token by creating a free account on [TMDB]([https://www.themoviedb.org/account/signup](https://developer.themoviedb.org/reference/intro/getting-started)).

5. Build and run the app on your desired iOS device or simulator.

### Project Structure

The project is organized with a focus on modularity and separation of concerns:

* **App:** Contains the main application entry point (`MoviesApp.swift`).
* **Models:** Contains data models representing movie information.
* **Navigators:** Dedicated TCA features for handling navigation actions. This keeps each module's features isolated from navigation concerns.
* **Modules:** Houses individual TCA features representing specific parts of the application. Each module encapsulates its own state, actions, and reducer. 
* **Networking:** Handles network requests and API interactions with TMDB. Consider referring to the companion package, [Flux](https://github.com/TelemTobi/Flux), for more details on networking implementation and usage.
* **Support:** Configuration files, localization resources, and other supporting assets.
* **Utility:** Contains constants, custom dependencies, extensions, modifiers, protocols, and UI component styles. 
* **Views:** Reusable SwiftUI views that represent the application's user interface.

**Note:** This project is intended for educational purposes and demonstrates the usage of TCA. It might not be feature-complete and may require further development for a production-ready application.
