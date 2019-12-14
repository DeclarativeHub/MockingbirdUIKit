//
//  ModifiedContentNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ModifiedContent: UIKitNodeResolvable {

    class Node: UIKitNode<ModifiedContent> {

        override var hierarchyIdentifier: String {
            return "M[\(nodeModifier.hierarchyIdentifier):\(node.hierarchyIdentifier)]"
        }

        private var node: AnyUIKitNode
        private var nodeModifier: AnyUIKitNodeModifier

        required init(_ view: ModifiedContent, context: Context) {
            self.nodeModifier = view.modifier.resolve(context: context, cachedNodeModifier: nil)
            self.node = view.content.resolve(context: nodeModifier.context, cachedNode: nil)
            super.init(view, context: context)
            self.node.parentNode = self
        }

        override func update(_ view: ModifiedContent, context: Context) {
            super.update(view, context: context)
            nodeModifier = view.modifier.resolve(context: context, cachedNodeModifier: nodeModifier)
            self.node = view.content.resolve(context: nodeModifier.context, cachedNode: node)
            node.parentNode = self
        }

        override func layoutPriority() -> Double {
            nodeModifier.layoutPriorityFor(node)
        }

        override func layoutSize(fitting targetSize: CGSize) -> CGSize {
            return nodeModifier.layoutSize(fitting: targetSize, node: node)
        }

        override func layout(in parent: UIView, bounds: CGRect) {
            nodeModifier.layout(node, in: parent, bounds: bounds)
        }
    }
}
