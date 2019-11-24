//
//  UIKitNodeModifier.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

public protocol AnyUIKitNodeModifier {

    static var modifierType: ViewModifier.Type { get }

    var hierarchyIdentifier: String { get }

    func layoutSize(fitting size: CGSize, node: AnyUIKitNode) -> CGSize

    func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect)

    func layoutPriorityFor(_ node: AnyUIKitNode) -> Double

    static func make(_ modifier: ViewModifier, context: Context, resolver: UIKitNodeResolver) -> AnyUIKitNodeModifier

    func update(_ modifier: ViewModifier, context: Context)
}

open class UIKitNodeModifier<Modifier: ViewModifier> {

    open var hierarchyIdentifier: String {
        fatalError("To be implemented in a subclass")
    }

    public var modifer: Modifier
    public var context: Context
    public var resolver: UIKitNodeResolver

    public required init(_ modifier: Modifier, context: Context, resolver: UIKitNodeResolver) {
        self.modifer = modifier
        self.context = context
        self.resolver = resolver
    }

    open func update(_ modifier: Modifier, context: Context) {
        self.modifer = modifier
        self.context = context
    }

    open func layoutSize(fitting size: CGSize, node: AnyUIKitNode) -> CGSize {
        return node.layoutSize(fitting: size)
    }

    open func layout(_ node: AnyUIKitNode, in parent: UIView, bounds: CGRect) {
        node.layout(in: parent, bounds: bounds)
    }

    open func layoutPriorityFor(_ node: AnyUIKitNode) -> Double {
        return node.layoutPriority()
    }
}

extension UIKitNodeModifier: AnyUIKitNodeModifier {

    public static var modifierType: ViewModifier.Type {
        return Modifier.self
    }

    public static func make(_ modifier: ViewModifier, context: Context, resolver: UIKitNodeResolver) -> AnyUIKitNodeModifier {
        return Self.init(modifier as! Modifier, context: context, resolver: resolver)
    }

    public func update(_ modifier: ViewModifier, context: Context) {
        update(modifier as! Modifier, context: context)
    }
}
