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

    public var context: Context

    public private(set) var view: View

    private var node: AnyUIKitNode {
        didSet {
            invalidateLayout()
        }
    }

    private var previousBounds: CGRect? = nil

    public init(_ view: View, resolvedNode: AnyUIKitNode, context: Context = Context()) {
        self.view = view
        self.context = context
        self.node = resolvedNode
        super.init(frame: .zero)
        node.didInvalidateLayout = { [weak self] in
            self?.invalidateLayout()
        }
    }

    public init(_ view: View, context: Context = Context()) {
        self.view = view
        self.context = context
        self.node = view.resolve(context: context, cachedNode: nil)
        super.init(frame: .zero)
        node.didInvalidateLayout = { [weak self] in
            self?.invalidateLayout()
        }
    }

    public func updateView(_ view: View, resolvedNode: AnyUIKitNode? = nil) {
        self.view = view
        self.node = resolvedNode ?? view.resolve(context: context, cachedNode: nil)
        node.didInvalidateLayout = { [weak self] in
            self?.invalidateLayout()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let bounds: CGRect
        if #available(iOS 11.0, *) {
            bounds = self.safeAreaLayoutGuide.layoutFrame
        } else {
            bounds = self.bounds
        }
        if previousBounds != bounds {
            previousBounds = bounds
            replaceSubviews {
                node.layout(in: self, bounds: bounds)
            }
        }
    }

    public func invalidateLayout() {
        previousBounds = nil
        setNeedsLayout()
    }
}
