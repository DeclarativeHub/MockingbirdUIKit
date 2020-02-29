//
//  ViewModifierContent.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 29/02/2020.
//  Copyright © 2020 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifierContent: AnyUIKitNodeResolvable {

    public func resolve(context: Context, cachedNode: UIKitNode?) -> UIKitNode {
        view.resolve(context: context, cachedNode: cachedNode)
    }
}
