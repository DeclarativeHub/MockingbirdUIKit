//
//  ViewNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class ViewNode: UIKitNode<AnyView> {

    override var hierarchyIdentifier: String {
        return "V[\(node.hierarchyIdentifier)]"
    }

    var properties: [String: Any] = [:]
    var node: AnyUIKitNode

    required init( _ view: AnyView, context: Context, resolver: UIKitNodeResolver) {
        self.node = resolver.resolve(view.body, context: context, cachedNode: nil)
        super.init(view, context: context, resolver: resolver)
        self.node.parentNode = self
//        observeDynamicProperties()
    }

    override func update(_ view: AnyView, context: Context) {
        super.update(view, context: context)
        self.node = resolver.resolve(view.body, context: context, cachedNode: node)
        self.node.parentNode = self
//        observeDynamicProperties()
    }

    override func layoutSize(fitting targetSize: CGSize) -> CGSize {
        return node.layoutSize(fitting: targetSize)
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        node.layout(in: parent, bounds: bounds)
    }
}
