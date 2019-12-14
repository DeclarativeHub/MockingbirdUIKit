//
//  UIKitNodeResolver.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 04/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension View {

    public func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        if let view = self as? AnyUIKitNodeResolvable {
            return view.resolve(context: context, cachedNode: cachedNode)
        } else if let view = self as? AnyUIViewRepresentable {
            if let node = cachedNode as? UIViewRepresentableNode {
                node.update(AnyView(view), context: context)
                return node
            } else {
                return UIViewRepresentableNode(AnyView(self), context: context)
            }
        } else {
            if let node = cachedNode as? ViewNode {
                node.update(AnyView(self), context: context)
                return node
            } else {
                return ViewNode(AnyView(self), context: context)
            }
        }
    }
}

extension ViewModifier {

    public func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        if let viewModifier = self as? AnyUIKitNodeModifierResolvable {
            return viewModifier.resolve(context: context, cachedNodeModifier: cachedNodeModifier)
        } else {
            fatalError("\(self) does not conform to AnyUIKitNodeModifierResolvable.")
        }
    }
}
