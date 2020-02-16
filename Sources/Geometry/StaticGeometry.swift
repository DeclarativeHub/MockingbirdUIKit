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

public struct StaticGeometry: UIKitNodeGeometry {

    public var rect: CGRect

    @inlinable
    public var idealSize: CGSize {
        rect.size
    }

    @inlinable
    public init(origin: CGPoint = .zero, idealSize: CGSize) {
        self.rect = CGRect(origin: origin, size: idealSize)
    }

    @inlinable
    public func layout(nodes: [LayoutableNode], in contaner: Container, bounds: Bounds) {
        let bounds = Bounds(
            rect: CGRect(
                x: bounds.rect.minX + rect.minX,
                y: bounds.rect.minY + rect.minY,
                width: bounds.rect.width,
                height: bounds.rect.height
            ),
            safeAreaInsets: bounds.safeAreaInsets
        )
        for node in nodes {
            node.layout(in: contaner, bounds: bounds)
        }
    }
}
