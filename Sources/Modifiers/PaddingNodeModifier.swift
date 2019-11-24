//
//  PaddingNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class PaddingNodeModifier: UIKitNodeModifier<ViewModifiers.Padding> {

    override var hierarchyIdentifier: String {
        return "P"
    }

    private var insets: EdgeInsets {
        return EdgeInsets(
            top: modifer.top ?? context.environment.padding,
            leading: modifer.leading ?? context.environment.padding,
            bottom: modifer.bottom ?? context.environment.padding,
            trailing: modifer.trailing ?? context.environment.padding
        )
    }

    override func layoutSize(fitting size: CGSize, node: AnyUIKitNode) -> CGSize {
        let insets = self.insets
        let availableSize = CGSize(
            width: size.width - CGFloat(insets.leading + insets.trailing),
            height: size.height - CGFloat(insets.top + insets.bottom)
        )
        let bodySize = node.layoutSize(fitting: availableSize)
        return CGSize(
            width: bodySize.width + CGFloat(insets.leading + insets.trailing),
            height: bodySize.height + CGFloat(insets.top + insets.bottom)
        )
    }

    override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
        node.layout(in: parent, bounds: bounds.inset(by: insets))
    }
}
