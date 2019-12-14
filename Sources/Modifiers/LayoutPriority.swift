//
//  LayoutPriorityNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifiers.LayoutPriority: UIKitNodeModifierResolvable {

    class NodeModifier: UIKitNodeModifier<ViewModifiers.LayoutPriority> {
        
        override var hierarchyIdentifier: String {
            return "LP"
        }
        
        override func layoutPriorityFor(_ node: AnyUIKitNode) -> Double {
            return modifer.value
        }
    }
}
