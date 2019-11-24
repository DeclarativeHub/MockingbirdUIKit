//
//  CGRect+Extensions.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import CoreGraphics
import Mockingbird

extension CGRect {

    var flipped: CGRect {
        return CGRect(x: origin.y, y: origin.x, width: height, height: width)
    }

    func inset(by insets: EdgeInsets) -> CGRect {
        return CGRect(
            x: minX + CGFloat(insets.leading),
            y: minY + CGFloat(insets.top),
            width: width - CGFloat(insets.leading + insets.trailing),
            height: height - CGFloat(insets.top + insets.bottom)
        )
    }
}
