//
//  UIKitNodeResolver.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 04/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

public class UIKitNodeResolver {

    lazy var modifierResolver = UIKitNodeModifierResolver(resolver: self)

    private let nodeTypes: [AnyUIKitNode.Type] = [
        ModifiedContentNode.self,
        VStackNode.self,
        HStackNode.self,
        ZStackNode.self,
        TextNode.self,
        ImageNode.self,
        ButtonNode.self,
        ColorNode.self,
        SpacerNode.self,
        GeometryReaderNode.self,
        FillShapeNode.self,
        StrokeShapeNode.self,
        EnvironmentValueModifierNode.self
    ]

    public init() {
    }

    public func resolve(_ view: View, context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        for nodeType in nodeTypes {
            if let node = tryResolve(nodeType, view: view, context: context, cachedNode: cachedNode) {
                return node
            }
        }
        if let view = view as? AnyUIViewRepresentable {
            if let node = cachedNode as? UIViewRepresentableNode {
                node.update(AnyView(view), context: context)
                return node
            } else {
                return UIViewRepresentableNode(AnyView(view), context: context, resolver: self)
            }
        } else {
            if let node = cachedNode as? ViewNode {
                node.update(AnyView(view), context: context)
                return node
            } else {
                return ViewNode(AnyView(view), context: context, resolver: self)
            }
        }
    }

    private func tryResolve(_ nodeType: AnyUIKitNode.Type, view: View, context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode? {
        guard type(of: view) == nodeType.viewType else { return nil }
        if let cachedNode = cachedNode, type(of: cachedNode) == nodeType {
            cachedNode.update(view, context: context)
            return cachedNode
        } else {
            return nodeType.make(view, context: context, resolver: self)
        }
    }
}
