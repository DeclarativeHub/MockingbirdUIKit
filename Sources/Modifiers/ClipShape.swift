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

extension ViewModifiers.ClipShape: UIKitModifierNodeResolvable {

    class Node: BaseUIKitModifierNode<ViewModifiers.ClipShape, StaticGeometry, ClippingView> {

        override var layoutableChildNodes: [LayoutableNode] {
            [renderable]
        }

        override func makeRenderable() -> ClippingView {
            ClippingView()
        }

        override func updateRenderable() {
            renderable.makePath = modifier.shape.path(in:)
        }

        override func calculateGeometry(fitting targetSize: CGSize) -> StaticGeometry {
            StaticGeometry(idealSize: node.layoutSize(fitting: targetSize))
        }

        override func layout(in container: Container, bounds: Bounds) {
            super.layout(in: container, bounds: bounds)
            renderable.replaceSubviews {
                node.layout(
                    in: container.replacingView(renderable),
                    bounds: Bounds(rect: CGRect(origin: .zero, size: bounds.rect.size), safeAreaInsets: .zero)
                )
            }
        }
    }
}

extension ViewModifiers.ClipShape {

    class ClippingView: ContainerView {

        var makePath: ((CGRect) -> CGPath)?
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
            maskLayer.path = makePath?(bounds)
        }
    }
}
