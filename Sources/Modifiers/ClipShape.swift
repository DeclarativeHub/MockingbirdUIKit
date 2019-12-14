//
//  ClipShapeNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ViewModifiers.ClipShape: UIKitNodeModifierResolvable {
    
    class NodeModifier: UIKitNodeModifier<ViewModifiers.ClipShape> {

        private class ClippingView: RendererView {

            var clipPath: CGPath? {
                didSet {
                    guard let clipPath = clipPath else {
                        layer.mask = nil
                        return
                    }
                    guard clipPath != oldValue else {
                        return
                    }
                    let mask = CAShapeLayer()
                    mask.path = clipPath
                    layer.mask = mask
                }
            }
        }

        override var hierarchyIdentifier: String {
            return "CS"
        }

        private var clippingView: ClippingView?

        override func layoutSize(fitting size: CGSize, node: AnyUIKitNode) -> CGSize {
            return node.layoutSize(fitting: size)
        }

        override func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
            let view = clippingView ?? ClippingView(frame: bounds)
            self.clippingView = view
            view.clipPath = modifer.shape.path(in: view.bounds)
            view.replaceSubviews {
                node.layout(in: view, bounds: view.bounds)
            }
            parent.addSubview(view)
        }
    }
}
