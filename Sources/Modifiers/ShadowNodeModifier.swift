//
//  ShadowNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class ShadowNodeModifier: UIKitNodeModifier<ViewModifiers.Shadow> {

    private class ShadowView: RendererView {

        override func replaceSubviews(_ block: () -> Void) {
            super.replaceSubviews(block)
            let path = CGMutablePath()
            for sublayer in layer.sublayers ?? [] {
                var sublayerPath: CGPath?
                if let sublayer = sublayer as? CAShapeLayer {
                    sublayerPath = sublayer.path
                } else if let mask = sublayer.mask {
                    if let mask = mask as? CAShapeLayer {
                        sublayerPath = mask.path
                    } else {
                        sublayerPath = CGPath(rect: mask.frame, transform: nil)
                    }
                } else {
                    sublayerPath = CGPath(rect: sublayer.frame, transform: nil)
                }
                if let sublayerPath = sublayerPath {
                    path.addPath(sublayerPath)
                }
            }
            if path != layer.shadowPath {
                layer.shadowPath = path
            }
        }
    }

    override var hierarchyIdentifier: String {
        return "Shdw"
    }

    private var shadowView: ShadowView!

    override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
        shadowView = shadowView ?? ShadowView(frame: bounds)
        shadowView.layer.shadowColor = modifer.color.uiColorValue.cgColor
        shadowView.layer.shadowRadius = modifer.radius
        shadowView.layer.shadowOffset = CGSize(width: modifer.x, height: modifer.y)
        shadowView.layer.shadowOpacity = 1
        shadowView.replaceSubviews {
            node.layout(in: shadowView, bounds: shadowView.bounds)
        }
        parent.addSubview(shadowView)
    }
}
