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

extension Color: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Color"
        }

        let layer = CALayer()

        func update(view: Color, context: Context) {
            layer.backgroundColor = view.uiColorValue.cgColor
        }

        func layoutSize(fitting targetSize: CGSize, pass: LayoutPass) -> CGSize {
            targetSize
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            layer.frame = bounds.rect
            layer.removeAllAnimations()
            container.layer.addSublayer(layer)
        }

    }

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}
