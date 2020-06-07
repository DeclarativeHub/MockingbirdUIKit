//
//  Optional.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 07/06/2020.
//  Copyright © 2020 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension Optional: UIKitNodeResolvable where Wrapped: SomeView {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Optional<***>"
        }

        var node: AnyUIKitNode?

        func update(view: Optional, context: Context) {
            node = view.map { $0.resolve(context: context, cachedNode: node) }
        }

        func layoutSize(fitting targetSize: CGSize) -> CGSize {
            node?.layoutSize(fitting: targetSize) ?? .zero
        }

        func layout(in container: Container, bounds: Bounds) {
            node?.layout(in: container, bounds: bounds)
        }

    }

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}
