//
//  CGFloat+Extensions.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 17/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import CoreGraphics

func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return Swift.min(Swift.max(value, min), max)
}
