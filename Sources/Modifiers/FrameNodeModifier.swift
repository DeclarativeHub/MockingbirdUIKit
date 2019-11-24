//
//  FrameNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class FrameNodeModifier: UIKitNodeModifier<ViewModifiers.Frame> {

    override var hierarchyIdentifier: String {
        return "F"
    }

    private var width: CGFloat? {
        return modifer.width
    }

    private var height: CGFloat? {
        return modifer.height
    }

    private var alignment: Alignment {
        return modifer.alignment
    }

    override func layoutSize(fitting targetSize: CGSize, node: AnyUIKitNode) -> CGSize {
        var targetSize = targetSize
        if let width = width {
            targetSize.width = min(targetSize.width, width)
        }
        if let height = height {
            targetSize.height = min(targetSize.height, height)
        }

        var size = node.layoutSize(fitting: targetSize)
        if let width = width {
            size.width = max(size.width, width)
        }
        if let height = height {
            size.height = max(size.height, height)
        }

        return size
    }

    override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
        var targetSize = bounds.size
        if let width = width {
            targetSize.width = min(targetSize.width, width)
        }
        if let height = height {
            targetSize.height = min(targetSize.height, height)
        }

        var viewSize = node.layoutSize(fitting: targetSize)
        if let width = width {
            viewSize.width = max(viewSize.width, width)
        }
        if let height = height {
            viewSize.height = max(viewSize.height, height)
        }
        
        switch alignment {
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

