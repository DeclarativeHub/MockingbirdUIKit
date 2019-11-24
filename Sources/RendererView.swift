//
//  RendererView.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit

public final class RendererLayer: CALayer {

    private var sublayersToRemove: Set<CALayer> = []

    public override func addSublayer(_ layer: CALayer) {
        if layer.name == kMockingbirdLayerName {
            sublayersToRemove.remove(layer)
        }
        super.addSublayer(layer)
    }

    public func replaceSublayers(_ block: () -> Void) {
        sublayersToRemove = Set(sublayers?.filter { $0.name == kMockingbirdLayerName } ?? [])
        block()
        sublayersToRemove.forEach { $0.removeFromSuperlayer() }
    }
}

open class RendererView: UIView {

    open override class var layerClass: AnyClass {
        return RendererLayer.self
    }

    private var subviewsToRemove: Set<UIView> = []

    open override func addSubview(_ view: UIView) {
        subviewsToRemove.remove(view)
        if view.superview !== self {
            super.addSubview(view)
        } else {
            bringSubviewToFront(view)
        }
    }

    public func replaceSubviews(_ block: () -> Void) {
        subviewsToRemove = Set(subviews)
//        (layer as! RendererLayer).replaceSublayers(block)
        block()
        subviewsToRemove.forEach { $0.removeFromSuperview() }
    }
}

open class RendererControl: UIControl {

    open override class var layerClass: AnyClass {
        return RendererLayer.self
    }

    private var subviewsToRemove: Set<UIView> = []

    open override func addSubview(_ view: UIView) {
        subviewsToRemove.remove(view)
        super.addSubview(view)
    }

    public func replaceSubviews(_ block: () -> Void) {
        subviewsToRemove = Set(subviews)
        (layer as! RendererLayer).replaceSublayers(block)
        subviewsToRemove.forEach { $0.removeFromSuperview() }
    }
}
