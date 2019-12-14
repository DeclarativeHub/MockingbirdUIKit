//
//  GeometryReaderNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension GeometryReader: UIKitNodeResolvable {

    class Node: UIKitNode<GeometryReader> {

        override var hierarchyIdentifier: String {
            return "GR"
        }

        private var node: AnyUIKitNode? {
            didSet {
                node?.parentNode = self
            }
        }

        override func layoutSize(fitting targetSize: CGSize) -> CGSize {
            return targetSize
        }

        override func layout(in parent: UIView, bounds: CGRect) {
            let proxy = GeometryProxy(
                size: bounds.size,
                safeAreaInsets: .zero,
                getFrame: { space in
                    switch space {
                    case .local:
                        return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
                    case .global:
                        return bounds
                    case .named:
                        fatalError()
                    }
            }
            )
            let content = view.content(proxy)
            node = content.resolve(context: context, cachedNode: node)
            node?.layout(in: parent, bounds: bounds)
        }
    }
}
