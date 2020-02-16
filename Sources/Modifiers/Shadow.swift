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

extension ViewModifiers.Shadow: UIKitModifierNodeResolvable {

    class Node: BaseUIKitModifierNode<ViewModifiers.Shadow, StaticGeometry, ShadowView> {

        override var hierarchyIdentifier: String {
            "Shadow(\(node.hierarchyIdentifier))"
        }

        override var layoutableChildNodes: [LayoutableNode] {
            [renderable]
        }

        override func makeRenderable() -> ShadowView {
            ShadowView()
        }

        override func updateRenderable() {
            renderable.layer.shadowColor = modifier.color.uiColorValue.cgColor
            renderable.layer.shadowRadius = modifier.radius
            renderable.layer.shadowOffset = CGSize(width: modifier.x, height: modifier.y)
            renderable.layer.shadowOpacity = 1
        }

        override func calculateGeometry(fitting targetSize: CGSize) -> StaticGeometry {
            StaticGeometry(idealSize: node.layoutSize(fitting: targetSize))
        }

        override func layout(in container: Container, bounds: Bounds) {
            super.layout(in: container, bounds: bounds)
            renderable.replaceSubviews {
                node.layout(
                    in: container.replacingView(renderable),
                    bounds: Bounds(rect: renderable.bounds, safeAreaInsets: .zero)
                )
            }
        }
    }
}

extension ViewModifiers.Shadow {

    class ShadowView: ContainerView {

        override func replaceSubviews(_ block: () -> Void) {
            super.replaceSubviews(block)
            let path = CGMutablePath()
            for sublayer in layer.sublayers ?? [] {
                var sublayerPath: CGPath?
                if let sublayer = sublayer as? CAShapeLayer {
                    sublayerPath = sublayer.path
                } else if let mask = sublayer.mask {
                    if let mask = mask as? CAShapeLayer {
                        sublayerPath = mask.path
                    } else {
                        sublayerPath = CGPath(rect: mask.frame, transform: nil)
                    }
                } else {
                    sublayerPath = CGPath(rect: sublayer.frame, transform: nil)
                }
                if let sublayerPath = sublayerPath {
                    path.addPath(sublayerPath)
                }
            }
            if path != layer.shadowPath {
                layer.shadowPath = path
            }
        }
    }
}
