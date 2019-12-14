//
//  FlexFrameNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 17/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifiers.FlexFrame: UIKitNodeModifierResolvable {

    class NodeModifier: UIKitNodeModifier<ViewModifiers.FlexFrame> {

        override var hierarchyIdentifier: String {
            return "FF"
        }

        override func layoutSize(fitting targetSize: CGSize, node: AnyUIKitNode) -> CGSize {
            var targetSize = targetSize
            if let minWidth = modifer.minWidth {
                targetSize.width = max(targetSize.width, minWidth)
            }
            if let maxWidth = modifer.maxWidth {
                targetSize.width = min(targetSize.width, maxWidth)
            }
            if let minHeight = modifer.minHeight {
                targetSize.height = max(targetSize.height, minHeight)
            }
            if let maxHeight = modifer.maxHeight {
                targetSize.height = min(targetSize.height, maxHeight)
            }

            var size = node.layoutSize(fitting: targetSize)
            size.width = clamp(targetSize.width, min: modifer.minWidth ?? size.width, max: modifer.maxWidth ?? size.width)
            size.height = clamp(targetSize.height, min: modifer.minHeight ?? size.height, max: modifer.maxHeight ?? size.height)

            return size
        }

        override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
            let targetSize = bounds.size
            let viewSize = node.layoutSize(fitting: targetSize)

            switch modifer.alignment {
            case .center:
                let rect = CGRect(
                    x: bounds.minX + (bounds.width - viewSize.width) / 2,
                    y: bounds.minY + (bounds.height - viewSize.height) / 2,
                    width: viewSize.width,
                    height: viewSize.height
                )
                node.layout(in: parent, bounds: rect)
            default:
                fatalError("TODO")
            }
        }
    }
}
