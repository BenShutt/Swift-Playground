# Flow Layout

Logic to calculate the frames in a left-to-right flow layout.

## Installation (SwiftPM)

Add a dependency to your `Package.swift` file or the package list in Xcode:

```swift
dependencies: [
    .package(
        url: "https://github.com/BenShutt/FlowLayout.git",
        branch: "develop"
    )
]
```

Remembering to add the new dependency to your target.

## Entities

### FlowLayoutView

A SwiftUI View that renders its elements in a flow layout

```swift
FlowLayoutView([
    TagView() // ...
], configuration: .init(
    hSpacing: 5,
    vSpacing: 10
))
```

### FlowLayoutBuilder

Responsible for performing the calculations and constructing a `FlowLayout`.
Takes an array of elements that have a size and positions them into rows.
Rows are stacked left-to-right until they can no longer fit on that row.
Elements that overflow are added a new row below.

### FlowLayout

The model built by the `FlowLayoutBuilder`.
Contains all of the elements and their respective frames for layout.

### CollectionViewFlowLayout

A subclass of [UICollectionViewLayout](https://developer.apple.com/documentation/uikit/uicollectionviewlayout) that uses the entities above to draw a flow layout in a collection view.

## Notes

- Multiple types can be achieved with a wrapper, e.g. an enum
- Generics are propagated through so the element can be passed with its respective frame. This may mean the element is stored twice. A workaround would be using a, say, `String` ID 
