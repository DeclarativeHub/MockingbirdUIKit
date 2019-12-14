//
//  StrokeShapeNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension StrokeShapeView: UIKitNodeResolvable {
    
    class Node: UIKitNode<StrokeShapeView> {

        override var hierarchyIdentifier: String {
            return "StrokeS"
        }

        private var shapeLayer: CAShapeLayer!

        override func layoutSize(fitting size: CGSize) -> CGSize {
            return size
        }

        override func layout(in parent: UIView, bounds: CGRect) {
            shapeLayer = shapeLayer ?? CAShapeLayer.mockingbirdLayer()
            shapeLayer.path = view.shape.path(in: bounds.inset(by: EdgeInsets(view.lineWidth/2)))
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = view.color.uiColorValue.cgColor
            shapeLayer.lineWidth = view.lineWidth
            parent.layer.addSublayer(shapeLayer)
        }
    }
}
