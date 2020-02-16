// MIT License
//
// Copyright (c) 2020 Declarative Hub
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Mockingbird
import ReactiveKit

class ViewNode: BaseUIKitNode<AnyView, StaticGeometry, NoRenderable> {

    override var hierarchyIdentifier: String {
        "View(\(node.hierarchyIdentifier))"
    }

    override var layoutableChildNodes: [LayoutableNode] {
        [node]
    }

    var propertyStorage: [String: Any] = [:]
    var node: UIKitNode!
    var observedObjectsCancellables: [AnyCancellable] = []
    var needsViewUpdate: Bool = false

    override func update(_ view: AnyView, context: Context) {
        super.update(view, context: context)
        observeStateProperties(of: view.content)
        ViewNode.configureEnvironmentObjectProperties(of: view.content, context: context)
        self.node = view.body.resolve(context: context, cachedNode: node)
        self.node.didMoveToParent(self)
    }

    private func updateViewIfNeeded() {
        if needsViewUpdate {
            needsViewUpdate = false
            update(view, context: context)
            invalidateRenderingState()
        }
    }

    override func calculateGeometry(fitting targetSize: CGSize) -> StaticGeometry {
        StaticGeometry(idealSize: node.layoutSize(fitting: targetSize))
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
                    self.contentWillChange()
                }
            } else if let property = value as? EnvironmentObjectProperty {
                let key = property.storage.objectTypeIdentifier
                property.storage.get = { [unowned self] in self.context.environmentObjects[key]! }
                property.storage.set = { [unowned self] in self.context.environmentObjects[key] = $0 }
            } else if let property = value as? ObservedObjectProperty {
                property.objectWillChange
                    .sink { [weak self] in
                        self?.contentWillChange()
                    }
                    .store(in: &observedObjectsCancellables)
            }
        }
    }

    private func contentWillChange() {
        DispatchQueue.main.async {
            self.needsViewUpdate = true
            self.updateViewIfNeeded()
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
