//
//  StackNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension HStack: UIKitNodeResolvable {

    class Node: UIKitNode<HStack> {

        override var hierarchyIdentifier: String {
            return "VS[\(nodes.map { $0.hierarchyIdentifier }.joined(separator: ";"))]"
        }

        private var nodes: [AnyUIKitNode]
        private var layout: StackLayout {
            didSet {
                invalidateLayout()
            }
        }
        private var contentLayoutCache: [CGSize: StackLayout.ContentLayout] = [:]

        required init(_ view: HStack, context: Context) {
            let context = modified(context) { $0.environment._layoutAxis = .horizontal }
            self.nodes = view.content.flatMap { $0.flattened }.map { $0.resolve(context: context, cachedNode: nil) }
            self.layout = StackLayout(node: nodes, interItemSpacing: view.spacing ?? context.environment.stackSpacing, screenScale: UIScreen.main.scale)
            super.init(view, context: context)
            self.nodes.forEach { $0.parentNode = self }
        }

        override func update(_ view: HStack, context: Context) {
            let context = modified(context) { $0.environment._layoutAxis = .horizontal }
            super.update(view, context: context)
            let content = view.content.flatMap { $0.flattened }
            if nodes.count != content.count {
                nodes = content.map { $0.resolve(context: context, cachedNode: nil) }
                nodes.forEach { $0.parentNode = self }
                layout = StackLayout(node: nodes, interItemSpacing: view.spacing ?? env.stackSpacing, screenScale: UIScreen.main.scale)
            } else {
                var childrenModified = false
                for (index, node) in nodes.enumerated() {
                    nodes[index] = content[index].resolve(context: context, cachedNode: node)
                    nodes[index].parentNode = self
                    childrenModified = childrenModified || nodes[index] !== node
                }
                if childrenModified {
                    layout = StackLayout(node: nodes, interItemSpacing: view.spacing ?? env.stackSpacing, screenScale: UIScreen.main.scale)
                }
            }
        }

        override func isSpacer() -> Bool {
            return nodes.count == 1 && nodes[0].isSpacer()
        }

        override func layoutSize(fitting targetSize: CGSize) -> CGSize {
            return contentLayout(fittingSize: targetSize).fittingSize
        }

        override func layout(in parent: UIView, bounds: CGRect) {
            for (node, var frame) in zip(nodes, contentLayout(fittingSize: bounds.size).frames) {
                frame.origin = bounds.origin + frame.origin
                node.layout(in: parent, bounds: frame)
            }
        }

        private func contentLayout(fittingSize: CGSize) -> StackLayout.ContentLayout {
            if let contentLayout = contentLayoutCache[fittingSize] {
                return contentLayout
            } else {
                let contentLayout = layout.contentLayout(fittingSize: fittingSize, alignment: view.alignment)
                contentLayoutCache[fittingSize] = contentLayout
                return contentLayout
            }
        }

        override func invalidateLayout() {
            contentLayoutCache.removeAll(keepingCapacity: true)
            super.invalidateLayout()
        }
    }
}
