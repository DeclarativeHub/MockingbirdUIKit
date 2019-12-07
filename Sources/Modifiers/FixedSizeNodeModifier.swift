//
//  FixedSizeNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 11/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class FixedSizeNodeModifier: UIKitNodeModifier<ViewModifiers.FixedSize> {

    override var hierarchyIdentifier: String {
        return "FS"
    }

    override func layoutSize(fitting size: CGSize, node: AnyUIKitNode) -> CGSize {
        return node.layoutSize(fitting: .zero)
    }
}
