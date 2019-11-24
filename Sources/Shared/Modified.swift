//
//  Modified.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

func modified<T>(_ value: T, _ modify: (inout T) -> Void) -> T {
    var copy = value
    modify(&copy)
    return copy
}
