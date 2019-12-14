//
//  EnvironmentValueNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 15/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension EnvironmentValueModifier: UIKitNodeResolvable {

    class Node: UIKitNode<EnvironmentValueModifier> {

        override var hierarchyIdentifier: String {
            return "EnvM[\(node.hierarchyIdentifier)]"
        }

        private var node: AnyUIKitNode

        required init(_ view: EnvironmentValueModifier, context: Context) {
            let context = modified(context) {
                view.modify(&$0.environment)
            }
            self.node = view.content.resolve(context: context, cachedNode: nil)
            super.init(view, context: context)
            node.parentNode = self
        }

        override func update(_ view: EnvironmentValueModifier, context: Context) {
            super.update(view, context: context)
            let context = modified(context) {
                view.modify(&$0.environment)
            }
            node = view.content.resolve(context: context, cachedNode: node)
            node.parentNode = self
        }

        override func layoutPriority() -> Double {
            return node.layoutPriority()
        }

        override func layoutSize(fitting targetSize: CGSize) -> CGSize {
            return node.layoutSize(fitting: targetSize)
        }

        override func layout(in parent: UIView, bounds: CGRect) {
            node.layout(in: parent, bounds: bounds)
        }
    }
}
