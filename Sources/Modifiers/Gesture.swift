// MIT License
//
// Copyright (c) 2020 Declarative Hub
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Mockingbird

extension ViewModifiers.Gesture: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        let gestureView = GestureView()

        func update(viewModifier: ViewModifiers.Gesture, context: inout Context) {
            let gesture = viewModifier.gesture as! ResolvableGesture
            gestureView.gestureController = gesture.resolve(
                cachedGestureRecognizer: gestureView.gestureController?._gestureRecognizer
            )
        }

        func layout(in container: Container, bounds: Bounds, node: AnyUIKitNode) {
            gestureView.frame = bounds.rect
            container.view.addSubview(gestureView)
            gestureView.replaceSubnodes {
                node.layout(
                    in: container.replacingView(gestureView),
                    bounds: bounds.at(origin: .zero)
                )
            }
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        return (cachedNodeModifier as? Node) ?? Node()
    }
}

extension ViewModifiers.Gesture {

    class GestureView: ContainerView {

        var didEndAction: (() -> Void)?

       fileprivate var gestureController: GestureController? {
            didSet {
                guard let gestureController = gestureController else { return }
                if let oldGestureController = oldValue {
                    if oldGestureController._gestureRecognizer != gestureController._gestureRecognizer {
                        removeGestureRecognizer(oldGestureController._gestureRecognizer)
                        addGestureRecognizer(gestureController._gestureRecognizer)
                    }
                } else {
                    addGestureRecognizer(gestureController._gestureRecognizer)
                }
            }
        }

        @objc func didEnd() {
            didEndAction?()
        }
    }
}

private protocol ResolvableGesture {
    func resolve(cachedGestureRecognizer: UIGestureRecognizer?) -> GestureController
}

private protocol GestureController: AnyObject {
    var _gestureRecognizer: UIGestureRecognizer { get }
    func registerEndAction<T>(_ action: T)
}

private class TapGestureController: GestureController {

    var _gestureRecognizer: UIGestureRecognizer {
        return gestureRecognizer
    }

    let gestureRecognizer: UITapGestureRecognizer
    var endAction: ((()) -> Void)?

    init(cachedGestureRecognizer: UIGestureRecognizer?, gesture: TapGesture) {
        gestureRecognizer = (cachedGestureRecognizer as? UITapGestureRecognizer) ?? UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = gesture.count
        setupTarget()
    }

    func setupTarget() {
        gestureRecognizer.addTarget(self, action: #selector(didTap))
    }

    func registerEndAction<T>(_ action: T) {
        endAction = action as? ((()) -> Void)
    }

    @objc func didTap() {
        endAction?(())
    }
}

private class LongPressGestureController: GestureController {

    var _gestureRecognizer: UIGestureRecognizer {
        return gestureRecognizer
    }

    let gestureRecognizer: UILongPressGestureRecognizer

    var endAction: ((Bool) -> Void)?

    init(cachedGestureRecognizer: UIGestureRecognizer?, gesture: LongPressGesture) {
        gestureRecognizer = (cachedGestureRecognizer as? UILongPressGestureRecognizer) ?? UILongPressGestureRecognizer()
        gestureRecognizer.minimumPressDuration = gesture.minimumDuration
        gestureRecognizer.allowableMovement = gesture.maximumDistance
        setupTarget()
    }

    func setupTarget() {
        gestureRecognizer.addTarget(self, action: #selector(handleAction(gestureRecognizer:)))
    }

    func registerEndAction<T>(_ action: T) {
        endAction = action as? ((Bool) -> Void)
    }

    @objc func handleAction(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .possible {
            endAction?(true)
        } else if gestureRecognizer.state == .began {
            endAction?(false)
        }
    }
}

extension TapGesture: ResolvableGesture {

    fileprivate func resolve(cachedGestureRecognizer: UIGestureRecognizer?) -> GestureController {
        return TapGestureController(cachedGestureRecognizer: cachedGestureRecognizer, gesture: self)
    }
}

extension LongPressGesture: ResolvableGesture {

    fileprivate func resolve(cachedGestureRecognizer: UIGestureRecognizer?) -> GestureController {
        return LongPressGestureController(cachedGestureRecognizer: cachedGestureRecognizer, gesture: self)
    }
}

extension EndedGesture: ResolvableGesture where G: ResolvableGesture {

    fileprivate func resolve(cachedGestureRecognizer: UIGestureRecognizer?) -> GestureController {
        let controller = gesture.resolve(cachedGestureRecognizer: cachedGestureRecognizer)
        controller.registerEndAction(action)
        return controller
    }
}
