//
//  OverlayNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifiers.Overlay: UIKitNodeModifierResolvable {

    class NodeModifier: UIKitNodeModifier<ViewModifiers.Overlay> {

        override var hierarchyIdentifier: String {
            return "Ovrly"
        }

        private var overlayNode: AnyUIKitNode!

        override func layoutSize(fitting size: CGSize, node: AnyUIKitNode) -> CGSize {
            return node.layoutSize(fitting: size)
        }

        override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
            overlayNode = modifer.overlay.resolve(context: context, cachedNode: overlayNode)
            overlayNode.parentNode = node
            node.layout(in: parent, bounds: bounds)
            overlayNode.layout(in: parent, bounds: bounds)
        }
    }
}
