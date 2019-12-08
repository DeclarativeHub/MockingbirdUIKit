//
//  ColorNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class ColorNode: UIKitNode<Color> {

    override var hierarchyIdentifier: String {
        return "C"
    }

    private var colorView: UIView!

    override func layoutSize(fitting size: CGSize) -> CGSize {
        return size
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        colorView = colorView ?? UIView()
        colorView.backgroundColor = view.uiColorValue
        colorView.frame = bounds
        parent.addSubview(colorView)
    }
}
