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

extension ViewModifiers.Animation: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "Animation"
        }

        var viewModifier: ViewModifiers.Animation!

        func update(viewModifier: ViewModifiers.Animation, context: inout Context) {
            self.viewModifier = viewModifier
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: AnyUIKitNode) {
            if let animation = viewModifier.animation {
                animation.animate {
                    node.layout(in: container, bounds: bounds, pass: pass)
                }
            } else {
                UIView.performWithoutAnimation {
                    node.layout(in: container, bounds: bounds, pass: pass)
                }
            }
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        return (cachedNodeModifier as? Node) ?? Node()
    }
}

private extension Animation {

    func animate(_ block: @escaping () -> Void) {

        var options: UIView.AnimationOptions = []

        switch repetition {
        case .none:
            break
        case .forever(let autoreverses):
            options.insert(.repeat)
            if autoreverses {
                options.insert(.autoreverse)
            }
        case .count(_, let autoreverses):
             // TODO count
            options.insert(.repeat)
            if autoreverses {
                options.insert(.autoreverse)
            }
        }

        switch kind {
        case .linear(let easeIn, let easeOut):
            if easeIn {
                options.insert(.curveEaseIn)
            }
            if easeOut {
                options.insert(.curveEaseOut)
            }
            UIView.animate(
                withDuration: duration * speed,
                delay: delay,
                options: options,
                animations: block,
                completion: nil
            )
        case .spring(_, let dampingFraction, _):
            // TODO: response and blend duration
            UIView.animate(
                withDuration: duration * speed,
                delay: delay,
                usingSpringWithDamping: CGFloat(dampingFraction),
                initialSpringVelocity: 1,
                options: options,
                animations: block,
                completion: nil
            )
        }
    }
}
