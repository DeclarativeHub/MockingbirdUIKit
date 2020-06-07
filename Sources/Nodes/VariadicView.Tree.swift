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

extension VariadicView.Tree: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Tree<\(nodes.map(\.hierarchyIdentifier).joined(separator: ", "))>"
        }

        var nodes: [AnyUIKitNode]!

        var layoutAlgorithm: LayoutAlgorithm!

        func update(view: SomeView, context: Context) {
            if let view = view as? VStack<Content> {
                self.nodes = view.tree.content.resolve(context: context, cachedNodes: nodes ?? [])
                self.layoutAlgorithm = view.tree.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            } else if let view = view as? HStack<Content> {
                self.nodes = view.tree.content.resolve(context: context, cachedNodes: nodes ?? [])
                self.layoutAlgorithm = view.tree.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            } else if let view = view as? ZStack<Content> {
                self.nodes = view.tree.content.resolve(context: context, cachedNodes: nodes ?? [])
                self.layoutAlgorithm = view.tree.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            } else {
                fatalError()
            }
        }

        func update(view: VariadicView.Tree<Root, Content>, context: Context) {
            fatalError()
        }

        func layoutSize(fitting targetSize: CGSize, pass: LayoutPass) -> CGSize {
            layoutAlgorithm.contentLayout(fittingSize: targetSize, pass: pass).idealSize
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            let layout = layoutAlgorithm.contentLayout(fittingSize: bounds.size, pass: pass)
            zip(nodes, layout.frames).forEach { (node, frame) in
                node.layout(
                    in: container,
                    bounds: Bounds(
                        rect: frame.offsetBy(dx: bounds.origin.x, dy: bounds.origin.y),
                        safeAreaInsets: .zero
                    ),
                    pass: pass
                )
            }
        }

    }

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}
