//
//  TupleView.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 29/02/2020.
//  Copyright © 2020 Declarative Hub. All rights reserved.
//

import Mockingbird

extension TupleView: ContentContainerNode {

    public func contentNodes(context: Context, cachedNodes: [UIKitNode]) -> [UIKitNode] {
        let mirror = Mirror(reflecting: value)
        let nodes = mirror.children.map { ($0.value as! SomeView) }
        if nodes.count == cachedNodes.count {
            return zip(nodes, cachedNodes).map { $0.resolve(context: context, cachedNode: $1) }
        } else {
            return nodes.map { $0.resolve(context: context, cachedNode: nil) }
        }
    }
}
