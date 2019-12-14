//
//  ViewNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird
import ReactiveKit

class ViewNode: UIKitNode<AnyView> {

    override var hierarchyIdentifier: String {
        return "V[\(node.hierarchyIdentifier)]"
    }

    var propertyStorage: [String: Any] = [:]
    var node: AnyUIKitNode
    var observedObjectsCancellables: [AnyCancellable] = []

    required init( _ view: AnyView, context: Context) {
        ViewNode.configureEnvironmentObjectProperties(of: view.content, context: context)
        self.node = view.body.resolve(context: context, cachedNode: nil)
        super.init(view, context: context)
        self.node.parentNode = self
        observeStateProperties(of: view.content)
    }

    override func update(_ view: AnyView, context: Context) {
        super.update(view, context: context)
        observeStateProperties(of: view.content)
        ViewNode.configureEnvironmentObjectProperties(of: view.content, context: context)
        self.node = view.body.resolve(context: context, cachedNode: node)
        self.node.parentNode = self
    }

    override func layoutSize(fitting targetSize: CGSize) -> CGSize {
        return node.layoutSize(fitting: targetSize)
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        node.layout(in: parent, bounds: bounds)
    }

    private func observeStateProperties(of view: View) {
        observedObjectsCancellables = []
        let mirror = Mirror(reflecting: view)
        for (label, value) in mirror.children where label != nil {
            if let property = value as? StateProperty {
                if propertyStorage[label!] == nil { propertyStorage[label!] = property.storage.initialValue }
                property.storage.get = { [unowned self] in self.propertyStorage[label!]! }
                property.storage.set = { [unowned self] in
                    self.propertyStorage[label!] = $0;
                    self.update(self.view, context: self.context)
                }
            } else if let property = value as? EnvironmentObjectProperty {
                let key = property.storage.objectTypeIdentifier
                property.storage.get = { [unowned self] in self.context.environmentObjects[key]! }
                property.storage.set = { [unowned self] in self.context.environmentObjects[key] = $0 }
            } else if let property = value as? ObservedObjectProperty {
                property.objectWillChange
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        guard let self = self else { return }
                        self.update(self.view, context: self.context)
                    }
                    .store(in: &observedObjectsCancellables)
            }
        }
    }

    private static func configureEnvironmentObjectProperties(of view: View, context: Context) {
        let mirror = Mirror(reflecting: view)
        for (label, value) in mirror.children where label != nil {
            if let property = value as? EnvironmentObjectProperty {
                let key = property.storage.objectTypeIdentifier
                property.storage.get = {
                    if let object = context.environmentObjects[key] {
                        return object
                    } else {
                        fatalError("Environment object of type \(key) not found.")
                    }
                }
                property.storage.set = { _ in fatalError() }
            }
        }
    }
}
