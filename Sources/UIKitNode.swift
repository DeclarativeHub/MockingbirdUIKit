//
//  UIKitNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

open class AnyUIKitNode: Layoutable {

    public class var viewType: View.Type {
        fatalError("To be implemented in a subclass")
    }

    open var parentNode: AnyUIKitNode?

    open var hierarchyIdentifier: String {
        return String(describing: self)
    }
    
    public var didInvalidateLayout: (() -> Void)?
    public var didInvalidateState: (() -> Void)?

    open class func make(_ view: View, context: Context, resolver: UIKitNodeResolver) -> AnyUIKitNode {
        fatalError("To be implemented in a subclass")
    }

    open func update(_ view: View, context: Context) {
        fatalError("To be implemented in a subclass")
    }

    open func layoutSize(fitting size: CGSize) -> CGSize {
        return .zero
    }

    open func layout(in parent: UIView, bounds: CGRect) {
    }

    public func isSpacer() -> Bool {
        return false
    }

    open func layoutPriority() -> Double {
        return 0
    }

    open func invalidateLayout() {
        parentNode?.invalidateLayout()
        didInvalidateLayout?()
    }

    open func invalidateState() {
        parentNode?.invalidateState()
        didInvalidateState?()
    }
}

open class UIKitNode<V: View>: AnyUIKitNode {

    public override class var viewType: View.Type {
        return V.self
    }

    public var view: V

    public var context: Context
    
    public var env: EnvironmentValues {
        didSet {
            if env != oldValue {
                invalidateLayout()
            }
        }
    }

    public let resolver: UIKitNodeResolver

    public required init(_ view: V, context: Context, resolver: UIKitNodeResolver) {
        self.view = view
        self.resolver = resolver
        self.context = context
        self.env = context.environment
    }

    open override class func make(_ view: View, context: Context, resolver: UIKitNodeResolver) -> AnyUIKitNode {
        return Self.init(view as! V, context: context, resolver: resolver)
    }

    open func update(_ view: V, context: Context) {
        self.view = view
        self.context = context
        self.env = context.environment
    }

    open override func update(_ view: View, context: Context) {
        self.update(view as! V, context: context)
    }
}
