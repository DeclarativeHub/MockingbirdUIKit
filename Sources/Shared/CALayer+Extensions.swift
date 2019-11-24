//
//  CALayer+Extensions.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit

public let kMockingbirdLayerName = "kMockableLayer"

extension CALayer {

    public static func mockingbirdLayer() -> Self {
        let layer = self.init()
        layer.name = kMockingbirdLayerName
        return layer
    }
}
