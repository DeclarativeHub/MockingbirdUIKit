//
//  VariadicView.Tree.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 29/02/2020.
//  Copyright © 2020 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension VariadicView.Tree: UIKitNodeResolvable {

    class Node: BaseUIKitNode<VariadicView.Tree<Root, Content>, ContentGeometry, NoRenderable> {

        override var hierarchyIdentifier: String {
            return "Tree[\(nodes.map { $0.hierarchyIdentifier }.joined(separator: ", "))]"
        }
        
        private var layoutAlgorithm: LayoutAlgorithm! = nil {
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

        override func update(_ view: VariadicView.Tree<Root, Content>, context: Context) {
            let layoutChanged = self.view.root != view.root
            super.update(view, context: context)
            let newNodes = view.content.contentNodes(context: context, cachedNodes: nodes)
            let nodesChanges = nodes.count != newNodes.count || zip(nodes, newNodes).contains { $0 !== $1 }
            self.nodes = newNodes
            if self.layoutAlgorithm == nil || layoutChanged || nodesChanges {
                self.layoutAlgorithm = view.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            }
        }

        override func calculateGeometry(fitting targetSize: CGSize) -> ContentGeometry {
            layoutAlgorithm.contentLayout(fittingSize: targetSize)
        }
    }
}
