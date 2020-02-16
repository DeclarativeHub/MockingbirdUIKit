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

extension View {

    public func resolve(context: Context, cachedNode: UIKitNode?) -> UIKitNode {
        if let view = self as? AnyUIKitNodeResolvable {
            return view.resolve(context: context, cachedNode: cachedNode)
        } else if let view = self as? ModifiedContent {
            return (view.modifier as! AnyUIKitModifierNodeResolvable).resolve(context: context, view: view, cachedNode: cachedNode)
        } else if let view = self as? AnyUIViewRepresentable {
            if let node = cachedNode as? UIViewRepresentableNode {
                node.update(AnyView(view), context: context)
                return node
            } else {
                return UIViewRepresentableNode(AnyView(self), context: context)
            }
        } else {
            if let node = cachedNode as? ViewNode {
                node.update(AnyView(self), context: context)
                return node
            } else {
                return ViewNode(AnyView(self), context: context)
            }
        }
    }
}

protocol AnyUIKitNodeResolvable {
    func resolve(context: Context, cachedNode: UIKitNode?) -> UIKitNode
}

protocol UIKitNodeResolvable: View, AnyUIKitNodeResolvable {
    associatedtype Node: UIKitNode
}

extension UIKitNodeResolvable {

    func resolve(context: Context, cachedNode: UIKitNode?) -> UIKitNode {
        if let cachedNode = cachedNode as? Node {
            cachedNode.update(self, context: context)
            return cachedNode
        } else {
            return Node(self, context: context)
        }
    }
}

protocol AnyUIKitModifierNodeResolvable {
    func resolve(context: Context, view: View, cachedNode: UIKitNode?) -> UIKitNode
}

protocol UIKitModifierNodeResolvable: AnyUIKitModifierNodeResolvable {
    associatedtype Node: UIKitNode
}

extension UIKitModifierNodeResolvable where Self: ViewModifier {

    func resolve(context: Context, view: View, cachedNode: UIKitNode?) -> UIKitNode {
        if let cachedNode = cachedNode as? Node {
            cachedNode.update(view, context: context)
            return cachedNode
        } else {
            return Node(view, context: context)
        }
    }
}
