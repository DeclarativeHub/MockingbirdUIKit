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

extension GeometryReader: UIKitNodeResolvable {

    class Node: BaseUIKitNode<GeometryReader, StaticGeometry, NoRenderable> {

        private var node: UIKitNode?

        override func calculateGeometry(fitting targetSize: CGSize) -> StaticGeometry {
            StaticGeometry(idealSize: targetSize)
        }

        override func layout(in container: Container, bounds: Bounds) {
            super.layout(in: container, bounds: bounds)
            let unsafeRect = bounds.unsafeRect()
            let proxy = GeometryProxy(
                size: unsafeRect.size,
                safeAreaInsets: bounds.safeAreaInsets,
                getFrame: { space in
                    switch space {
                    case .local:
                        return CGRect(x: 0, y: 0, width: unsafeRect.width, height: unsafeRect.height)
                    case .global:
                        return unsafeRect
                    case .named:
                        fatalError()
                    }
                }
            )
            let content = view.content(proxy)
            node = content.resolve(context: context, cachedNode: node)
            node?.layout(in: container, bounds: bounds)
        }
    }
}
