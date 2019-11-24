//
//  CGSize+Extensions.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import CoreGraphics

extension CGSize: Hashable {

    public func hash(into hasher: inout Hasher) {
        width.hash(into: &hasher)
        height.hash(into: &hasher)
    }
}

extension CGSize {

    var flipped: CGSize {
        return CGSize(width: height, height: width)
    }

    func verticallyAdding(_ other: CGSize) -> CGSize {
        return CGSize(
            width: max(width, other.width),
            height: height + other.height
        )
    }

    func horizontallyAdding(_ other: CGSize) -> CGSize {
        return CGSize(width: width + other.width, height: max(height, other.height))
    }

    func intersection(_ other: CGSize) -> CGSize {
        return CGSize(
            width: min(width, other.width),
            height: min(height, other.height)
        )
    }

    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

func max(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    return CGSize(width: max(lhs.width, rhs.width), height: max(lhs.height, rhs.height))
}

func min(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    return CGSize(width: min(lhs.width, rhs.width), height: min(lhs.height, rhs.height))
}
