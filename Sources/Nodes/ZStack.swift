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

extension ZStack: UIKitNodeResolvable {

    class Node: BaseUIKitNode<ZStack, ContentGeometry, NoRenderable> {

        override var hierarchyIdentifier: String {
            "ZStack(\(nodes.map { $0.hierarchyIdentifier }.joined(separator: ", ")))"
        }

        private var layout: Layout.ZStack = .init(nodes: []) {
            didSet {
                invalidateRenderingState()
            }
        }

        override var layoutableChildNodes: [LayoutableNode] {
            nodes
        }

        var nodes: [UIKitNode] = [] {
            didSet {
                nodes.forEach { $0.didMoveToParent(self) }
            }
        }

        override func update(_ view: ZStack, context: Context) {
            super.update(view, context: context)
            let content = view.content.flatMap { $0.flattened }
            if nodes.count != content.count {
                nodes = content.map { $0.resolve(context: context, cachedNode: nil) }
                layout = Layout.ZStack(nodes: nodes, screenScale: UIScreen.main.scale)
            } else {
                var childrenModified = false
                for (index, node) in nodes.enumerated() {
                    nodes[index] = content[index].resolve(context: context, cachedNode: node)
                    childrenModified = childrenModified || nodes[index] !== node
                }
                if childrenModified {
                    layout = Layout.ZStack(nodes: nodes, screenScale: UIScreen.main.scale)
                }
            }
        }

        override func calculateGeometry(fitting targetSize: CGSize) -> ContentGeometry {
            layout.contentLayout(fittingSize: targetSize, alignment: view.alignment)
        }
    }
}
