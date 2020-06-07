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

extension ViewModifiers.Frame: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "Frame"
        }

        var viewModifier: ViewModifiers.Frame!

        func update(viewModifier: ViewModifiers.Frame, context: inout Context) {
            self.viewModifier = viewModifier
        }

        func layoutSize(fitting targetSize: CGSize, node: AnyUIKitNode) -> CGSize {
            LayoutAlgorithms
                .Frame(frame: viewModifier, node: node, screenScale: UIScreen.main.scale)
                .contentLayout(fittingSize: targetSize)
                .idealSize
        }

        func layout(in container: Container, bounds: Bounds, node: AnyUIKitNode) {
            let geometry = LayoutAlgorithms
                .Frame(frame: viewModifier, node: node, screenScale: UIScreen.main.scale)
                .contentLayout(fittingSize: bounds.size)
            node.layout(
                in: container,
                bounds: bounds.update(to: geometry.frames[0].offsetBy(dx: bounds.rect.minX, dy: bounds.rect.minY))
            )
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        return (cachedNodeModifier as? Node) ?? Node()
    }
}
