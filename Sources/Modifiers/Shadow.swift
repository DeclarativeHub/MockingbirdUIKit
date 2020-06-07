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

extension ViewModifiers.Shadow: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "Shadow"
        }

        let shadowView = ShadowView()

        func update(viewModifier: ViewModifiers.Shadow, context: inout Context) {
            shadowView.layer.shadowColor = viewModifier.color.uiColorValue.cgColor
            shadowView.layer.shadowRadius = viewModifier.radius
            shadowView.layer.shadowOffset = CGSize(width: viewModifier.x, height: viewModifier.y)
            shadowView.layer.shadowOpacity = 1
        }

        func layout(in container: Container, bounds: Bounds, node: AnyUIKitNode) {
            shadowView.frame = bounds.rect
            container.view.addSubview(shadowView)
            shadowView.replaceSubnodes {
                node.layout(
                    in: container.replacingView(shadowView),
                    bounds: bounds.at(origin: .zero)
                )
            }
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        return (cachedNodeModifier as? Node) ?? Node()
    }
}

extension ViewModifiers.Shadow {

    class ShadowView: ContainerView {

        override func layoutSubviews() {
            super.layoutSubviews()
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
