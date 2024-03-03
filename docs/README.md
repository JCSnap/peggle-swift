# Design

This app uses the MVVM architecture, generally following this [variation](https://matteomanferdini.com/mvvm-swiftui/).



## Structure

```
peggle/
├── peggle/
│   ├── Views/
│   │   ├── ReusableComponents
│   │   ├── Home
│   │   ├── LevelDesigner
│   │   ├── OtherScreenFolder1
│   │   ├── OtherScreenFolder2
│   │   └── ContentView.swift
│   ├── Models/
│   │   ├── Utilities
│   │   ├── Protocols
│   │   └── DataModels
│   └── ViewModels
├── peggleTests
└── peggleUITests
docs/
├── images
├── plantuml
└── README.md
```

### Views

We want Views to be as loosely coupled as possible. However, there are certain views that will instantiate the view model. We call these type of views "root views". Generally, each screen will have one "root view". For example, the home screen will have its own root view, which contains the home view model; The level designer will have its own root view, which contains one instance of the level designer view model.

The root view will consist of multiple views that make up the screen, which has to deal with user interaction. For example, the `LevelDesignerView` can be made out of a `BoardView`, for users to put the pegs, and an `PaletteView`, for users to select peg type, undo etc. These views will receive an instance of view model from the root view, instead of maintaining their own. Furthermore, these views use the Delegate design pattern so even though they receive the instance of view model, only functions and variables that are relevant are exposed to the views.

The last type of views are the least coupled ones. They deal solely with UI and do not deal with user Interaction at all. This includes the `PegView` (which sole purpose is to render the Peg Image), and `UndoButton`.

The root view of the different screens and the screen specific views will be put in their subfolders respectively. Eg. `LevelDesignerView`, `BoardView` and `PaletteView` will be put under Views/LevelDesigner/ since they all collectively make up the level designer.  
The last type would be put under Views/ReusableComponents. Even though `PegView` can also be found in the level designer, it is not specific to level designer since it does not require any level designer view model to handle level designer specific logic. It is independent of business logic and view models and thus is considered reusable.

### Models

We organize the models into their various folders. Protocols are self-explanatory. DataModels are models that actually represent the game entities rather than business logic. Thus models like `Peg` and `Level` belongs here. Utilities are models that handle business logic rather than game entities, housing models like `PersistenceManager` which deals with persistence, and `Constants`, which houses the different default configurations of the app.

### ViewModels

This folder houses all the view models. Generally, each view model will correspond to one screen.

## Design Philosophy

Here is a entity diagram for the models and view models:

- `I`: Interface, or protocol in swift
- `C`: Class
- `E`: Enum
- `S`: Struct

![Model and ViewModel Entity Diagram](./images/model-view-model-entity-diagram.png)

### View and View Models

![View and ViewModel Entity Diagram](./images/view-view-model-entity-diagram.png)

The view model is the "brain" of the program. It handles translates user actions from the View to logic. It uses the Observable pattern through SwiftUI's inbuilt `Observable` annotation. The root view will "listen" to the view model for changes, and any changes in the variables stored in the view model will notify the view to update.  
Since each view model is in charge of one screen, and each screen is made out of smaller views (think `BoardView` and `PaletteView` in the `LevelDesigner` screen), the view model needs to provide functionalities for these views to interact with. Thus, it has to conform to the delegates of the views under its belt.  
For instance, now that `LevelDesignerVm` conforms to `LevelDesignerPaletteDelegate`, we can be sure that the `selectPegType` function is available in the `PaletteView` when the user selects between the blue and orange peg.  
Another benefit that comes with the Delegate pattern is that we ensure that **only** the functions required in the particular view are being exposed. For example, the `PaletteView` will not have access to the `removePeg` function of the view model, and rightfully so since it is not needed in the `PaletteView`. This prevents unexpected mutation and enforces the single responsibility principle.

### View Model and Models

The view model store and interacts with the models, and views have no direct interaction with the models. For instance, the `LevelDesignerVm` contains a `Board` model. So when pegs are added in the `BoardView`, instead of calling the `addPeg` function of `Board`, the `BoardView` will call the `addPeg` function of `LevelDesignerVm`. Internally, the `LevelDesignerVm` will then call the `addPeg` function of `Board`.  
Another example is how instead of directly storing the pegs, the `BoardView` would request the `LevelDesignerVm` for the pegs, and the View's jobs is to render the pegs.

### Persistence

The `LocalPersistenceManager` is a utility model that deals with persistence. It conforms to `LevelPersistence`, which ensures that it has the necessary functions to handle level persistence like saving levels and loading levels.  
Since `LevelDesignerVm` contains a `LevelPersistence`, we can be sure that functions like `saveLevel` will be available. The implementation details will not be exposed. Currently, we are setting `LocalPersistenceManager` as the default manager which uses JSON for persistence, but we could image that in the future, it is possible to easily swap it with something like `SqlitePersistenceManager` or something, as long as it conforms to `LevelPersistence`. This makes the code extremely modular and not dependant on one particular implementation.

### Other Models

- The `Board` model is an abstraction over the area where the pegs are placed, and contains functions that are relevant to its job scope.
- The `Peg` model is an abstraction over the peg, which contains a `PegType` enum that is easily extendable.
- The `Level` model is an abstraction over the `Board` that is to be saved and loaded. It's basically a `Board`, except it should be identifiable (with a name) since it needs to be saved and loaded.
- The `Validator` is self explanatory. Currently it's function is to check whether the input is valid

### Views

- `ContentView`: The main view of the app. It has no view model as it's purpose is to segment the screens
- `LevelDesignerView`: The root view of the level designer screen. It contains the instance of the view modal, it is a high level view that encapsulates other views that make up the level designer. Thus it will pass the view modal to its child views.
  - `PaletteView`: The view that allows users to be able to select peg types, do actions like `SAVE`, `LOAD` etc.
    - Within the view, it can be further segmented into `PegSelectionView` which consists of the Peg type buttons and the undo button, and `ActionButtonsView` which consists of the `SAVE`, `LOAD`, `RESET`, `START` and text input for level name.
  - `BoardView`: The "canvas" for the pegs to be placed
    - Within the view, it can be further segmented into the `PegInteractiveView` to render the pegs, and `InvisibleLayerView` to capture the taps
  - `LoadLevelView`: The modal popup that shows all the available level when user clicks on the `LOAD` button

