//
//  UIKitNodeResolvable.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 14/12/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import Mockingbird

public protocol AnyUIKitNodeResolvable {
    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode
}

protocol UIKitNodeResolvable: View, AnyUIKitNodeResolvable {
    associatedtype Node: AnyUIKitNode
}

extension UIKitNodeResolvable {

    public func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        if let cachedNode = cachedNode as? Node {
            cachedNode.update(self, context: context)
            return cachedNode
        } else {
            return Node.make(self, context: context)
        }
    }
}
