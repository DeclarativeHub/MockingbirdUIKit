//
//  VStackNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 12/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class VStackNode: UIKitNode<VStack> {

    override var hierarchyIdentifier: String {
        return "HS[\(nodes.map { $0.hierarchyIdentifier }.joined(separator: ";"))]"
    }

    private var nodes: [AnyUIKitNode]
    private var layout: StackLayout
    private var contentLayoutCache: [CGSize: StackLayout.ContentLayout] = [:]

    required init(_ view: VStack, context: Context, resolver: UIKitNodeResolver) {
        let context = modified(context) { $0.environment._layoutAxis = .vertical }
        self.nodes = view.content.flatMap { $0.flattened }.map { resolver.resolve($0, context: context, cachedNode: nil) }
        self.layout = StackLayout(node: nodes.map { $0.axisFlipped() }, interItemSpacing: view.spacing ?? context.environment.stackSpacing, screenScale: UIScreen.main.scale)
        super.init(view, context: context, resolver: resolver)
        self.nodes.forEach { $0.parentNode = self }
    }

    override func update(_ view: VStack, context: Context) {
        let context = modified(context) { $0.environment._layoutAxis = .vertical }
        super.update(view, context: context)
        let content = view.content.flatMap { $0.flattened }
        if nodes.count != content.count {
            nodes = content.map { resolver.resolve($0, context: context, cachedNode: nil) }
            nodes.forEach { $0.parentNode = self }
            layout = StackLayout(node: nodes.map { $0.axisFlipped() }, interItemSpacing: view.spacing ?? env.stackSpacing, screenScale: UIScreen.main.scale)
        } else {
            var childrenModified = false
            for (index, node) in nodes.enumerated() {
                nodes[index] = resolver.resolve(content[index], context: context, cachedNode: node)
                nodes[index].parentNode = self
                childrenModified = childrenModified || nodes[index] !== node
            }
            if childrenModified {
                layout = StackLayout(node: nodes.map { $0.axisFlipped() }, interItemSpacing: view.spacing ?? env.stackSpacing, screenScale: UIScreen.main.scale)
            }
        }
    }
    
    override func layoutSize(fitting targetSize: CGSize) -> CGSize {
        return contentLayout(fittingSize: targetSize.flipped).fittingSize.flipped
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        let bounds = bounds.flipped
        for (node, var frame) in zip(nodes, contentLayout(fittingSize: bounds.size).frames) {
            frame.origin = bounds.origin + frame.origin
            node.layout(in: parent, bounds: frame.flipped)
        }
    }

    private func contentLayout(fittingSize: CGSize) -> StackLayout.ContentLayout {
        if let contentLayout = contentLayoutCache[fittingSize] {
            return contentLayout
        } else {
            let contentLayout = layout.contentLayout(fittingSize: fittingSize, alignment: view.alignment.flipped)
            contentLayoutCache[fittingSize] = contentLayout
            return contentLayout
        }
    }

    override func invalidateLayout() {
        contentLayoutCache.removeAll(keepingCapacity: true)
        super.invalidateLayout()
    }
}
