//
//  ModifiedContent.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 29/02/2020.
//  Copyright © 2020 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension ModifiedContent: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "ModifiedContent<\(contentNode.hierarchyIdentifier), \(contentNodeModifier?.hierarchyIdentifier ?? "Never")>"
        }

        var contentNode: AnyUIKitNode!
        var contentNodeModifier: AnyUIKitNodeModifier?

        func update(view: ModifiedContent<Content, Modifier>, context: Context) {
            var context = context
            if let contentNodeModifier = view.modifier.resolve(context: &context, cachedNodeModifier: contentNodeModifier) {
                self.contentNodeModifier = contentNodeModifier
                contentNode = view.content.resolve(context: context, cachedNode: contentNode)
            } else {
                contentNode = view.modifier.body(content: view.content).resolve(context: context, cachedNode: contentNode)
            }
        }

        func layoutSize(fitting targetSize: CGSize) -> CGSize {
            if let contentNodeModifier = contentNodeModifier {
                return contentNodeModifier.layoutSize(fitting: targetSize, node: contentNode)
            } else {
                return contentNode.layoutSize(fitting: targetSize)
            }
        }

        func layout(in container: Container, bounds: Bounds) {
            if let contentNodeModifier = contentNodeModifier {
                contentNodeModifier.layout(in: container, bounds: bounds, node: contentNode)
            } else {
                contentNode.layout(in: container, bounds: bounds)
            }
        }

    }

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}
