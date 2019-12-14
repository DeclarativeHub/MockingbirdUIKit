//
//  GestureNodeModifier.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 07/12/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifiers.Gesture: UIKitNodeModifierResolvable {

    class NodeModifier: UIKitNodeModifier<ViewModifiers.Gesture> {

        private class GestureView: RendererView {

            var didEndAction: (() -> Void)?

            var gestureController: GestureController? {
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

        override var hierarchyIdentifier: String {
            return "Gstr"
        }

        private var gestureView: GestureView!

        override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
            gestureView = gestureView ?? GestureView(frame: bounds)
            gestureView.gestureController = (modifer.gesture as? ResolvableGesture)?
                .resolve(cachedGestureRecognizer: gestureView.gestureController?._gestureRecognizer)
            gestureView.replaceSubviews {
                node.layout(in: gestureView, bounds: gestureView.bounds)
            }
            parent.addSubview(gestureView)
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
