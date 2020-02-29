//
//  ModifiedContent.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 29/02/2020.
//  Copyright © 2020 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ModifiedContent: AnyUIKitNodeResolvable {

    public func resolve(context: Context, cachedNode: UIKitNode?) -> UIKitNode {
        (modifier as! AnyUIKitModifierNodeResolvable)
            .resolve(context: context, view: ModifiedContent<ViewModifierContent<Modifier>, Modifier>(content: ViewModifierContent(content, modifier: modifier), modifier: modifier), cachedNode: cachedNode)
    }
}
