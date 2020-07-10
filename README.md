# RestImageRender

This project is to demonstrate Image rendering in a collection view without using storyboards. The project make use to RxSwift and Alamofire to fetch screen data from remote and forward it to screen class for rendering in collection view

# Key Points
1. Code Architecture - MVVM + Rx. (View Controller is driven by a view model object which maintains entire app’s business logic and their binding is achieved using RxSwift)  
2. Minimum iOS version supported: iOS 11.1
3. Supports iPhone and iPad.
4. Supports Portrait and Landscape orientation
5. Third party libraries are installed using Cocoapods. Below are the list of all libraries used
- RxSwift, Rxcocoa - for message passing and managing asynchronous calls using reactive programming paradigm
- Swinject - All major dependencies in the entire app are safely injected using this library.
- Alamofire - Network available check and network request are done using this library
- SwiftLint - to ensure project code standards and code style according to swift style guide

6. Design patterns used:
 - Coordinator - to manage screen navigations and inject view model dependency into view controller. Before injecting the view model, the view model is safely configured with its injected dependencies. It is achieved using the Swinject framework. AppCoordinator is initialise by AppDelegate class, which is the main coordinator and hold app window, spawns other screen coordinator
- Inner Factory - used for initialising Error objects (check RIRError)
- Strategy - To dynamically inject a specific logic (strategy object) which allow app to look for fact item image from local cache or from remote url
- ViewData - Each fact item model is kept abstracted using a viewData class. View model is responsible for creating viewData linked with each fact item (cell), by injecting a specific fact item model into view data class. View data helps the cell to safely display formatted data of the model.
- Partial Facade - Image downloader class which is used to allow the view data class to retrieve its image data either from local cache or remote url.
- DI Container Pattern - to add modularity to the code as per IOC principle, any higher modele is not directly dependent on lower module. This is acheived by Swinject Assembly Containers.
7. No storyboard is used to add a view controller and its subviews into the UI. View controllers and subviews are added programmatically into UI. Each subview and collection cells are layout using visual format constraints.
8. Reactive Observables and Drivers of RxSwift and RxCocoa drive the UI visibility and rendering. If no data is received from a remote url (may be due to network issue), the screen will display a message “No Facts found” which is also driven by observables. Further screen title and loader animations are also driven by reactive observables of view model
9. Profiling of app revealed apps are using less than 20MB memory in  simulators.
10. Localisation support, currently only English language localised file is installed. These files can be further used as a central part where all hardcoded strings are aggregated
11. Support for multiple environments using xcconfig configuration files. Currently, 3 configurations are installed: Debug, Staging and Release. Feel free to change the configurations in the edit scheme “RUN”. You can observe the changes by checking the app display name in the device home screen. Currently the master branch is configured to run in the debug environment and the app name displayed will be “RIR Dev”.
