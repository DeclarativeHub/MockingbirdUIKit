//
//  ZStackNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class ZStackNode: UIKitNode<ZStack> {

    override var hierarchyIdentifier: String {
        return "ZS[\(nodes.map { $0.hierarchyIdentifier }.joined(separator: ";"))]"
    }

    private var nodes: [AnyUIKitNode]

    required init(_ view: ZStack, context: Context, resolver: UIKitNodeResolver) {
        self.nodes = view.content.flatMap { $0.flattened }.map { resolver.resolve($0, context: context, cachedNode: nil) }
        super.init(view, context: context, resolver: resolver)
        self.nodes.forEach { $0.parentNode = self }
    }

    override func update(_ view: ZStack, context: Context) {
        super.update(view, context: context)
        let content = view.content.flatMap { $0.flattened }
        if nodes.count != content.count {
            nodes = content.map { resolver.resolve($0, context: context, cachedNode: nil) }
            nodes.forEach { $0.parentNode = self }
            invalidateLayout()
        } else {
            var childrenModified = false
            for (index, node) in nodes.enumerated() {
                nodes[index] = resolver.resolve(content[index], context: context, cachedNode: node)
                nodes[index].parentNode = self
                childrenModified = childrenModified || nodes[index] !== node
            }
            if childrenModified {
                invalidateLayout()
            }
        }
    }

    override func layoutSize(fitting targetSize: CGSize) -> CGSize {
        return nodes.reduce(.zero) { (totalSize, node) -> CGSize in
            let nodeSize = node.layoutSize(fitting: targetSize)
            return max(totalSize, nodeSize)
        }
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        for node in nodes {
            let size = node.layoutSize(fitting: bounds.size)
            var alignedBounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            switch view.alignment.horizontal {
            case .leading:
                alignedBounds.origin.x = bounds.minX
            case .center:
                alignedBounds.origin.x = bounds.minX + (bounds.width - size.width) / 2
            case .trailing:
                alignedBounds.origin.x = bounds.maxX - size.width
            }
            switch view.alignment.vertical {
            case .top:
                alignedBounds.origin.y = bounds.minY
            case .center:
                alignedBounds.origin.y = bounds.minY + (bounds.height - size.height) / 2
            case .bottom:
                alignedBounds.origin.y = bounds.maxY - size.height
            case .firstTextBaseline, .lastTextBaseline:
                fatalError()
            }
            node.layout(in: parent, bounds: alignedBounds.roundedToScale(scale: UIScreen.main.scale))
        }
    }
}
