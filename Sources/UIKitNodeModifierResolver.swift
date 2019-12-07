//
//  UIKitNodeModifierResolver.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class UIKitNodeModifierResolver {

    let resolver: UIKitNodeResolver

    private let modifierTypes: [AnyUIKitNodeModifier.Type] = [
        PaddingNodeModifier.self,
        FrameNodeModifier.self,
        FixedSizeNodeModifier.self,
        FlexFrameNodeModifier.self,
        OffsetNodeModifier.self,
        LayoutPriorityNodeModifier.self,
        ClipShapeNodeModifier.self,
        OverlayNodeModifier.self,
        BackgroundNodeModifier.self,
        ShadowNodeModifier.self,
        EnvironmentObjectNodeModifier.self
    ]

    init(resolver: UIKitNodeResolver) {
        self.resolver = resolver
    }

    func resolve(_ viewModifier: ViewModifier, context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {

        for modifier in modifierTypes {
            if let modifierNode = tryResolve(modifier, viewModifier: viewModifier, context: context, cachedNodeModifier: cachedNodeModifier) {
                return modifierNode
            }
        }

        fatalError("\(viewModifier) is not resolvable.")
    }

    private func tryResolve(_ nodeType: AnyUIKitNodeModifier.Type, viewModifier: ViewModifier, context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier? {
        guard type(of: viewModifier) == nodeType.modifierType else { return nil }
        if let cachedNodeModifier = cachedNodeModifier, type(of: cachedNodeModifier) == nodeType {
            cachedNodeModifier.update(viewModifier, context: context)
            return cachedNodeModifier
        } else {
            return nodeType.make(viewModifier, context: context, resolver: resolver)
        }
    }
}
