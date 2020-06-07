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

protocol UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode
}

protocol TransientContainerView {
    var contentViews: [SomeView] { get }
}

extension SomeView {

    public var contentViews: [SomeView] {
        if let container = self as? TransientContainerView {
            return container.contentViews
        } else {
            return [self]
        }
    }

    public func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        let resolvedNode: AnyUIKitNode
        if let view = self as? UIKitNodeResolvable {
            resolvedNode = view.resolve(context: context, cachedNode: cachedNode)
        } else if let view = self as? AnyUIViewRepresentable {
            let node = (cachedNode as? UIViewRepresentableNode) ?? UIViewRepresentableNode()
            node.update(view: view, context: context)
            return node
        } else {
            resolvedNode = cachedNode as? ViewNode ?? ViewNode()
        }
        resolvedNode.update(view: self, context: context)
        return resolvedNode
    }

    public func resolve(context: Context, cachedNodes: [AnyUIKitNode]) -> [AnyUIKitNode] {
        let views = contentViews
        if views.count == cachedNodes.count {
            return zip(views, cachedNodes).map {
                $0.resolve(context: context, cachedNode: $1)
            }
        } else {
            return views.map {
                $0.resolve(context: context, cachedNode: nil)
            }
        }
    }

}
