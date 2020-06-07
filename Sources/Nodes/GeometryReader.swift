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

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "GeometryReader<***>"
        }

        var view: GeometryReader<Content>?
        var context: Context?

        var node: AnyUIKitNode?

        func update(view: GeometryReader<Content>, context: Context) {
            self.view = view
            self.context = context
        }

        func layoutSize(fitting targetSize: CGSize) -> CGSize {
            targetSize
        }

        func layout(in container: Container, bounds: Bounds) {
            guard let view = view, let context = context else { fatalError() }
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

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}
