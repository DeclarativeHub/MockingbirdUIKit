//
//  FillShapeNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class FillShapeNode: UIKitNode<FillShapeView> {

    override var hierarchyIdentifier: String {
        return "FillS"
    }

    private var shapeLayer: CAShapeLayer!

    override func layoutSize(fitting size: CGSize) -> CGSize {
        return size
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        shapeLayer = shapeLayer ?? CAShapeLayer.mockingbirdLayer()
        shapeLayer.path = view.shape.path(in: bounds)
        shapeLayer.fillColor = view.color.uiColorValue.cgColor
        parent.layer.addSublayer(shapeLayer)
    }
}

