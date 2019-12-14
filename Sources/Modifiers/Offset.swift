//
//  OffsetModifierNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifiers.Offset: UIKitNodeModifierResolvable {
    
    class NodeModifier: UIKitNodeModifier<ViewModifiers.Offset> {

        override var hierarchyIdentifier: String {
            return "Offst"
        }

        override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
            node.layout(
                in: parent,
                bounds: CGRect(
                    origin: bounds.origin + CGPoint(x: modifer.offset.width, y: modifer.offset.height),
                    size: bounds.size
                )
            )
        }
    }
}
