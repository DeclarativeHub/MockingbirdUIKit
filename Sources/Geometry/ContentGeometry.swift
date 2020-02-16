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

import CoreGraphics
import Mockingbird

extension ContentGeometry: UIKitNodeGeometry {

    public func layout(nodes: [LayoutableNode], in contaner: Container, bounds: Bounds) {
//        precondition(nodes.count == frames.count)
        for (node, frame) in zip(nodes, frames) {
            let bounds = Bounds(
                rect: CGRect(
                    x: bounds.rect.minX + frame.minX,
                    y: bounds.rect.minY + frame.minY,
                    width: frame.width,
                    height: frame.height
                ),
                safeAreaInsets: bounds.safeAreaInsets
            )
            node.layout(in: contaner, bounds: bounds)
        }
    }
}
