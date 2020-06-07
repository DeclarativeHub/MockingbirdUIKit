#  MockingbirdUIKit


Mockingbird is a UIKit renderer for platform independent [Mockingbird](https://github.com/DeclarativeHub/Mockingbird) DSL. The goal of this project is to provide a SwiftUI-like UI framework for older iOS versions starting from iOS 9.
## Example

`MockingbirdUIKit` is just like `SwiftUI` for UIKit except that the body of your views return `SomeView` instead of `some View` to enable pre-iOS 13 compatibility.

```swift
struct MyView: View {

    @State var counter: Int = 0

    var body: SomeView {
        VStack(spacing: 20) {
            Text("\(counter)")
                .fontWeight(.heavy)
                .padding(20)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
            HStack {
                Button("Decrease") { self.counter -= 1}
                Button("Increase") { self.counter += 1}
            }
        }
    }
}

window.rootViewController = HostingController(rootView: MyView())
```

## Status

#### Property Wrappers

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `State` | |
| ✅ | `Binding` | |
| ✅ | `ObservedObject` | |
| ✅ | `EnvironmentObject` | |
| ✅ | `Published` | In ReactiveKit |
| ✅ | `ObservableObject` | In ReactiveKit |

#### Views

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `Never` | |
| ✅ | `Optional` | |
| ✅ | `VStack` | |
| ✅ | `HStack` | |
| ✅ | `ZStack` | |
| ✅ | `Spacer` | |
| ✅ | `Button` | Partial |
| ✅ | `Color` | |
| ✅ | `Image` | |
| ✅ | `Text` | |
| ✅ | `AnyView` | |
| ✅ | `TupleView` | |
| ✅ | `EmptyView` | |
| ✅ | `ModifiedContent` | |
| ✅ | `ConditionalContent` | |
| ✅ | `GeometryReader` | |
| ✅ | `ForEach` | Partial |
| ✅ | `Shape` | |
| ✅ | `Slider` | |
| ✅ | `Sheet` | |
| ✅ | `ScrollView` | |
| ❌ | `Toggle` | |
| ❌ | `List` | |
| ❌ | `NavigationView` | |
| ❌ | `TabView` | |
| ❌ | ... | |

#### View Modifiers

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `Padding` | |
| ✅ | `Frame` | |
| ✅ | `FlexFrame` | |
| ✅ | `LayoutPriority` | |
| ✅ | `ClipShape` | |
| ✅ | `Overlay` | |
| ✅ | `Background` | |
| ✅ | `FixedSize` | |
| ✅ | `AspectRatio` | |
| ✅ | `Offset` | |
| ✅ | `Shadow` | |
| ✅ | `Gesture` | |
| ✅ | `EnvironmentValue` | |
| ✅ | `EnvironmentObject` | |
| ✅ | `EdgesIgnoringSafeArea` | |
| ❌ | `Animation`| |
| ❌ | `Transaction`| |
| ❌ | `RotationEffect`| |
| ❌ | `ProjectionEffect`| |
| ❌ | `TransformEffect`| |
| ❌ | `ProjectionEffect`| |
| ❌ | `OnAppear`| |
| ❌ | `OnDisappear`| |
| ❌ | ... | |

#### Shapes

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `Path` | |
| ✅ | `Rectangle` | |
| ✅ | `RoundedRectangle` | |
| ✅ | `Circle` | |
| ✅ | `Ellipse` | |
| ✅ | `Capsule` | |

#### Shape Styles

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `Color` | |
| ✅ | `FillStyle` | |
| ✅ | `StrokeStyle` | |
| ✅ | `ForegroundStyle` | |
| ❌ | `ImagePaint` | |
| ❌ | `Gradient` | |
| ❌ | ... | |

#### Gestures

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `TapGesture` | |
| ✅ | `LongPressGesture` | |
| ✅ | `RotationGesture` | |
| ✅ | `DragGesture` | |
| ❌ | ... | |

## Installation

### SPM

Add `https://github.com/DeclarativeHub/MockingbirdUIKit.git` as a dependency.

### Carthage

```
github "DeclarativeHub/MockingbirdUIKit" "master"
```
