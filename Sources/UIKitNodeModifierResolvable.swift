//
//  UIKitNodeModifierResolvable.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 14/12/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import Mockingbird

public protocol AnyUIKitNodeModifierResolvable {
    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier
}

protocol UIKitNodeModifierResolvable: ViewModifier, AnyUIKitNodeModifierResolvable {
    associatedtype NodeModifier: AnyUIKitNodeModifier
}

extension UIKitNodeModifierResolvable {

    public func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        if let cachedNode = cachedNodeModifier as? NodeModifier {
            cachedNode.update(self, context: context)
            return cachedNode
        } else {
            return NodeModifier.make(self, context: context)
        }
    }
}
