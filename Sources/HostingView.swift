//
//  HostingView.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 04/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

public class HostingView: RendererView {

    private var context = Context()

    private let resolver = UIKitNodeResolver()

    public var view: View {
        didSet {
            node = resolver.resolve(view, context: context, cachedNode: node)
            node.didInvalidateLayout = { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }

    private var node: AnyUIKitNode {
        didSet {
            setNeedsLayout()
        }
    }

    public init(_ view: View, resolvedNode: AnyUIKitNode) {
        self.view = view
        self.node = resolvedNode
        super.init(frame: .zero)
        node.didInvalidateLayout = { [weak self] in self?.setNeedsLayout() }
    }

    public init(_ view: View) {
        self.view = view
        self.node = resolver.resolve(view, context: context, cachedNode: nil)
        super.init(frame: .zero)
        node.didInvalidateLayout = { [weak self] in self?.setNeedsLayout() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        replaceSubviews {
            node.layout(in: self, bounds: bounds)
        }
    }

    public func invalidateLayout() {
        setNeedsLayout()
    }
}
