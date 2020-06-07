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

extension ViewModifiers.ClipShape: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "ClipShape"
        }

        let clippingView = ClippingView()

        func update(viewModifier: ViewModifiers.ClipShape<S>, context: inout Context) {
            clippingView.makePath = viewModifier.shape.path(in:)
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: AnyUIKitNode) {
            clippingView.frame = bounds.rect
            clippingView.layoutIfNeeded()
            container.view.addSubview(clippingView)
            clippingView.replaceSubnodes {
                node.layout(
                    in: container.replacingView(clippingView),
                    bounds: bounds.at(origin: .zero),
                    pass: pass
                )
            }
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        return (cachedNodeModifier as? Node) ?? Node()
    }
}

extension ViewModifiers.ClipShape {

    class ClippingView: ContainerView {

        var makePath: ((CGRect) -> Path)?
        let maskLayer = CAShapeLayer()

        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.mask = maskLayer
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            maskLayer.path = makePath?(bounds).cgPath
        }
    }
}
