//
//  BackgroundNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifiers.Background: UIKitNodeModifierResolvable {

    class NodeModifier: UIKitNodeModifier<ViewModifiers.Background> {

        override var hierarchyIdentifier: String {
            return "Bg"
        }

        private var backgroundNode: AnyUIKitNode!

        override func layoutSize(fitting size: CGSize, node: AnyUIKitNode) -> CGSize {
            return node.layoutSize(fitting: size)
        }

        override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
            backgroundNode = modifer.background.resolve(context: context, cachedNode: backgroundNode)
            backgroundNode.parentNode = node
            backgroundNode.layout(in: parent, bounds: bounds)
            node.layout(in: parent, bounds: bounds)
        }
    }
}
